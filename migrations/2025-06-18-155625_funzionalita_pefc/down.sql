----------------------------------------------------------------------------------------------------

PRAGMA foreign_keys = OFF;

-- 1) Drop all newly created triggers (keep prevent_duplicate_ & delete_lotto)
DROP TRIGGER IF EXISTS insert_acquisti_lotto;
DROP TRIGGER IF EXISTS insert_vendite_lotto;
DROP TRIGGER IF EXISTS update_acquisti_lotto;
DROP TRIGGER IF EXISTS update_vendite_lotto;
DROP TRIGGER IF EXISTS recalc_targets_after_insert;
DROP TRIGGER IF EXISTS recalc_targets_after_update;
DROP TRIGGER IF EXISTS recalc_targets_after_delete;


-- 2) Re-create your old triggers exactly as they were
CREATE TRIGGER insert_acquisti_lotto
  AFTER UPDATE ON tabella_acquisti
  WHEN COALESCE(OLD.lotto, 0) <> COALESCE(NEW.lotto, 0)
BEGIN
  -- Remove any existing ACQUISTO row under old or new key
  DELETE FROM tabella_principale
   WHERE typo = 'ACQUISTO'
     AND (
           (lotto = OLD.lotto
            AND descrizione = OLD.descrizione
            AND numero_fattura = OLD.numero_fattura)
        OR (lotto = NEW.lotto
            AND descrizione = NEW.descrizione
            AND numero_fattura = NEW.numero_fattura)
         );

  -- Insert or replace with the updated acquisto
  INSERT OR REPLACE INTO tabella_principale (
    lotto,
    prestatore_denominazione,
    prestatore_indirizzo,
    committente_denominazione,
    committente_indirizzo,
    numero_fattura,
    giorno_data,
    importo_totale,
    descrizione,
    quantita,
    prezzo_unitario,
    prezzo_totale,
    aliquota_iva,
    imponibile_importo,
    imposta,
    esigibilita_iva,
    data_riferimento_termini,
    data_scadenza_pagamento,
    importo_pagamento,
    typo
  )
  VALUES (
    NEW.lotto,
    NEW.prestatore_denominazione,
    NEW.prestatore_indirizzo,
    NEW.committente_denominazione,
    NEW.committente_indirizzo,
    NEW.numero_fattura,
    NEW.giorno_data,
    NEW.importo_totale,
    NEW.descrizione,
    NEW.quantita,
    NEW.prezzo_unitario,
    NEW.prezzo_totale,
    NEW.aliquota_iva,
    NEW.imponibile_importo,
    NEW.imposta,
    NEW.esigibilita_iva,
    NEW.data_riferimento_termini,
    NEW.data_scadenza_pagamento,
    NEW.importo_pagamento,
    'ACQUISTO'
  );
END;


CREATE TRIGGER insert_vendite_lotto
  AFTER UPDATE ON tabella_vendite
  WHEN COALESCE(OLD.lotto, 0) <> COALESCE(NEW.lotto, 0)
BEGIN
  -- Remove any existing VENDUTO row under old or new key
  DELETE FROM tabella_principale
   WHERE typo = 'VENDUTO'
     AND (
           (lotto = OLD.lotto
            AND descrizione = OLD.descrizione
            AND numero_fattura = OLD.numero_fattura)
        OR (lotto = NEW.lotto
            AND descrizione = NEW.descrizione
            AND numero_fattura = NEW.numero_fattura)
         );

  -- Insert or replace with the updated vendite
  INSERT OR REPLACE INTO tabella_principale (
    lotto,
    prestatore_denominazione,
    prestatore_indirizzo,
    committente_denominazione,
    committente_indirizzo,
    numero_fattura,
    giorno_data,
    importo_totale,
    descrizione,
    quantita,
    prezzo_unitario,
    prezzo_totale,
    aliquota_iva,
    imponibile_importo,
    imposta,
    esigibilita_iva,
    data_riferimento_termini,
    data_scadenza_pagamento,
    importo_pagamento,
    typo
  )
  VALUES (
    NEW.lotto,
    NEW.prestatore_denominazione,
    NEW.prestatore_indirizzo,
    NEW.committente_denominazione,
    NEW.committente_indirizzo,
    NEW.numero_fattura,
    NEW.giorno_data,
    NEW.importo_totale,
    NEW.descrizione,
    NEW.quantita,
    NEW.prezzo_unitario,
    NEW.prezzo_totale,
    NEW.aliquota_iva,
    NEW.imponibile_importo,
    NEW.imposta,
    NEW.esigibilita_iva,
    NEW.data_riferimento_termini,
    NEW.data_scadenza_pagamento,
    NEW.importo_pagamento,
    'VENDUTO'
  );
END;


CREATE TRIGGER update_acquisti_lotto
  AFTER UPDATE ON tabella_acquisti
  WHEN COALESCE(OLD.lotto, 0) <> COALESCE(NEW.lotto, 0)
