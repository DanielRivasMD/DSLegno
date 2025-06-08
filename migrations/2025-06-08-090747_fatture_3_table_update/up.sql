----------------------------------------------------------------------------------------------------
-- TRIGGERS WHEN UPDATING DATA (Propagation on Change)
----------------------------------------------------------------------------------------------------

/* Trigger for Acquisti:
   Fires after an UPDATE on tabella_acquisti when either "operazione" or "progetto_di_taglio" changes.
*/
CREATE TRIGGER update_acquisti
  AFTER UPDATE ON tabella_acquisti
  WHEN (
       COALESCE(OLD.operazione, 0) <> COALESCE(NEW.operazione, 0)
    OR COALESCE(OLD.progetto_di_taglio, '') <> COALESCE(NEW.progetto_di_taglio, '')
  )
BEGIN
  -----------------------------------------------------------------------------------------------
  -- Propagate new acquisti data into tabella_principale (mark as ACQUISTO)
  -----------------------------------------------------------------------------------------------
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

  -----------------------------------------------------------------------------------------------
  -- Purge outdated records from tabella_principale
  -----------------------------------------------------------------------------------------------
  DELETE FROM tabella_principale
  WHERE id NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  -----------------------------------------------------------------------------------------------
  -- Update tabella_sommario for new acquisti data
  -----------------------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_sommario (
    numero,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  ) VALUES (
    NEW.operazione,
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(importo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_mc_vendita_pefc FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_vendita FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_vendita_no_iva FROM tabella_sommario WHERE numero = NEW.operazione )
  );

  -----------------------------------------------------------------------------------------------
  -- Update tabella_sommario for the OLD acquisti record (purging outdated info)
  -----------------------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_sommario (
    numero,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  ) VALUES (
    OLD.operazione,
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = OLD.operazione ),
    ( SELECT SUM(importo_totale) FROM tabella_acquisti WHERE operazione = OLD.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = OLD.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT somma_mc_vendita_pefc FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT somma_eur_vendita FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT somma_eur_vendita_no_iva FROM tabella_sommario WHERE numero = OLD.operazione )
  );

  -----------------------------------------------------------------------------------------------
  -- Purge outdated summary records from tabella_sommario
  -----------------------------------------------------------------------------------------------
  DELETE FROM tabella_sommario
  WHERE numero NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  -----------------------------------------------------------------------------------------------
  -- Update monthly aggregations from acquisti
  -----------------------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_mensile (
    mese_anno,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  ) VALUES (
    ( SELECT SUBSTR(giorno_data, 1, 7)
      FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(importo_totale) FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT somma_mc_vendita FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT somma_mc_vendita_pefc FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT somma_eur_vendita FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT somma_eur_vendita_no_iva FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    )
  );

  -----------------------------------------------------------------------------------------------
  -- Update annual aggregations from acquisti
  -----------------------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_annuale (
    anno,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  ) VALUES (
    ( SELECT SUBSTR(giorno_data, 1, 4)
      FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(importo_totale) FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT somma_mc_vendita FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT somma_mc_vendita_pefc FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT somma_eur_vendita FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT somma_eur_vendita_no_iva FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione )
    )
  );
END;

/* Trigger for Vendite:
   Fires after an UPDATE on tabella_vendite when the operazione value changes.
*/
CREATE TRIGGER update_vendite
  AFTER UPDATE ON tabella_vendite
  WHEN (OLD.operazione <> NEW.operazione)
BEGIN
  -----------------------------------------------------------------------------------------------
  -- Propagate new vendite data into tabella_principale (mark as VENDITO)
  -----------------------------------------------------------------------------------------------
  INSERT INTO tabella_principale (
    operazione,
    prestatore_denominazione, prestatore_indirizzo,
    committente_denominazione, committente_indirizzo,
    numero_fattura, giorno_data, importo_totale,
    descrizione, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposta, esigibilita_iva,
    data_riferimento_termini, data_scadenza_pagamento, importo_pagamento,
    typo
  ) VALUES (
    NEW.operazione,
    NEW.prestatore_denominazione, NEW.prestatore_indirizzo,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.numero_fattura, NEW.giorno_data, NEW.importo_totale,
    NEW.descrizione, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale, NEW.aliquota_iva,
    NEW.imponibile_importo, NEW.imposta, NEW.esigibilita_iva,
    NEW.data_riferimento_termini, NEW.data_scadenza_pagamento, NEW.importo_pagamento,
    'VENDITO'
  );

  -----------------------------------------------------------------------------------------------
  -- Purge outdated records from tabella_principale
  -----------------------------------------------------------------------------------------------
  DELETE FROM tabella_principale
  WHERE id NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  -----------------------------------------------------------------------------------------------
  -- Update tabella_sommario for new vendite data
  -----------------------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_sommario (
    numero,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  ) VALUES (
    NEW.operazione,
    NULL, NULL, NULL,  -- purchase aggregates remain NULL
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione AND pefc = 'si' ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione )
  );

  -----------------------------------------------------------------------------------------------
  -- Update tabella_sommario for the OLD vendite record (purging outdated info)
  -----------------------------------------------------------------------------------------------
  INSERT OR REPLACE INTO tabella_sommario (
    numero,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  ) VALUES (
    OLD.operazione,
    NULL, NULL, NULL,
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = OLD.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = OLD.operazione AND pefc = 'si' ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite WHERE operazione = OLD.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = OLD.operazione )
  );

  -----------------------------------------------------------------------------------------------
  -- Purge outdated records from tabella_sommario
  -----------------------------------------------------------------------------------------------
  DELETE FROM tabella_sommario
  WHERE numero NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  -----------------------------------------------------------------------------------------------
  -- Update monthly aggregations for vendite
  -----------------------------------------------------------------------------------------------
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
    ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    NULL, NULL, NULL,
    ( SELECT SUM(quantita) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(quantita) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione )
      AND pefc = 'si'
    ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione )
    )
  );

  -----------------------------------------------------------------------------------------------
  -- Update annual aggregations for vendite
  -----------------------------------------------------------------------------------------------
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
    ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    NULL, NULL, NULL,
    ( SELECT SUM(quantita) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_vendite WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(quantita) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_vendite WHERE operazione = NEW.operazione )
      AND pefc = 'si'
    ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_vendite WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_vendite WHERE operazione = NEW.operazione )
    )
  );
END;

----------------------------------------------------------------------------------------------------
