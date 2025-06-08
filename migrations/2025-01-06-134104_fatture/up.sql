----------------------------------------------------------------------------------------------------
-- TABLE DECLARATIONS
----------------------------------------------------------------------------------------------------

-- Main detailed table for both purchases and sales
CREATE TABLE IF NOT EXISTS tabella_principale
  (
    ----------------------------------------
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    operazione INTEGER,                   -- correlation number (key refined by user update)
    ----------------------------------------
    -----       dettaglio linee        -----
    ----------------------------------------
    descrizione TEXT,                     -- description
    quantita REAL,                        -- amount
    prezzo_unitario REAL,                 -- unit price
    prezzo_totale REAL,                   -- total price
    aliquota_iva REAL,                    -- tax rate
    ----------------------------------------
    -----   dati generali documento    -----
    ----------------------------------------
    numero_fattura TEXT,                  -- invoice number
    giorno_data TEXT,                     -- invoice date
    importo_totale REAL,                  -- total amount
    ----------------------------------------
    -----      cedente prestatore      -----
    ----------------------------------------
    prestatore_denominazione TEXT,        -- seller name
    prestatore_indirizzo TEXT,            -- seller address
    ----------------------------------------
    -----   cessionario committente    -----
    ----------------------------------------
    committente_denominazione TEXT,       -- buyer name
    committente_indirizzo TEXT,           -- buyer address
    ----------------------------------------
    -----        dati riepilogo        -----
    ----------------------------------------
    imponibile_importo REAL,              -- taxable total
    imposta REAL,                         -- tax
    esigibilita_iva CHAR,                 -- tax category flag
    ----------------------------------------
    -----     condizioni pagamento     -----
    ----------------------------------------
    data_riferimento_termini TEXT,        -- payment reference date
    data_scadenza_pagamento TEXT,         -- payment due date
    importo_pagamento REAL,               -- payment amount
    ----------------------------------------
    typo TEXT                             -- transaction type ('ACQUISTO' or 'VENDITO')
    ----------------------------------------
  );

----------------------------------------------------------------------------------------------------
-- Table for purchases (acquisti)
----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabella_acquisti
  (
    ----------------------------------------
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    operazione INTEGER,                   -- correlation number (initially NULL)
    ----------------------------------------
    -----       dettaglio linee        -----
    ----------------------------------------
    progetto_di_taglio TEXT,              -- cutting project (initially NULL; to be updated by user)
    descrizione TEXT,                     -- description
    quantita REAL,                        -- amount
    prezzo_unitario REAL,                 -- unit price
    prezzo_totale REAL,                   -- total price
    aliquota_iva REAL,                    -- tax rate
    ----------------------------------------
    -----   dati generali documento    -----
    ----------------------------------------
    numero_fattura TEXT,                  -- invoice number
    giorno_data TEXT,                     -- invoice date (format should enable extraction of YYYY-MM and YYYY)
    importo_totale REAL,                  -- total amount
    ----------------------------------------
    -----      cedente prestatore      -----
    ----------------------------------------
    prestatore_denominazione TEXT,        -- seller name
    prestatore_indirizzo TEXT,            -- seller address
    ----------------------------------------
    -----   cessionario committente    -----
    ----------------------------------------
    committente_denominazione TEXT,       -- buyer name
    committente_indirizzo TEXT,           -- buyer address
    ----------------------------------------
    -----        dati riepilogo        -----
    ----------------------------------------
    imponibile_importo REAL,              -- taxable total
    imposta REAL,                         -- tax
    esigibilita_iva CHAR,                 -- tax category flag
    ----------------------------------------
    -----     condizioni pagamento     -----
    ----------------------------------------
    data_riferimento_termini TEXT,        -- payment reference date
    data_scadenza_pagamento TEXT,         -- payment due date
    importo_pagamento REAL                -- payment amount
    ----------------------------------------
  );

