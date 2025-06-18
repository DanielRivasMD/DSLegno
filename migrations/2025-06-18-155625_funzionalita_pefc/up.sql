----------------------------------------------------------------------------------------------------

PRAGMA foreign_keys = OFF;

-- 1) Drop only the old insert‐lotto triggers (keep prevent_duplicate_ & delete_lotto)
DROP TRIGGER IF EXISTS insert_acquisti_lotto;
DROP TRIGGER IF EXISTS insert_vendite_lotto;

-- 2) Drop any previous versions of the update_lotto or recalc_targets triggers
DROP TRIGGER IF EXISTS update_acquisti_lotto;
DROP TRIGGER IF EXISTS update_vendite_lotto;
DROP TRIGGER IF EXISTS recalc_targets_after_insert;
DROP TRIGGER IF EXISTS recalc_targets_after_update;
DROP TRIGGER IF EXISTS recalc_targets_after_delete;

-- 3) Reset quantita=1 → NULL on INSERT/UPDATE for acquisti
CREATE TRIGGER reset_quantita_acquisti_ins
  AFTER INSERT ON tabella_acquisti
  FOR EACH ROW WHEN NEW.quantita = 1
BEGIN
  UPDATE tabella_acquisti
     SET quantita = NULL
   WHERE id = NEW.id;
END;
CREATE TRIGGER reset_quantita_acquisti_upd
  AFTER UPDATE ON tabella_acquisti
  FOR EACH ROW WHEN NEW.quantita = 1
BEGIN
  UPDATE tabella_acquisti
     SET quantita = NULL
   WHERE id = NEW.id;
END;

-- 4) Reset quantita=1 → NULL on INSERT/UPDATE for vendite
CREATE TRIGGER reset_quantita_vendite_ins
  AFTER INSERT ON tabella_vendite
  FOR EACH ROW WHEN NEW.quantita = 1
BEGIN
  UPDATE tabella_vendite
     SET quantita = NULL
   WHERE id = NEW.id;
END;
CREATE TRIGGER reset_quantita_vendite_upd
  AFTER UPDATE ON tabella_vendite
  FOR EACH ROW WHEN NEW.quantita = 1
BEGIN
  UPDATE tabella_vendite
     SET quantita = NULL
   WHERE id = NEW.id;
END;

-- 5) Propagate on lotto‐change for acquisti
CREATE TRIGGER update_acquisti_lotto
  AFTER UPDATE OF lotto ON tabella_acquisti
  FOR EACH ROW
  WHEN NEW.attiva = 'si'
BEGIN
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
  INSERT OR REPLACE INTO tabella_principale (
    lotto, prestatore_denominazione, prestatore_indirizzo,
    committente_denominazione, committente_indirizzo,
    numero_fattura, giorno_data, importo_totale,
    descrizione, quantita, prezzo_unitario, prezzo_totale,
    aliquota_iva, imponibile_importo, imposta,
    esigibilita_iva, data_riferimento_termini,
    data_scadenza_pagamento, importo_pagamento, typo
  ) VALUES (
    NEW.lotto, NEW.prestatore_denominazione, NEW.prestatore_indirizzo,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.numero_fattura, NEW.giorno_data, NEW.importo_totale,
    NEW.descrizione, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale,
    NEW.aliquota_iva, NEW.imponibile_importo, NEW.imposta,
    NEW.esigibilita_iva, NEW.data_riferimento_termini,
    NEW.data_scadenza_pagamento, NEW.importo_pagamento, 'ACQUISTO'
  );
END;

-- 6) Propagate on lotto‐ or pefc‐change for vendite
CREATE TRIGGER update_vendite_lotto
  AFTER UPDATE OF lotto, pefc ON tabella_vendite
  FOR EACH ROW
  WHEN NEW.attiva = 'si'
