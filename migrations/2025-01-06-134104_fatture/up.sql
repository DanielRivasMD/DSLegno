----------------------------------------------------------------------------------------------------

-- Tabella acquisti
-- •⁠  ⁠add column 'Progetto di taglio'

-- Tabella vendite
-- •⁠  ⁠add column PEFC => Chiara send example invoice

-- Tabella operazioni
-- •⁠  ⁠rename as tabella sommario
-- •⁠  ⁠add info from where the operation comes from (acquisto) and some info about vendita (clients names, invoice numbers,?) 
-- •⁠  ⁠add sum of PEFC Mc for each work
-- •⁠  ⁠add sum of euros spent in acquisition - no IVA - yearly and monthly 
-- •⁠  ⁠add sum of euros got in vendite - no Iva - (check if it is the imponibile) - yearly and monthly

----------------------------------------------------------------------------------------------------

-- TODO: modify architecture according to feedback
-- TODO: use date datatype
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
    progetto_di_taglio TEXT,              -- project
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
    pefc INTEGER,                         -- pefc
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


CREATE TABLE IF NOT EXISTS tabella_sommario
  (
    numero INTEGER PRIMARY KEY,
    giorno_data TEXT,
    acquisto TEXT,
    vendita TEXT,
    somma_mc_acquisto REAL,
    somma_eur_acquisto REAL,
    somma_eur_acquisto_no_iva REAL,
    somma_mc_vendita REAL,
    somma_mc_vendita_pefc REAL,
    somma_eur_vendita REAL,
    somma_eur_vendita_no_iva REAL,
    pagamento INTEGER
  );


CREATE TABLE IF NOT EXISTS tabella_mensile
  (
    numero INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    somma_mc_acquisto REAL,
    somma_eur_acquisto REAL,
    somma_eur_acquisto_no_iva REAL,
    somma_mc_vendita REAL,
    somma_mc_vendita_pefc REAL,
    somma_eur_vendita REAL,
    somma_eur_vendita_no_iva REAL
  );


CREATE TABLE IF NOT EXISTS tabella_annualmente
  (
    numero INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    somma_mc_acquisto REAL,
    somma_eur_acquisto REAL,
    somma_eur_acquisto_no_iva REAL,
    somma_mc_vendita REAL,
    somma_mc_vendita_pefc REAL,
    somma_eur_vendita REAL,
    somma_eur_vendita_no_iva REAL
  );


----------------------------------------------------------------------------------------------------

-- TODO: update insertion triggers
-- update on insert
CREATE TRIGGER denovo_acquisti
  AFTER UPDATE ON tabella_acquisti
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

  -- update tabella principale
  INSERT OR REPLACE INTO tabella_sommario (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    NEW.operazione,
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_vendita FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT pagamento FROM tabella_sommario WHERE numero = NEW.operazione )
  );

END;


-- update on change
CREATE TRIGGER update_acquisti
  AFTER UPDATE ON tabella_acquisti
  WHEN ( OLD.operazione <> NEW.operazione )
BEGIN

  -- update tabella principale
  INSERT INTO tabella_principale (
    operazione,
    prestatore_denominazione, prestatore_indirizzo,
    committente_denominazione, committente_indirizzo,
    numero_fattura, giorno_data, importo_totale,
    descrizione, prezzo_unitario, prezzo_totale, aliquota_iva,
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

  -- purge records tabella principale
  DELETE FROM tabella_principale
  WHERE id NOT IN
  ( SELECT operazione FROM tabella_acquisti UNION SELECT operazione FROM tabella_vendite );

  -- update tabella operazione new record
  INSERT OR REPLACE INTO tabella_sommario (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    NEW.operazione,
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_vendita FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT pagamento FROM tabella_sommario WHERE numero = NEW.operazione )
  );

  -- update tabella operazione old record
  INSERT OR REPLACE INTO tabella_sommario (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    OLD.operazione,
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = OLD.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = OLD.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT somma_eur_vendita FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT pagamento FROM tabella_sommario WHERE numero = OLD.operazione )
  );

  -- purge records tabella operazione
  DELETE FROM tabella_sommario
  WHERE numero NOT IN
  ( SELECT operazione FROM tabella_acquisti UNION SELECT operazione FROM tabella_vendite );

END;


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
    'VENDITO'
  );

  -- update tabella principale
  INSERT OR REPLACE INTO tabella_sommario (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    NEW.operazione,
    ( SELECT somma_mc_acquisto FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_acquisto FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT pagamento FROM tabella_sommario WHERE numero = NEW.operazione )
  );

END;


-- BUG: verify changes on tabella principale
-- update on change
CREATE TRIGGER update_vendite
  AFTER UPDATE ON tabella_vendite
  WHEN ( OLD.operazione <> NEW.operazione )
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
    'VENDITO'
  );

  -- purge records tabella principale
  DELETE FROM tabella_principale
  WHERE id NOT IN
  ( SELECT operazione FROM tabella_acquisti UNION SELECT operazione FROM tabella_vendite );

  -- update tabella operazione new record
  INSERT OR REPLACE INTO tabella_sommario (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    NEW.operazione,
    ( SELECT somma_mc_acquisto FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_acquisto FROM tabella_sommario WHERE numero = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT pagamento FROM tabella_sommario WHERE numero = NEW.operazione )
  );

  -- update tabella operazione old record
  INSERT OR REPLACE INTO tabella_sommario (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    OLD.operazione,
    ( SELECT somma_mc_acquisto FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT somma_eur_acquisto FROM tabella_sommario WHERE numero = OLD.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = OLD.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = OLD.operazione ),
    ( SELECT pagamento FROM tabella_sommario WHERE numero = OLD.operazione )
  );

  -- purge records tabella operazione
  DELETE FROM tabella_sommario
  WHERE numero NOT IN
  ( SELECT operazione FROM tabella_acquisti UNION SELECT operazione FROM tabella_vendite );

END;


----------------------------------------------------------------------------------------------------
