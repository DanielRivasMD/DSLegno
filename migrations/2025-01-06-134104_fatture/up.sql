----------------------------------------------------------------------------------------------------
-- Tabella acquisti
-- Tabella vendite
-- Tabella sommario
----------------------------------------------------------------------------------------------------
-- database architecture
----------------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS tabella_principale
  (
    ----------------------------------------
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    operazione INTEGER,                   -- correlation number
    ----------------------------------------
    -----       dettaglio linee        -----
    ----------------------------------------
    descrizione TEXT,                     -- description
    quantita REAL,                        -- amount
    prezzo_unitario REAL,                 -- unit price
    prezzo_totale REAL,                   -- total price
    aliquota_iva REAL,                    -- tax
    ----------------------------------------
    -----   dati generali documento    -----
    ----------------------------------------
    numero_fattura TEXT,                  -- invoice number
    giorno_data TEXT,                     -- invoice date
    importo_totale REAL,                  -- total amount
    ----------------------------------------
    -----      cedente prestatore      -----
    ----------------------------------------
    prestatore_denominazione TEXT,        -- name
    prestatore_indirizzo TEXT,            -- address
    ----------------------------------------
    -----   cessionario committente    -----
    ----------------------------------------
    committente_denominazione TEXT,       -- name
    committente_indirizzo TEXT,           -- address
    ----------------------------------------
    -----        dati riepilogo        -----
    ----------------------------------------
    imponibile_importo REAL,              -- total
    imposta REAL,                         -- tax
    esigibilita_iva CHAR,                 -- tax category
    ----------------------------------------
    -----     condizioni pagamento     -----
    ----------------------------------------
    data_riferimento_termini TEXT,        -- date
    data_scadenza_pagamento TEXT,         -- date
    importo_pagamento REAL,               -- total
    ----------------------------------------
    typo TEXT                             -- type
    ----------------------------------------
  );


CREATE TABLE IF NOT EXISTS tabella_acquisti
  (
    ----------------------------------------
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    operazione INTEGER,                   -- correlation number
    ----------------------------------------
    -----       dettaglio linee        -----
    ----------------------------------------
    progetto_di_taglio TEXT,              -- project => to edit manually
    descrizione TEXT,                     -- description
    quantita REAL,                        -- amount
    prezzo_unitario REAL,                 -- unit price
    prezzo_totale REAL,                   -- total price
    aliquota_iva REAL,                    -- tax
    ----------------------------------------
    -----   dati generali documento    -----
    ----------------------------------------
    numero_fattura TEXT,                  -- invoice number
    giorno_data TEXT,                     -- invoice date
    importo_totale REAL,                  -- total amount
    ----------------------------------------
    -----      cedente prestatore      -----
    ----------------------------------------
    prestatore_denominazione TEXT,        -- name
    prestatore_indirizzo TEXT,            -- address
    ----------------------------------------
    -----   cessionario committente    -----
    ----------------------------------------
    committente_denominazione TEXT,       -- name
    committente_indirizzo TEXT,           -- address
    ----------------------------------------
    -----        dati riepilogo        -----
    ----------------------------------------
    imponibile_importo REAL,              -- total
    imposta REAL,                         -- tax
    esigibilita_iva CHAR,                 -- tax category
    ----------------------------------------
    -----     condizioni pagamento     -----
    ----------------------------------------
    data_riferimento_termini TEXT,        -- date
    data_scadenza_pagamento TEXT,         -- date
    importo_pagamento REAL                -- total
    ----------------------------------------
  );


CREATE TABLE IF NOT EXISTS tabella_vendite
  (
    ----------------------------------------
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    operazione INTEGER,                   -- correlation number
    ----------------------------------------
    -----       dettaglio linee        -----
    ----------------------------------------
    pefc TEXT,                            -- pefc => boolean value to add manually
    descrizione TEXT,                     -- description
    quantita REAL,                        -- amount
    prezzo_unitario REAL,                 -- unit price
    prezzo_totale REAL,                   -- total price
    aliquota_iva REAL,                    -- tax
    ----------------------------------------
    -----   dati generali documento    -----
    ----------------------------------------
    numero_fattura TEXT,                  -- invoice number
    giorno_data TEXT,                     -- invoice date
    importo_totale REAL,                  -- total amount
    ----------------------------------------
    -----      cedente prestatore      -----
    ----------------------------------------
    prestatore_denominazione TEXT,        -- name
    prestatore_indirizzo TEXT,            -- address
    ----------------------------------------
    -----   cessionario committente    -----
    ----------------------------------------
    committente_denominazione TEXT,       -- name
    committente_indirizzo TEXT,           -- address
    ----------------------------------------
    -----        dati riepilogo        -----
    ----------------------------------------
    imponibile_importo REAL,              -- total
    imposta REAL,                         -- tax
    esigibilita_iva CHAR,                 -- tax category
    ----------------------------------------
    -----     condizioni pagamento     -----
    ----------------------------------------
    data_riferimento_termini TEXT,        -- date
    data_scadenza_pagamento TEXT,         -- date
    importo_pagamento REAL                -- total
    ----------------------------------------
  );