BEGIN
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
  INSERT OR REPLACE INTO tabella_principale (
    lotto, prestatore_denominazione, prestatore_indirizzo,
    committente_denominazione, committente_indirizzo,
    numero_fattura, giorno_data, importo_totale,
    descrizione, quantita, prezzo_unitario, prezzo_totale,
    aliquota_iva, imponibile_importo, imposta,
    esigibilita_iva, data_riferimento_termini,
    data_scadenza_pagamento, importo_pagamento, typo, pefc
  ) VALUES (
    NEW.lotto, NEW.prestatore_denominazione, NEW.prestatore_indirizzo,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.numero_fattura, NEW.giorno_data, NEW.importo_totale,
    NEW.descrizione, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale,
    NEW.aliquota_iva, NEW.imponibile_importo, NEW.imposta,
    NEW.esigibilita_iva, NEW.data_riferimento_termini,
    NEW.data_scadenza_pagamento, NEW.importo_pagamento, 'VENDUTO', NEW.pefc
  );
END;

-- 7) Re‐calculate summaries after INSERT
CREATE TRIGGER recalc_targets_after_insert
  AFTER INSERT ON tabella_principale
  FOR EACH ROW
BEGIN
  -- daily
  INSERT OR REPLACE INTO tabella_sommario (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_eur_acquisto_no_iva,
    somma_mc_vendita, somma_mc_vendita_pefc,
    somma_eur_vendita, somma_eur_vendita_no_iva
  )
  SELECT
    NEW.lotto,
    SUM(CASE WHEN typo='ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN prezzo_totale  ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO' AND coalesce(pefc,'no')='si'
             THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN prezzo_totale  ELSE 0 END)
  FROM tabella_principale
   WHERE lotto = NEW.lotto
  GROUP BY lotto;

  -- monthly
  INSERT OR REPLACE INTO tabella_mensile (
    mese_anno, somma_mc_acquisto, somma_eur_acquisto, somma_eur_acquisto_no_iva,
    somma_mc_vendita, somma_mc_vendita_pefc,
    somma_eur_vendita, somma_eur_vendita_no_iva
  )
  SELECT
    strftime('%Y-%m', NEW.giorno_data),
    SUM(CASE WHEN typo='ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN prezzo_totale  ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO' AND coalesce(pefc,'no')='si'
             THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN prezzo_totale  ELSE 0 END)
  FROM tabella_principale
   WHERE strftime('%Y-%m', giorno_data) = strftime('%Y-%m', NEW.giorno_data)
  GROUP BY strftime('%Y-%m', giorno_data);

  -- annual
  INSERT OR REPLACE INTO tabella_annuale (
    anno, somma_mc_acquisto, somma_eur_acquisto, somma_eur_acquisto_no_iva,
    somma_mc_vendita, somma_mc_vendita_pefc,
    somma_eur_vendita, somma_eur_vendita_no_iva
  )
  SELECT
    strftime('%Y', NEW.giorno_data),
    SUM(CASE WHEN typo='ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN prezzo_totale  ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO' AND coalesce(pefc,'no')='si'
             THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN prezzo_totale  ELSE 0 END)
  FROM tabella_principale
   WHERE strftime('%Y', giorno_data) = strftime('%Y', NEW.giorno_data)
  GROUP BY strftime('%Y', giorno_data);
END;

-- 8) Re‐calculate summaries after UPDATE or DELETE
CREATE TRIGGER recalc_targets_after_update
  AFTER UPDATE ON tabella_principale
  FOR EACH ROW