BEGIN
  -- Purge the old record (only if OLD.lotto is not NULL)
  DELETE FROM tabella_principale
  WHERE lotto = OLD.lotto
    AND descrizione = OLD.descrizione
    AND numero_fattura = OLD.numero_fattura
    AND typo = 'ACQUISTO';

  -- Import/update the new data into tabella_principale
  INSERT OR REPLACE INTO tabella_principale (
    lotto,
    prestatore_denominazione, prestatore_indirizzo,
    committente_denominazione, committente_indirizzo,
    numero_fattura, giorno_data, importo_totale,
    descrizione, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposta, esigibilita_iva,
    data_riferimento_termini, data_scadenza_pagamento, importo_pagamento,
    typo
  )
  VALUES (
    NEW.lotto,
    NEW.prestatore_denominazione, NEW.prestatore_indirizzo,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.numero_fattura, NEW.giorno_data, NEW.importo_totale,
    NEW.descrizione, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale, NEW.aliquota_iva,
    NEW.imponibile_importo, NEW.imposta, NEW.esigibilita_iva,
    NEW.data_riferimento_termini, NEW.data_scadenza_pagamento, NEW.importo_pagamento,
    'ACQUISTO'
  );
END;


CREATE TRIGGER update_vendite_lotto
  AFTER UPDATE ON tabella_vendite
  WHEN COALESCE(OLD.lotto, 0) <> COALESCE(NEW.lotto, 0)
BEGIN
  -- Purge the old record (only if OLD.lotto is not NULL)
  DELETE FROM tabella_principale
  WHERE lotto = OLD.lotto
    AND descrizione = OLD.descrizione
    AND numero_fattura = OLD.numero_fattura
    AND typo = 'VENDUTO';

  -- Import/update the new data into tabella_principale
  INSERT OR REPLACE INTO tabella_principale (
    lotto,
    prestatore_denominazione, prestatore_indirizzo,
    committente_denominazione, committente_indirizzo,
    numero_fattura, giorno_data, importo_totale,
    descrizione, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposta, esigibilita_iva,
    data_riferimento_termini, data_scadenza_pagamento, importo_pagamento,
    typo
  )
  VALUES (
    NEW.lotto,
    NEW.prestatore_denominazione, NEW.prestatore_indirizzo,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.numero_fattura, NEW.giorno_data, NEW.importo_totale,
    NEW.descrizione, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale, NEW.aliquota_iva,
    NEW.imponibile_importo, NEW.imposta, NEW.esigibilita_iva,
    NEW.data_riferimento_termini, NEW.data_scadenza_pagamento, NEW.importo_pagamento,
    'VENDUTO'
  );
END;


CREATE TRIGGER recalc_targets_after_insert
  AFTER INSERT ON tabella_principale
BEGIN
  -- Purge existing aggregates
  DELETE FROM tabella_sommario;
  DELETE FROM tabella_mensile;
  DELETE FROM tabella_annuale;

  -- Recalculate summary aggregates grouped by lotto.
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
    lotto AS numero,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END)
  FROM tabella_principale
  GROUP BY lotto;

  -- Recalculate monthly aggregates (group by year-month from giorno_data)
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
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END)
  FROM tabella_principale
  GROUP BY SUBSTR(giorno_data, 1, 7);

  -- Recalculate annual aggregates (group by year from giorno_data)
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
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END)
  FROM tabella_principale
  GROUP BY SUBSTR(giorno_data, 1, 4);
END;


CREATE TRIGGER recalc_targets_after_update
  AFTER UPDATE ON tabella_principale
BEGIN
  -- Same code as above.
  DELETE FROM tabella_sommario;
  DELETE FROM tabella_mensile;
  DELETE FROM tabella_annuale;

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
    lotto AS numero,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END)
  FROM tabella_principale
  GROUP BY lotto;

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
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END)
  FROM tabella_principale
  GROUP BY SUBSTR(giorno_data, 1, 7);

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
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END)
  FROM tabella_principale
  GROUP BY SUBSTR(giorno_data, 1, 4);
END;


CREATE TRIGGER recalc_targets_after_delete
  AFTER DELETE ON tabella_principale
BEGIN
  -- The same full recalculation.
  DELETE FROM tabella_sommario;
  DELETE FROM tabella_mensile;
  DELETE FROM tabella_annuale;

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
    lotto AS numero,
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END)
  FROM tabella_principale
  GROUP BY lotto;

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
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END)
  FROM tabella_principale
  GROUP BY SUBSTR(giorno_data, 1, 7);

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
    SUM(CASE WHEN typo = 'ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'ACQUISTO' THEN prezzo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo = 'VENDUTO' THEN prezzo_totale ELSE 0 END)
  FROM tabella_principale
  GROUP BY SUBSTR(giorno_data, 1, 4);
END;


PRAGMA foreign_keys = ON;

----------------------------------------------------------------------------------------------------
