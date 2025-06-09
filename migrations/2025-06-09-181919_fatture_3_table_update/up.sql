----------------------------------------------------------------------------------------------------
-- TRIGGERS WHEN UPDATING DATA (Propagation on Change)
----------------------------------------------------------------------------------------------------

CREATE TRIGGER update_acquisti_operazione
  AFTER UPDATE ON tabella_acquisti
  WHEN COALESCE(OLD.operazione, 0) <> COALESCE(NEW.operazione, 0)
BEGIN
  -- Purge the old record (only if OLD.operazione is not NULL)
  DELETE FROM tabella_principale
  WHERE operazione = OLD.operazione
    AND descrizione = OLD.descrizione
    AND numero_fattura = OLD.numero_fattura
    AND typo = 'ACQUISTO';

  -- Import/update the new data into tabella_principale
  INSERT OR REPLACE INTO tabella_principale (
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
END;

----------------------------------------------------------------------------------------------------

CREATE TRIGGER update_vendite_operazione
  AFTER UPDATE ON tabella_vendite
  WHEN COALESCE(OLD.operazione, 0) <> COALESCE(NEW.operazione, 0)
BEGIN
  -- Purge the old record (only if OLD.operazione is not NULL)
  DELETE FROM tabella_principale
  WHERE operazione = OLD.operazione
    AND descrizione = OLD.descrizione
    AND numero_fattura = OLD.numero_fattura
    AND typo = 'VENDUTO';

  -- Import/update the new data into tabella_principale
  INSERT OR REPLACE INTO tabella_principale (
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
    'VENDUTO'
  );
END;

----------------------------------------------------------------------------------------------------

CREATE TRIGGER recalc_targets
  AFTER UPDATE ON tabella_principale
BEGIN
  -- Remove all current aggregates from the target tables.
  DELETE FROM tabella_sommario;
  DELETE FROM tabella_mensile;
  DELETE FROM tabella_annuale;

  ---------------------------------------------------------------------
  -- Recalculate summary aggregates grouped by operazione.
  ---------------------------------------------------------------------
  INSERT INTO tabella_sommario (
    numero,
    somma_mc_acquisto,
    somma_eur_acquisto,
    somma_eur_acquisto_no_iva,
    somma_mc_vendita,
    somma_mc_vendita_pefc,
    somma_eur_vendita,
    somma_eur_vendita_no_iva
  )
  SELECT 
    operazione AS numero,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END) AS somma_mc_acquisto,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END) AS somma_eur_acquisto,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END) AS somma_eur_acquisto_no_iva,
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END) AS somma_mc_vendita,
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END) AS somma_mc_vendita_pefc,
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END) AS somma_eur_vendita,
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END) AS somma_eur_vendita_no_iva
  FROM tabella_principale
  GROUP BY operazione;

  ---------------------------------------------------------------------
  -- Recalculate monthly aggregates grouped by month (from giorno_data).
  ---------------------------------------------------------------------
  INSERT INTO tabella_mensile (
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
    SUBSTR(giorno_data, 1, 7) AS mese_anno,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END) AS somma_mc_acquisto,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END) AS somma_eur_acquisto,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END) AS somma_eur_acquisto_no_iva,
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END) AS somma_mc_vendita,
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END) AS somma_mc_vendita_pefc,
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END) AS somma_eur_vendita,
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END) AS somma_eur_vendita_no_iva
  FROM tabella_principale
  GROUP BY SUBSTR(giorno_data, 1, 7);

  ---------------------------------------------------------------------
  -- Recalculate annual aggregates grouped by year (from giorno_data).
  ---------------------------------------------------------------------
  INSERT INTO tabella_annuale (
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
    SUBSTR(giorno_data, 1, 4) AS anno,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END) AS somma_mc_acquisto,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END) AS somma_eur_acquisto,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END) AS somma_eur_acquisto_no_iva,
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END) AS somma_mc_vendita,
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END) AS somma_mc_vendita_pefc,
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END) AS somma_eur_vendita,
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END) AS somma_eur_vendita_no_iva
  FROM tabella_principale
  GROUP BY SUBSTR(giorno_data, 1, 4);
END;

----------------------------------------------------------------------------------------------------