BEGIN
  -- Reuse the same logic as insert: delete then re‐insert the affected groups
  DELETE FROM tabella_sommario      WHERE numero = OLD.lotto;
  DELETE FROM tabella_mensile       WHERE mese_anno = strftime('%Y-%m', OLD.giorno_data);
  DELETE FROM tabella_annuale       WHERE anno = strftime('%Y',    OLD.giorno_data);

  -- Fire the INSERT logic for NEW (to recalc)
  INSERT OR REPLACE INTO tabella_sommario (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_eur_acquisto_no_iva,
    somma_mc_vendita, somma_mc_vendita_pefc,
    somma_eur_vendita, somma_eur_vendita_no_iva
  )
  SELECT
    NEW.lotto,
    SUM(CASE WHEN typo='ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN prezzo_totale  ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO' AND coalesce(pefc,'no')='si'
             THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN prezzo_totale  ELSE 0 END)
  FROM tabella_principale
   WHERE lotto = NEW.lotto
  GROUP BY lotto;

  INSERT OR REPLACE INTO tabella_mensile (
    mese_anno, somma_mc_acquisto, somma_eur_acquisto, somma_eur_acquisto_no_iva,
    somma_mc_vendita, somma_mc_vendita_pefc,
    somma_eur_vendita, somma_eur_vendita_no_iva
  )
  SELECT
    strftime('%Y-%m', NEW.giorno_data),
    SUM(CASE WHEN typo='ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN prezzo_totale  ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO' AND coalesce(pefc,'no')='si'
             THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN prezzo_totale  ELSE 0 END)
  FROM tabella_principale
   WHERE strftime('%Y-%m', giorno_data) = strftime('%Y-%m', NEW.giorno_data)
  GROUP BY strftime('%Y-%m', giorno_data);

  INSERT OR REPLACE INTO tabella_annuale (
    anno, somma_mc_acquisto, somma_eur_acquisto, somma_eur_acquisto_no_iva,
    somma_mc_vendita, somma_mc_vendita_pefc,
    somma_eur_vendita, somma_eur_vendita_no_iva
  )
  SELECT
    strftime('%Y', NEW.giorno_data),
    SUM(CASE WHEN typo='ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN prezzo_totale  ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO' AND coalesce(pefc,'no')='si'
             THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN prezzo_totale  ELSE 0 END)
  FROM tabella_principale
    WHERE strftime('%Y', giorno_data) = strftime('%Y', NEW.giorno_data)
  GROUP BY strftime('%Y', NEW.giorno_data);
END;

-- 9) Re‐calculate summaries after DELETE
CREATE TRIGGER recalc_targets_after_delete
  AFTER DELETE ON tabella_principale
  FOR EACH ROW
BEGIN
  -- Remove any stale summary rows for this lotto / month / year
  DELETE FROM tabella_sommario
   WHERE numero    = OLD.lotto;
  DELETE FROM tabella_mensile
   WHERE mese_anno = strftime('%Y-%m', OLD.giorno_data);
  DELETE FROM tabella_annuale
   WHERE anno      = strftime('%Y',    OLD.giorno_data);

  -- Re‐insert daily summary for this lotto if any rows remain
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
  SELECT
    OLD.lotto                                   AS numero,
    SUM(CASE WHEN typo='ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN prezzo_totale  ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  AND coalesce(pefc,'no')='si' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN prezzo_totale  ELSE 0 END)
  FROM tabella_principale
  WHERE lotto = OLD.lotto
  GROUP BY lotto;

  -- Re‐insert monthly summary for this YYYY-MM if any rows remain
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
    strftime('%Y-%m', OLD.giorno_data)                                    AS mese_anno,
    SUM(CASE WHEN typo='ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN prezzo_totale  ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  AND coalesce(pefc,'no')='si' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN prezzo_totale  ELSE 0 END)
  FROM tabella_principale
  WHERE strftime('%Y-%m', giorno_data) = strftime('%Y-%m', OLD.giorno_data)
  GROUP BY strftime('%Y-%m', giorno_data);

  -- Re‐insert annual summary for this YYYY if any rows remain
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
    strftime('%Y', OLD.giorno_data)                                      AS anno,
    SUM(CASE WHEN typo='ACQUISTO' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='ACQUISTO' THEN prezzo_totale  ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  AND coalesce(pefc,'no')='si' THEN quantita ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN importo_totale ELSE 0 END),
    SUM(CASE WHEN typo='VENDUTO'  THEN prezzo_totale  ELSE 0 END)
  FROM tabella_principale
  WHERE strftime('%Y', giorno_data) = strftime('%Y', OLD.giorno_data)
  GROUP BY strftime('%Y', giorno_data);
END;


PRAGMA foreign_keys = ON;

----------------------------------------------------------------------------------------------------