----------------------------------------------------------------------------------------------------
-- Tabella sommario
-- This table aggregates day-by-day summary data.
-- It includes details such as the date, descriptive fields for purchase and sale,
-- and aggregated totals both including tax and excluding tax.
----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabella_sommario
  (
    numero INTEGER PRIMARY KEY,           -- Unique identifier for the summary (manual assignment)
    giorno_data TEXT,                     -- Date of the summary record (e.g., YYYY-MM-DD)
    acquisto TEXT,                        -- Purchase details (general textual info)
    vendita TEXT,                         -- Sale details (general textual info)
    somma_mc_acquisto REAL,               -- Aggregated purchased quantity (measured in unit of measure)
    somma_eur_acquisto REAL,              -- Aggregated purchase total (in Euros)
    somma_eur_acquisto_no_iva REAL,       -- Aggregated purchase total without VAT
    somma_mc_vendita REAL,                -- Aggregated sold quantity (in unit of measure)
    somma_mc_vendita_pefc REAL,           -- Aggregated sold quantity (specific for PEFC, if applicable)
    somma_eur_vendita REAL,               -- Aggregated sales total (in Euros)
    somma_eur_vendita_no_iva REAL,        -- Aggregated sales total without VAT
    pagamento TEXT                        -- Payment conditions or status (textual info)
  );


----------------------------------------------------------------------------------------------------
-- Tabella mensile
-- This table aggregates monthly data.
-- It summarizes key totals for each month (e.g., month and year) including:
--   - Purchased and sold quantities,
--   - Total Euro amounts,
--   - Totals with and without VAT.
----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabella_mensile
  (
    numero INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-increment unique identifier
    mese_anno TEXT,                            -- Month and year (e.g., '06-2025')
    somma_mc_acquisto REAL,                    -- Total quantity purchased during the month
    somma_eur_acquisto REAL,                   -- Total purchase amount in Euros for the month
    somma_eur_acquisto_no_iva REAL,            -- Purchase amount without VAT for the month
    somma_mc_vendita REAL,                     -- Total quantity sold during the month
    somma_mc_vendita_pefc REAL,                -- Total quantity sold (PEFC-specific count) during the month
    somma_eur_vendita REAL,                    -- Total sales amount in Euros for the month
    somma_eur_vendita_no_iva REAL              -- Sales amount without VAT for the month
  );


----------------------------------------------------------------------------------------------------
-- Tabella annuale
-- This table aggregates annual data.
-- It functions similarly to the monthly table, but summarizes the totals for the whole year.
-- Columns represent aggregated totals for the year's purchased and sold quantities,
-- total monetary values with and without VAT.
----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabella_annuale
  (
    numero INTEGER PRIMARY KEY AUTOINCREMENT,  -- Auto-increment unique identifier
    anno TEXT,                                 -- Year of the summary (e.g., '2025')
    somma_mc_acquisto REAL,                    -- Total quantity purchased during the year
    somma_eur_acquisto REAL,                   -- Total purchase amount in Euros for the year
    somma_eur_acquisto_no_iva REAL,            -- Total purchase amount without VAT for the year
    somma_mc_vendita REAL,                     -- Total quantity sold during the year
    somma_mc_vendita_pefc REAL,                -- Total sold quantity (PEFC-specific count) during the year
    somma_eur_vendita REAL,                    -- Total sales amount in Euros for the year
    somma_eur_vendita_no_iva REAL              -- Total sales amount without VAT for the year
  );


----------------------------------------------------------------------------------------------------
-- ACTION TRIGGERS
-- This trigger fires after an UPDATE on the 'tabella_acquisti' table when NEW.operazione 
-- is provided (i.e., not NULL). Its purpose is to propagate and aggregate data into the 
-- main and summary tables (tabella_principale, tabella_sommario, tabella_mensile, and tabella_annuale).
----------------------------------------------------------------------------------------------------

