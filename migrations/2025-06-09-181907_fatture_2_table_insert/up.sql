----------------------------------------------------------------------------------------------------
-- TRIGGERS WHEN INSERTING DATA
----------------------------------------------------------------------------------------------------

-- Prevent duplicate rows in tabella_acquisti based on descrizione and numero_fattura
CREATE TRIGGER prevent_duplicate_acquisti
  BEFORE INSERT ON tabella_acquisti
BEGIN
  SELECT CASE
    WHEN EXISTS (
      SELECT 1 
      FROM tabella_acquisti
      WHERE descrizione = NEW.descrizione
        AND numero_fattura = NEW.numero_fattura
    )
    THEN RAISE(IGNORE)
  END;
END;

CREATE TRIGGER delete_acquisti_lotto
  AFTER DELETE ON tabella_acquisti
BEGIN
  DELETE FROM tabella_principale
  WHERE lotto = OLD.lotto
    AND descrizione = OLD.descrizione
    AND numero_fattura = OLD.numero_fattura
    AND typo = 'ACQUISTO';
END;

-- When the column "lotto" is updated (from NULL to an integer or from one integer to another),
-- first purge the old record in tabella_principale (using the key combination: lotto, descrizione, and numero_fattura)
-- and then import/update the new acquisti record (with 'ACQUISTO').
CREATE TRIGGER insert_acquisti_lotto
  AFTER UPDATE ON tabella_acquisti
  WHEN COALESCE(OLD.lotto, 0) <> COALESCE(NEW.lotto, 0)
BEGIN
  -- Delete any record in tabella_principale that matches either the OLD key or the NEW key.
  DELETE FROM tabella_principale
  WHERE (
         (lotto = OLD.lotto 
          AND descrizione = OLD.descrizione 
          AND numero_fattura = OLD.numero_fattura)
      OR (lotto = NEW.lotto
          AND descrizione = NEW.descrizione
          AND numero_fattura = NEW.numero_fattura)
        )
    AND typo = 'ACQUISTO';
  
  -- Insert or replace the new record into tabella_principale.
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

----------------------------------------------------------------------------------------------------

-- Prevent duplicate rows in tabella_vendite based on descrizione and numero_fattura
CREATE TRIGGER prevent_duplicate_vendite
  BEFORE INSERT ON tabella_vendite
BEGIN
  SELECT CASE
    WHEN EXISTS (
      SELECT 1
      FROM tabella_vendite
      WHERE descrizione = NEW.descrizione
        AND numero_fattura = NEW.numero_fattura
    )
    THEN RAISE(IGNORE)
  END;
END;

-- When a vendite record is deleted, remove the corresponding entry from tabella_principale,
-- matching on lotto, descrizione, and numero_fattura with typo = 'VENDUTO'.
CREATE TRIGGER delete_vendite_lotto
  AFTER DELETE ON tabella_vendite
BEGIN
  DELETE FROM tabella_principale
  WHERE lotto = OLD.lotto
    AND descrizione = OLD.descrizione
    AND numero_fattura = OLD.numero_fattura
    AND typo = 'VENDUTO';
END;

-- When the column "lotto" is updated on tabella_vendite,
-- first purge any record in tabella_principale that matches either the OLD or the NEW key,
-- then insert or replace the updated vendite record into tabella_principale with typo = 'VENDUTO'.
CREATE TRIGGER insert_vendite_lotto
  AFTER UPDATE ON tabella_vendite
  WHEN COALESCE(OLD.lotto, 0) <> COALESCE(NEW.lotto, 0)
BEGIN
  -- Purge any record that matches either the old key or the new key
  DELETE FROM tabella_principale
  WHERE (
          (lotto = OLD.lotto
           AND descrizione = OLD.descrizione
           AND numero_fattura = OLD.numero_fattura)
       OR (lotto = NEW.lotto
           AND descrizione = NEW.descrizione
           AND numero_fattura = NEW.numero_fattura)
        )
    AND typo = 'VENDUTO';

  -- Import/update the new record into tabella_principale
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

----------------------------------------------------------------------------------------------------
