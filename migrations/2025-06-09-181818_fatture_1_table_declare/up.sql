----------------------------------------------------------------------------------------------------
-- TABLE DECLARATIONS
----------------------------------------------------------------------------------------------------

-- Main combined table for both purchases and sales
CREATE TABLE IF NOT EXISTS tabella_principale (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
  lotto INTEGER,                        -- correlation number (to be updated by user)
  descrizione TEXT,                     -- description
  quantita REAL,                        -- amount
  prezzo_unitario REAL,                 -- unit price
  prezzo_totale REAL,                   -- total price
  aliquota_iva REAL,                    -- tax rate
  numero_fattura TEXT,                  -- invoice number
  giorno_data TEXT,                     -- invoice date
  importo_totale REAL,                  -- total amount
  prestatore_denominazione TEXT,        -- seller name
  prestatore_indirizzo TEXT,            -- seller address
  committente_denominazione TEXT,       -- buyer name
  committente_indirizzo TEXT,           -- buyer address
  imponibile_importo REAL,              -- taxable amount
  imposta REAL,                         -- tax
  esigibilita_iva CHAR,                 -- tax category flag
  data_riferimento_termini TEXT,        -- payment reference date
  data_scadenza_pagamento TEXT,         -- payment due date
  importo_pagamento REAL,               -- payment amount
  typo TEXT                             -- transaction type ('ACQUISTO' or 'VENDITO')
);

----------------------------------------------------------------------------------------------------
-- Table for purchases (acquisti)
----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabella_acquisti (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
  lotto INTEGER,                        -- correlation number (initially NULL)
  progetto_di_taglio TEXT,              -- cutting project (initially NULL)
  descrizione TEXT,                     -- description
  quantita REAL,                        -- amount
  prezzo_unitario REAL,                 -- unit price
  prezzo_totale REAL,                   -- total price
  aliquota_iva REAL,                    -- tax rate
  numero_fattura TEXT,                  -- invoice number
  giorno_data TEXT,                     -- invoice date (must allow extraction of YYYY-MM and YYYY)
  importo_totale REAL,                  -- total amount
  prestatore_denominazione TEXT,        -- seller name
  prestatore_indirizzo TEXT,            -- seller address
  committente_denominazione TEXT,       -- buyer name
  committente_indirizzo TEXT,           -- buyer address
  imponibile_importo REAL,              -- taxable amount
  imposta REAL,                         -- tax
  esigibilita_iva CHAR,                 -- tax category flag
  data_riferimento_termini TEXT,        -- payment reference date
  data_scadenza_pagamento TEXT,         -- payment due date
  importo_pagamento REAL                -- payment amount
);

----------------------------------------------------------------------------------------------------
-- Table for sales (vendite)
----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabella_vendite (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
  lotto INTEGER,                        -- correlation number (initially NULL)
  pefc TEXT,                            -- PEFC flag (e.g., "si")
  descrizione TEXT,                     -- description
  quantita REAL,                        -- amount
  prezzo_unitario REAL,                 -- unit price
  prezzo_totale REAL,                   -- total price
  aliquota_iva REAL,                    -- tax rate
  numero_fattura TEXT,                  -- invoice number
  giorno_data TEXT,                     -- invoice date
  importo_totale REAL,                  -- total amount
  prestatore_denominazione TEXT,        -- seller name
  prestatore_indirizzo TEXT,            -- seller address
  committente_denominazione TEXT,       -- buyer name
  committente_indirizzo TEXT,           -- buyer address
  imponibile_importo REAL,              -- taxable amount
  imposta REAL,                         -- tax
  esigibilita_iva CHAR,                 -- tax category flag
  data_riferimento_termini TEXT,        -- payment reference date
  data_scadenza_pagamento TEXT,         -- payment due date
  importo_pagamento REAL                -- payment amount
);

----------------------------------------------------------------------------------------------------
-- Daily/Operative Summary Table (sommario)
----------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tabella_sommario (
  numero INTEGER PRIMARY KEY,           -- key (lotto)
  giorno_data TEXT,                     -- date of record
  acquisto TEXT,                        -- placeholder for purchase info
  vendita TEXT,                         -- placeholder for sales info
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
CREATE TABLE IF NOT EXISTS tabella_mensile (
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
CREATE TABLE IF NOT EXISTS tabella_annuale (
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
