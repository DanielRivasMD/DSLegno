----------------------------------------------------------------------------------------------------
-- TRIGGERS WHEN UPDATING DATA (Propagation on Change)
----------------------------------------------------------------------------------------------------

CREATE TRIGGER update_acquisti
  AFTER UPDATE ON tabella_acquisti
  WHEN ( COALESCE(OLD.operazione, 0) <> COALESCE(NEW.operazione, 0) )
BEGIN
  ------------------------------------------------------------------------------
  -- 1. Propagate updated acquisti data into tabella_principale (mark as ACQUISTO).
  ------------------------------------------------------------------------------
  INSERT INTO tabella_principale (
    operazione,
    prestatore_denominazione, prestatore_indirizzo,
    committente_denominazione, committente_indirizzo,
    numero_fattura, giorno_data, importo_totale,
    descrizione, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposta, esigibilita_iva,
    data_riferimento_termini, data_scadenza_pagamento, importo_pagamento,
    typo
  )
  VALUES (
    NEW.operazione,
    NEW.prestatore_denominazione, NEW.prestatore_indirizzo,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.numero_fattura, NEW.giorno_data, NEW.importo_totale,
    NEW.descrizione, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale, NEW.aliquota_iva,
    NEW.imponibile_importo, NEW.imposta, NEW.esigibilita_iva,
    NEW.data_riferimento_termini, NEW.data_scadenza_pagamento, NEW.importo_pagamento,
    'ACQUISTO'
  );

  ------------------------------------------------------------------------------
  -- 2. Purge from tabella_principale any record whose key (operazione) no longer exists in either source.
  ------------------------------------------------------------------------------
  DELETE FROM tabella_principale
  WHERE operazione NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  ------------------------------------------------------------------------------
  -- 3. Update the summary table (tabella_sommario) for NEW.operazione.
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_sommario (
    numero,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  VALUES (
    NEW.operazione,
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(importo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_mc_vendita_pefc FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_vendita FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_vendita_no_iva FROM tabella_sommario WHERE numero = NEW.operazione )
  );

  ------------------------------------------------------------------------------
  -- 4. Update the summary table for OLD.operazione (purging outdated info).
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_sommario (
    numero,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  VALUES (
    OLD.operazione,
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = OLD.operazione ),
    ( SELECT SUM(importo_totale) FROM tabella_acquisti WHERE operazione = OLD.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = OLD.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT somma_mc_vendita_pefc FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT somma_eur_vendita FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT somma_eur_vendita_no_iva FROM tabella_sommario WHERE numero = OLD.operazione )
  );

  ------------------------------------------------------------------------------
  -- 5. Purge outdated records from tabella_sommario.
  ------------------------------------------------------------------------------
  DELETE FROM tabella_sommario
  WHERE numero NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  ------------------------------------------------------------------------------
  -- 6. Update monthly aggregations for NEW.operazione.
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_mensile (
    mese_anno,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  VALUES (
    ( SELECT SUBSTR(giorno_data, 1, 7)
      FROM tabella_acquisti
      WHERE operazione = NEW.operazione
      LIMIT 1
    ),
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(importo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione
              LIMIT 1
            )
    ),
    ( SELECT somma_mc_vendita_pefc FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione
              LIMIT 1
            )
    ),
    ( SELECT somma_eur_vendita FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione
              LIMIT 1
            )
    ),
    ( SELECT somma_eur_vendita_no_iva FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione
              LIMIT 1
            )
    )
  );

  ------------------------------------------------------------------------------
  -- 7. Update monthly aggregations for OLD.operazione, grouping by the month.
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_mensile (
    mese_anno,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  SELECT
    SUBSTR(giorno_data, 1, 7),
    SUM(quantita),
    SUM(importo_totale),
    SUM(prezzo_totale),
    NULL, NULL, NULL, NULL
  FROM tabella_acquisti
  WHERE operazione = OLD.operazione
  GROUP BY SUBSTR(giorno_data, 1, 7);

  ------------------------------------------------------------------------------
  -- 8. Purge from tabella_mensile any month that no longer appears in source tables.
  ------------------------------------------------------------------------------
  DELETE FROM tabella_mensile
  WHERE mese_anno NOT IN (
      SELECT DISTINCT SUBSTR(giorno_data, 1, 7)
      FROM tabella_acquisti
      WHERE operazione IS NOT NULL
      UNION
      SELECT DISTINCT SUBSTR(giorno_data, 1, 7)
      FROM tabella_vendite
      WHERE operazione IS NOT NULL
  );

  ------------------------------------------------------------------------------
  -- 9. Update annual aggregations for NEW.operazione.
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_annuale (
    anno,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  VALUES (
    ( SELECT SUBSTR(giorno_data, 1, 4)
      FROM tabella_acquisti
      WHERE operazione = NEW.operazione
      LIMIT 1
    ),
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(importo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_annuale
      WHERE anno = ( SELECT SUBSTR(giorno_data, 1, 4)
                     FROM tabella_acquisti
                     WHERE operazione = NEW.operazione
                     LIMIT 1 )
    ),
    ( SELECT somma_mc_vendita_pefc FROM tabella_annuale
      WHERE anno = ( SELECT SUBSTR(giorno_data, 1, 4)
                     FROM tabella_acquisti
                     WHERE operazione = NEW.operazione
                     LIMIT 1 )
    ),
    ( SELECT somma_eur_vendita FROM tabella_annuale
      WHERE anno = ( SELECT SUBSTR(giorno_data, 1, 4)
                     FROM tabella_acquisti
                     WHERE operazione = NEW.operazione
                     LIMIT 1 )
    ),
    ( SELECT somma_eur_vendita_no_iva FROM tabella_annuale
      WHERE anno = ( SELECT SUBSTR(giorno_data, 1, 4)
                     FROM tabella_acquisti
                     WHERE operazione = NEW.operazione
                     LIMIT 1 )
    )
  );

  ------------------------------------------------------------------------------
  -- 10. Update annual aggregations for OLD.operazione, grouping by year.
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_annuale (
    anno,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  SELECT
    SUBSTR(giorno_data, 1, 4),
    SUM(quantita),
    SUM(importo_totale),
    SUM(prezzo_totale),
    NULL, NULL, NULL, NULL
  FROM tabella_acquisti
  WHERE operazione = OLD.operazione
  GROUP BY SUBSTR(giorno_data, 1, 4);

  ------------------------------------------------------------------------------
  -- 11. Purge from tabella_annuale any year that no longer appears in source tables.
  ------------------------------------------------------------------------------
  DELETE FROM tabella_annuale
  WHERE anno NOT IN (
      SELECT DISTINCT SUBSTR(giorno_data, 1, 4)
      FROM tabella_acquisti
      WHERE operazione IS NOT NULL
      UNION
      SELECT DISTINCT SUBSTR(giorno_data, 1, 4)
      FROM tabella_vendite
      WHERE operazione IS NOT NULL
  );
END;

----------------------------------------------------------------------------------------------------

CREATE TRIGGER update_vendite
  AFTER UPDATE ON tabella_vendite
  WHEN ( COALESCE(OLD.operazione, 0) <> COALESCE(NEW.operazione, 0) )
BEGIN
  ------------------------------------------------------------------------------
  -- 1. Propagate updated vendite data into tabella_principale (mark as VENDITO)
  ------------------------------------------------------------------------------
  INSERT INTO tabella_principale (
    operazione,
    prestatore_denominazione, prestatore_indirizzo,
    committente_denominazione, committente_indirizzo,
    numero_fattura, giorno_data, importo_totale,
    descrizione, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposta, esigibilita_iva,
    data_riferimento_termini, data_scadenza_pagamento, importo_pagamento,
    typo
  )
  VALUES (
    NEW.operazione,
    NEW.prestatore_denominazione, NEW.prestatore_indirizzo,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.numero_fattura, NEW.giorno_data, NEW.importo_totale,
    NEW.descrizione, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale, NEW.aliquota_iva,
    NEW.imponibile_importo, NEW.imposta, NEW.esigibilita_iva,
    NEW.data_riferimento_termini, NEW.data_scadenza_pagamento, NEW.importo_pagamento,
    'VENDITO'
  );

  ------------------------------------------------------------------------------
  -- 2. Purge from tabella_principale any record whose operazione no longer exists
  ------------------------------------------------------------------------------
  DELETE FROM tabella_principale
  WHERE operazione NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  ------------------------------------------------------------------------------
  -- 3. Update tabella_sommario for NEW.operazione (vendite aggregates)
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_sommario (
    numero,
    somma_mc_acquisto,         -- purchase aggregates (NULL for vendite)
    somma_eur_acquisto,        -- purchase aggregates
    somma_eur_acquisto_no_iva,   -- purchase aggregates
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  VALUES (
    NEW.operazione,
    NULL, NULL, NULL,
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione AND pefc = 'si' ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione )
  );

  ------------------------------------------------------------------------------
  -- 4. Update tabella_sommario for OLD.operazione (vendite aggregates)
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_sommario (
    numero,
    somma_mc_acquisto,         
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  VALUES (
    OLD.operazione,
    NULL, NULL, NULL,
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = OLD.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = OLD.operazione AND pefc = 'si' ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite WHERE operazione = OLD.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = OLD.operazione )
  );

  ------------------------------------------------------------------------------
  -- 5. Purge outdated summary records from tabella_sommario
  ------------------------------------------------------------------------------
  DELETE FROM tabella_sommario
  WHERE numero NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  ------------------------------------------------------------------------------
  -- 6. Update monthly aggregations for NEW.operazione from vendite
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_mensile (
    mese_anno,
    somma_mc_acquisto,         -- purchase aggregates (NULL for vendite)
    somma_eur_acquisto,        -- purchase aggregates
    somma_eur_acquisto_no_iva,   -- purchase aggregates
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  VALUES (
    ( SELECT SUBSTR(giorno_data, 1, 7)
      FROM tabella_vendite
      WHERE operazione = NEW.operazione
      LIMIT 1
    ),
    NULL, NULL, NULL,
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione AND pefc = 'si' ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione )
  );

  ------------------------------------------------------------------------------
  -- 7. Update monthly aggregations for OLD.operazione (grouping by month)
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_mensile (
    mese_anno,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  SELECT
    SUBSTR(giorno_data, 1, 7),
    NULL, NULL, NULL,
    SUM(quantita),
    SUM(CASE WHEN pefc = 'si' THEN quantita ELSE 0 END),
    SUM(importo_totale),
    SUM(prezzo_totale)
  FROM tabella_vendite
  WHERE operazione = OLD.operazione
  GROUP BY SUBSTR(giorno_data, 1, 7);

  ------------------------------------------------------------------------------
  -- 8. Purge outdated monthly records from tabella_mensile
  ------------------------------------------------------------------------------
  DELETE FROM tabella_mensile
  WHERE mese_anno NOT IN (
      SELECT DISTINCT SUBSTR(giorno_data, 1, 7)
      FROM tabella_acquisti WHERE operazione IS NOT NULL
      UNION
      SELECT DISTINCT SUBSTR(giorno_data, 1, 7)
      FROM tabella_vendite WHERE operazione IS NOT NULL
  );

  ------------------------------------------------------------------------------
  -- 9. Update annual aggregations for NEW.operazione from vendite
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_annuale (
    anno,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  VALUES (
    ( SELECT SUBSTR(giorno_data, 1, 4)
      FROM tabella_vendite
      WHERE operazione = NEW.operazione
      LIMIT 1
    ),
    NULL, NULL, NULL,
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione AND pefc = 'si' ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione )
  );

  ------------------------------------------------------------------------------
  -- 10. Update annual aggregations for OLD.operazione (grouping by year)
  ------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_annuale (
    anno,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  SELECT
    SUBSTR(giorno_data, 1, 4),
    NULL, NULL, NULL,
    SUM(quantita),
    SUM(CASE WHEN pefc = 'si' THEN quantita ELSE 0 END),
    SUM(importo_totale),
    SUM(prezzo_totale)
  FROM tabella_vendite
  WHERE operazione = OLD.operazione
  GROUP BY SUBSTR(giorno_data, 1, 4);

  ------------------------------------------------------------------------------
  -- 11. Purge outdated annual records from tabella_annuale
  ------------------------------------------------------------------------------
  DELETE FROM tabella_annuale
  WHERE anno NOT IN (
      SELECT DISTINCT SUBSTR(giorno_data, 1, 4)
      FROM tabella_acquisti WHERE operazione IS NOT NULL
      UNION
      SELECT DISTINCT SUBSTR(giorno_data, 1, 4)
      FROM tabella_vendite WHERE operazione IS NOT NULL
  );
END;

----------------------------------------------------------------------------------------------------
