----------------------------------------------------------------------------------------------------
-- TRIGGERS WHEN INSERTING DATA
----------------------------------------------------------------------------------------------------

/* Trigger for Acquisti:
   When a new row is inserted into tabella_acquisti and either "operazione" or "progetto_di_taglio" is not NULL,
   first check if an identical record (comparing non‑editable columns) already exists in tabella_principale.
   If not, propagate the data into the aggregate tables.
*/
CREATE TRIGGER insert_acquisti
  AFTER INSERT ON tabella_acquisti
  WHEN (NEW.operazione IS NOT NULL OR NEW.progetto_di_taglio IS NOT NULL)
BEGIN
  -----------------------------------------------------------------------------------------------
  -- Propagate into tabella_principale (mark as ACQUISTO) only if an identical record is not found.
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
  SELECT
    NEW.operazione,
    NEW.prestatore_denominazione, NEW.prestatore_indirizzo,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.numero_fattura, NEW.giorno_data, NEW.importo_totale,
    NEW.descrizione, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale, NEW.aliquota_iva,
    NEW.imponibile_importo, NEW.imposta, NEW.esigibilita_iva,
    NEW.data_riferimento_termini, NEW.data_scadenza_pagamento, NEW.importo_pagamento,
    'ACQUISTO'
  WHERE NOT EXISTS (
      SELECT 1 FROM tabella_principale
      WHERE 
            -- Compare the non‑editable columns.
            prestatore_denominazione = NEW.prestatore_denominazione
        AND prestatore_indirizzo = NEW.prestatore_indirizzo
        AND committente_denominazione = NEW.committente_denominazione
        AND committente_indirizzo = NEW.committente_indirizzo
        AND numero_fattura = NEW.numero_fattura
        AND giorno_data = NEW.giorno_data
        AND importo_totale = NEW.importo_totale
        AND descrizione = NEW.descrizione
        AND quantita = NEW.quantita
        AND prezzo_unitario = NEW.prezzo_unitario
        AND prezzo_totale = NEW.prezzo_totale
        AND aliquota_iva = NEW.aliquota_iva
        AND imponibile_importo = NEW.imponibile_importo
        AND imposta = NEW.imposta
        AND esigibilita_iva = NEW.esigibilita_iva
        AND data_riferimento_termini = NEW.data_riferimento_termini
        AND data_scadenza_pagamento = NEW.data_scadenza_pagamento
        AND importo_pagamento = NEW.importo_pagamento
  );

  -----------------------------------------------------------------------------------------------
  -- Update tabella_sommario using acquisti data (for purchase aggregates)
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
    NULL, NULL, NULL, NULL
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
  )
  VALUES (
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
    NULL, NULL, NULL, NULL
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
  )
  VALUES (
    ( SELECT SUBSTR(giorno_data, 1, 4)
      FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_acquisti 
      WHERE SUBSTR(giorno_data, 1, 4) = 
            ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(importo_totale) FROM tabella_acquisti 
      WHERE SUBSTR(giorno_data, 1, 4) = 
            ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti 
      WHERE SUBSTR(giorno_data, 1, 4) = 
            ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_acquisti WHERE operazione = NEW.operazione )
    ),
    NULL, NULL, NULL, NULL
  );
END;

----------------------------------------------------------------------------------------------------
/* Trigger for Vendite:
   When a new row is inserted into tabella_vendite with operazione not NULL,
   propagate the data into the main table and update the sales-related summary.
*/
CREATE TRIGGER insert_vendite
  AFTER INSERT ON tabella_vendite
  WHEN (NEW.operazione IS NOT NULL)
BEGIN
  -----------------------------------------------------------------------------------------------
  -- Propagate into tabella_principale (mark as VENDITO)
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
  -- Update tabella_sommario using vendite data (for sales aggregates)
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
    NULL, NULL, NULL,  -- purchase aggregates remain NULL
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
    NULL, NULL, NULL,  -- purchase aggregates remain NULL
    ( SELECT SUM(quantita) FROM tabella_vendite
      WHERE operazione = NEW.operazione
      AND SUBSTR(giorno_data, 1, 4) = ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(quantita) FROM tabella_vendite
      WHERE operazione = NEW.operazione
      AND SUBSTR(giorno_data, 1, 4) = ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione )
      AND pefc = 'si'
    ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite
      WHERE operazione = NEW.operazione
      AND SUBSTR(giorno_data, 1, 4) = ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione )
    ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite
      WHERE operazione = NEW.operazione
      AND SUBSTR(giorno_data, 1, 4) = ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione )
    )
  );
END;

----------------------------------------------------------------------------------------------------