CREATE TRIGGER denovo_acquisti
  AFTER UPDATE ON tabella_acquisti
  WHEN ( NEW.operazione IS NOT NULL )
BEGIN

  -----------------------------------------------------------------------------------------------
  -- 1. Update tabella_principale
  --
  -- Inserts a new record into 'tabella_principale' using values from the updated 'tabella_acquisti'
  -- record. The 'typo' field is hard-coded as 'ACQUISTO' indicating a purchase.
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
    'ACQUISTO'
  );

  -----------------------------------------------------------------------------------------------
  -- 2. Update tabella_sommario
  --
  -- Inserts or replaces a record in 'tabella_sommario' keyed by NEW.operazione.
  --
  -- For the purchase (acquisto) aggregates, it computes:
  --   - Total quantity (SUM of quantita)
  --   - Total invoice amount (SUM of importo_totale)
  --   - Total net amount (SUM of prezzo_totale)
  --
  -- For the sale (vendita) aggregates, it preserves the existing values from tabella_sommario.
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
  -- 3. Update tabella_mensile
  --
  -- Inserts a new record into 'tabella_mensile' to aggregate monthly data.
  --
  -- The month is extracted from 'giorno_data' using SUBSTR to obtain the first 7 characters (YYYY-MM).
  -- It aggregates the purchases (quantity, invoice amount, net total) for that month.
  -- For sales aggregates, it retains any pre-existing monthly values from tabella_mensile.
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
      FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(importo_totale)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(prezzo_totale)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 7) =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_mc_vendita
      FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_mc_vendita_pefc
      FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_vendita
      FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_vendita_no_iva
      FROM tabella_mensile
      WHERE mese_anno =
            ( SELECT SUBSTR(giorno_data, 1, 7)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) )
  );

  -----------------------------------------------------------------------------------------------
  -- 4. Update tabella_annuale
  --
  -- Inserts a new record into 'tabella_annuale' to aggregate annual data.
  --
  -- The year is extracted from 'giorno_data' using SUBSTR to obtain the first 4 characters (YYYY).
  -- It aggregates the purchases similarly to the monthly trigger,
  -- and retains any pre-existing annual sales aggregates from tabella_annuale.
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
      FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(quantita)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(importo_totale)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(prezzo_totale)
      FROM tabella_acquisti
      WHERE SUBSTR(giorno_data, 1, 4) =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_mc_vendita
      FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_mc_vendita_pefc
      FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_vendita
      FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_vendita_no_iva
      FROM tabella_annuale
      WHERE anno =
            ( SELECT SUBSTR(giorno_data, 1, 4)
              FROM tabella_acquisti WHERE operazione = NEW.operazione ) )
  );

END;

----------------------------------------------------------------------------------------------------

-- update on change
-- This trigger fires after an UPDATE on tabella_acquisti when the operazione value changes,
-- meaning OLD.operazione is not equal to NEW.operazione.
CREATE TRIGGER update_acquisti
  AFTER UPDATE ON tabella_acquisti
  WHEN ( OLD.operazione <> NEW.operazione )