----------------------------------------------------------------------------------------------------
-- Table for sales (vendite)
----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabella_vendite
  (
    ----------------------------------------
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    operazione INTEGER,                   -- correlation number (initially NULL)
    ----------------------------------------
    -----       dettaglio linee        -----
    ----------------------------------------
    pefc TEXT,                            -- PEFC flag (e.g., "si")
    descrizione TEXT,                     -- description
    quantita REAL,                        -- amount
    prezzo_unitario REAL,                 -- unit price
    prezzo_totale REAL,                   -- total price
    aliquota_iva REAL,                    -- tax rate
    ----------------------------------------
    -----   dati generali documento    -----
    ----------------------------------------
    numero_fattura TEXT,                  -- invoice number
    giorno_data TEXT,                     -- invoice date
    importo_totale REAL,                  -- total amount
    ----------------------------------------
    -----      cedente prestatore      -----
    ----------------------------------------
    prestatore_denominazione TEXT,        -- seller name
    prestatore_indirizzo TEXT,            -- seller address
    ----------------------------------------
    -----   cessionario committente    -----
    ----------------------------------------
    committente_denominazione TEXT,       -- buyer name
    committente_indirizzo TEXT,           -- buyer address
    ----------------------------------------
    -----        dati riepilogo        -----
    ----------------------------------------
    imponibile_importo REAL,              -- taxable total
    imposta REAL,                         -- tax
    esigibilita_iva CHAR,                 -- tax category flag
    ----------------------------------------
    -----     condizioni pagamento     -----
    ----------------------------------------
    data_riferimento_termini TEXT,        -- payment reference date
    data_scadenza_pagamento TEXT,         -- payment due date
    importo_pagamento REAL                -- payment amount
    ----------------------------------------
  );

----------------------------------------------------------------------------------------------------
-- Daily/Operative Summary Table (sommario)
----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabella_sommario
  (
    numero INTEGER PRIMARY KEY,           -- key (operazione)
    giorno_data TEXT,                     -- date of record
    acquisto TEXT,                        -- placeholder for purchase info
    vendita TEXT,                         -- placeholder for sale info
    somma_mc_acquisto REAL,               -- aggregated purchase quantity
    somma_eur_acquisto REAL,              -- aggregated purchase total (Euro)
    somma_eur_acquisto_no_iva REAL,       -- aggregated purchase total without VAT
    somma_mc_vendita REAL,                -- aggregated sales quantity
    somma_mc_vendita_pefc REAL,           -- aggregated PEFC sales quantity
    somma_eur_vendita REAL,               -- aggregated sales total (Euro)
    somma_eur_vendita_no_iva REAL,        -- aggregated sales total without VAT
    pagamento TEXT                        -- payment status/info
  );

----------------------------------------------------------------------------------------------------
-- Monthly Aggregation Table (mensile)
----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabella_mensile
  (
    numero INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    mese_anno TEXT,                           -- month and year in format YYYY-MM
    somma_mc_acquisto REAL,                   -- total purchase quantity for month
    somma_eur_acquisto REAL,                  -- total purchase amount (Euro) for month
    somma_eur_acquisto_no_iva REAL,           -- purchase total without VAT for month
    somma_mc_vendita REAL,                    -- total sales quantity for month
    somma_mc_vendita_pefc REAL,               -- total PEFC sales quantity for month
    somma_eur_vendita REAL,                   -- total sales amount (Euro) for month
    somma_eur_vendita_no_iva REAL             -- sales amount without VAT for month
  );

----------------------------------------------------------------------------------------------------
-- Annual Aggregation Table (annuale)
----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabella_annuale
  (
    numero INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    anno TEXT,                                -- year (YYYY)
    somma_mc_acquisto REAL,                   -- total purchase quantity for year
    somma_eur_acquisto REAL,                  -- total purchase amount (Euro) for year
    somma_eur_acquisto_no_iva REAL,           -- total purchase amount without VAT for year
    somma_mc_vendita REAL,                    -- total sales quantity for year
    somma_mc_vendita_pefc REAL,               -- total PEFC sales quantity for year
    somma_eur_vendita REAL,                   -- total sales amount (Euro) for year
    somma_eur_vendita_no_iva REAL             -- sales amount without VAT for year
  );

----------------------------------------------------------------------------------------------------
-- TRIGGERS
----------------------------------------------------------------------------------------------------
-- For data imported into tabella_acquisti, propagation occurs when the user updates either
-- the 'operazione' or 'progetto_di_taglio' columns.
CREATE TRIGGER update_acquisti
  AFTER UPDATE ON tabella_acquisti
  WHEN (
       COALESCE(OLD.operazione, 0) <> COALESCE(NEW.operazione, 0)
    OR COALESCE(OLD.progetto_di_taglio, '') <> COALESCE(NEW.progetto_di_taglio, '')
  )