BEGIN

  -----------------------------------------------------------------------------------------------
  -- 1. Update tabella_principale with the new record
  --
  -- Insert a new record into tabella_principale using data from the NEW row of tabella_acquisti.
  -- The fixed field 'typo' is set to 'ACQUISTO' to denote that this row represents a purchase.
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
  VALUES
  (
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
  --
  -- Remove any records whose id (i.e. operazione) no longer exists in tabella_acquisti or tabella_vendite.
  -----------------------------------------------------------------------------------------------
  DELETE FROM tabella_principale
  WHERE id NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  -----------------------------------------------------------------------------------------------
  -- 2. Update tabella_sommario for the NEW operazione (New Record)
  --
  -- Insert or update the summary aggregates for the new operazione value.
  -- Purchase data aggregates are recalculated based on the records from tabella_acquisti,
  -- while existing sales aggregates are preserved.
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
  -- 3. Update tabella_sommario for the OLD operazione (Old Record)
  --
  -- Recalculate the summary aggregates associated with the OLD operazione in case data needs
  -- to be updated after the operazione change.
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
  --
  -- Remove any summary records where numero (i.e. operazione) is no longer present in
  -- either tabella_acquisti or tabella_vendite.
  -----------------------------------------------------------------------------------------------
  DELETE FROM tabella_sommario
  WHERE numero NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  -----------------------------------------------------------------------------------------------
  -- 4. Update tabella_mensile (Monthly Aggregation)
  --
  -- Insert or replace the monthly summary. The month (YYYY-MM format) is extracted from giorno_data.
  -- Purchase data aggregates for that month are recalculated, while any sales data is retained.
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
  -- 5. Update tabella_annuale (Annual Aggregation)
  --
  -- Insert or replace the annual summary. The year (YYYY format) is extracted from giorno_data.
  -- Purchase data aggregates for that year are recalculated, while any sales data is retained.
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

-- update on insert
CREATE TRIGGER denovo_vendite
  AFTER UPDATE ON tabella_vendite
  WHEN ( NEW.operazione IS NOT NULL )
BEGIN

  -- update tabella principale
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

  -- update tabella sommario
  INSERT OR REPLACE INTO tabella_sommario (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_eur_acquisto_no_iva, somma_mc_vendita, somma_mc_vendita_pefc, somma_eur_vendita, somma_eur_vendita_no_iva
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

  -- update tabella mensile
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
    ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_acquisto FROM tabella_mensile WHERE mese_anno = ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_acquisto FROM tabella_mensile WHERE mese_anno = ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_acquisto_no_iva FROM tabella_mensile WHERE mese_anno = ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE SUBSTR(giorno_data, 1, 7) = ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE SUBSTR(giorno_data, 1, 7) = ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione ) AND pefc = "si"),
    ( SELECT SUM(importo_totale) FROM tabella_vendite WHERE SUBSTR(giorno_data, 1, 7) = ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE SUBSTR(giorno_data, 1, 7) = ( SELECT SUBSTR(giorno_data, 1, 7) FROM tabella_vendite WHERE operazione = NEW.operazione ) )
  );

  -- update tabella annuale
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
    ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_acquisto FROM tabella_annuale WHERE anno = ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_acquisto FROM tabella_annuale WHERE anno = ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione ) ),
    ( SELECT somma_eur_acquisto_no_iva FROM tabella_annuale WHERE anno = ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE SUBSTR(giorno_data, 1, 4) = ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE SUBSTR(giorno_data, 1, 4) = ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione ) AND pefc = "si"),
    ( SELECT SUM(importo_totale) FROM tabella_vendite WHERE SUBSTR(giorno_data, 1, 4) = ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione ) ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE SUBSTR(giorno_data, 1, 4) = ( SELECT SUBSTR(giorno_data, 1, 4) FROM tabella_vendite WHERE operazione = NEW.operazione ) )
  );

END;

----------------------------------------------------------------------------------------------------

-- update on change
CREATE TRIGGER update_vendite
  AFTER UPDATE ON tabella_vendite
  WHEN ( OLD.operazione <> NEW.operazione )
BEGIN

  -----------------------------------------------------------------------------------------------
  -- 1. Update tabella_principale with the new vendite record
  --
  -- Insert a record into tabella_principale using values from the NEW row of tabella_vendite.
  -- The field 'typo' is set to 'VENDITO' to denote a sale transaction.
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
  --
  -- Remove any records from tabella_principale whose id (i.e. operazione)
  -- is not present in either tabella_acquisti or tabella_vendite.
  -----------------------------------------------------------------------------------------------
  DELETE FROM tabella_principale
  WHERE id NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  -----------------------------------------------------------------------------------------------
  -- 2. Update tabella_sommario for the new vendite record (NEW.operazione)
  --
  -- Insert or replace the summary aggregates for the new operazione.
  -- Sales aggregates are recalculated from tabella_vendite while purchase aggregates,
  -- if present, are retained from the existing summary record.
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
  -- 3. Update tabella_sommario for the old vendite record (OLD.operazione)
  --
  -- Recalculate the summary aggregates for the OLD operazione value,
  -- ensuring that any transaction reassignments are correctly reflected.
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
  --
  -- Delete any summary rows (numero) that no longer exist in either tabella_acquisti or tabella_vendite.
  -----------------------------------------------------------------------------------------------
  DELETE FROM tabella_sommario
  WHERE numero NOT IN (
      SELECT operazione FROM tabella_acquisti
      UNION
      SELECT operazione FROM tabella_vendite
  );

  -----------------------------------------------------------------------------------------------
  -- 4. Update tabella_mensile (Monthly Aggregation)
  --
  -- Insert new monthly aggregates for vendite. The month (YYYY-MM format) is extracted from giorno_data.
  -- Purchase aggregates are retained from tabella_mensile while sale aggregates are freshly computed.
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
  -- 5. Update tabella_annuale (Annual Aggregation)
  --
  -- Insert new annual aggregates for vendite. The year (YYYY) is extracted from giorno_data.
  -- Some sales aggregates are freshly computed from tabella_vendite.
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