BEGIN

  -----------------------------------------------------------------------------------------------
  -- 1. Update tabella_principale with the new acquisti record
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
  -- 2. Update tabella_sommario for the new acquisti record (NEW.operazione)
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
  -- 3. Update summary for the OLD acquisti record (OLD.operazione)
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
  -- Purge outdated records from tabella_sommario
  -----------------------------------------------------------------------------------------------
  DELETE FROM tabella_sommario
  WHERE numero NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  -----------------------------------------------------------------------------------------------
  -- 4. Update monthly aggregations (tabella_mensile)
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
      FROM tabella_acquisti
      WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(importo_totale)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(prezzo_totale)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_mc_vendita
      FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_mc_vendita_pefc
      FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_vendita
      FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_vendita_no_iva
      FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) )
  );

  -----------------------------------------------------------------------------------------------
  -- 5. Update annual aggregations (tabella_annuale)
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
      FROM tabella_acquisti
      WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(importo_totale)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(prezzo_totale)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_mc_vendita
      FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_mc_vendita_pefc
      FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_vendita
      FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_vendita_no_iva
      FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti
              WHERE operazione = NEW.operazione ) )
  );

END;

----------------------------------------------------------------------------------------------------
-- For data imported into tabella_vendite, propagation occurs when the 'operazione' field changes.
CREATE TRIGGER update_vendite
  AFTER UPDATE ON tabella_vendite
  WHEN ( OLD.operazione IS NOT NEW.operazione )
BEGIN

  -----------------------------------------------------------------------------------------------
  -- 1. Update tabella_principale with the new vendite record
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
  -- 2. Update tabella_sommario for the new vendite record (NEW.operazione)
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
    ( SELECT somma_mc_acquisto FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_acquisto FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_acquisto_no_iva FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione AND pefc = "si" ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione )
  );

  -----------------------------------------------------------------------------------------------
  -- 3. Update summary for the OLD vendite record (OLD.operazione)
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
    ( SELECT somma_mc_acquisto FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT somma_eur_acquisto FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT somma_eur_acquisto_no_iva FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = OLD.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = OLD.operazione AND pefc = "si" ),
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
  -- 4. Update monthly aggregations (tabella_mensile) for vendite
  -----------------------------------------------------------------------------------------------
  INSERT INTO tabella_mensile (
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
      FROM tabella_vendite
      WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_acquisto FROM tabella_mensile
      WHERE mese_anno = ( SELECT SUBSTR(giorno_data, 1, 7)
                         FROM tabella_vendite
                         WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_acquisto FROM tabella_mensile
      WHERE mese_anno = ( SELECT SUBSTR(giorno_data, 1, 7)
                         FROM tabella_vendite
                         WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_acquisto_no_iva FROM tabella_mensile
      WHERE mese_anno = ( SELECT SUBSTR(giorno_data, 1, 7)
                         FROM tabella_vendite
                         WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(quantita) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_vendite
              WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(quantita) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_vendite
              WHERE operazione = NEW.operazione )
        AND pefc = "si" ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_vendite
              WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_vendite
              WHERE operazione = NEW.operazione ) )
  );

  -----------------------------------------------------------------------------------------------
  -- 5. Update annual aggregations (tabella_annuale) for vendite
  -----------------------------------------------------------------------------------------------
  INSERT INTO tabella_annuale (
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
      FROM tabella_vendite
      WHERE operazione = NEW.operazione ),
    ( SELECT somma_eur_acquisto FROM tabella_annuale
      WHERE anno = ( SELECT SUBSTR(giorno_data, 1, 4)
                     FROM tabella_vendite
                     WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_acquisto_no_iva FROM tabella_annuale
      WHERE anno = ( SELECT SUBSTR(giorno_data, 1, 4)
                     FROM tabella_vendite
                     WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_acquisto_no_iva FROM tabella_annuale
      WHERE anno = ( SELECT SUBSTR(giorno_data, 1, 4)
                     FROM tabella_vendite
                     WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(quantita) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_vendite
              WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(quantita) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_vendite
              WHERE operazione = NEW.operazione )
        AND pefc = "si" ),
    ( SELECT SUM(importo_totale) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_vendite
              WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_vendite
              WHERE operazione = NEW.operazione ) )
  );

END;

----------------------------------------------------------------------------------------------------
