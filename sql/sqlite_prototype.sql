----------------------------------------------------------------------------------------------------

.open dallasanta.sql;

----------------------------------------------------------------------------------------------------


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
    fattura TEXT,                         -- invoice number
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


CREATE TABLE IF NOT EXISTS tabella_acquisti
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


CREATE TABLE IF NOT EXISTS tabella_operazione
  (
    numero INTEGER PRIMARY KEY,
    somma_mc_acquisto REAL,
    somma_eur_acquisto REAL,
    somma_mc_vendita REAL,
    somma_eur_vendita REAL,
    pagamento INTEGER
  );


----------------------------------------------------------------------------------------------------


-- update on insert
CREATE TRIGGER denovo_acquisti
  AFTER UPDATE ON tabella_acquisti
  WHEN ( NEW.operazione IS NOT NULL )
BEGIN

  -- update tabella principale
  INSERT INTO tabella_principale (
    operazione,
    prestatore_denominazione, prestatore_indirizzo, prestatore_numero_rea,
    committente_denominazione, committente_indirizzo,
    fattura, data, importo_totale,
    descrizione, numero_linea, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposto, esigibilita_iva,
    dati_riferimento_termini, dati_scadenza_pagamento, importo_pagamento,
    typo
  )
VALUES
  (
    NEW.operazione,
    NEW.prestatore_denominazione, NEW.prestatore_indirizzo, NEW.prestatore_numero_rea,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.fattura, NEW.data, NEW.importo_totale,
    NEW.descrizione, NEW.numero_linea, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale, NEW.aliquota_iva,
    NEW.imponibile_importo, NEW.imposto, NEW.esigibilita_iva,
    NEW.dati_riferimento_termini, NEW.dati_scadenza_pagamento, NEW.importo_pagamento,
    'ACQUISTO'
  );

  -- update tabella principale
  INSERT OR REPLACE INTO tabella_operazione (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    NEW.operazione,
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_vendita FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT pagamento FROM tabella_operazione WHERE numero = NEW.operazione )
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
    prestatore_denominazione, prestatore_indirizzo, prestatore_numero_rea,
    committente_denominazione, committente_indirizzo,
    fattura, data, importo_totale,
    descrizione, numero_linea, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposto, esigibilita_iva,
    dati_riferimento_termini, dati_scadenza_pagamento, importo_pagamento,
    typo
  )
VALUES
  (
    NEW.operazione,
    NEW.prestatore_denominazione, NEW.prestatore_indirizzo, NEW.prestatore_numero_rea,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.fattura, NEW.data, NEW.importo_totale,
    NEW.descrizione, NEW.numero_linea, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale, NEW.aliquota_iva,
    NEW.imponibile_importo, NEW.imposto, NEW.esigibilita_iva,
    NEW.dati_riferimento_termini, NEW.dati_scadenza_pagamento, NEW.importo_pagamento,
    'ACQUISTO'
  );

  -- purge records tabella principale
  DELETE FROM tabella_principale
  WHERE id NOT IN
  ( SELECT operazione FROM tabella_acquisti UNION SELECT operazione FROM tabella_vendite );

  -- update tabella operazione new record
  INSERT OR REPLACE INTO tabella_operazione (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    NEW.operazione,
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_vendita FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT pagamento FROM tabella_operazione WHERE numero = NEW.operazione )
  );

  -- update tabella operazione old record
  INSERT OR REPLACE INTO tabella_operazione (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    OLD.operazione,
    ( SELECT SUM(quantita) FROM tabella_acquisti WHERE operazione = OLD.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_acquisti WHERE operazione = OLD.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_operazione WHERE numero = OLD.operazione ),
    ( SELECT somma_eur_vendita FROM tabella_operazione WHERE numero = OLD.operazione ),
    ( SELECT pagamento FROM tabella_operazione WHERE numero = OLD.operazione )
  );

  -- purge records tabella operazione
  DELETE FROM tabella_operazione
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
    prestatore_denominazione, prestatore_indirizzo, prestatore_numero_rea,
    committente_denominazione, committente_indirizzo,
    fattura, data, importo_totale,
    descrizione, numero_linea, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposto, esigibilita_iva,
    dati_riferimento_termini, dati_scadenza_pagamento, importo_pagamento,
    typo
  )
VALUES
  (
    NEW.operazione,
    NEW.prestatore_denominazione, NEW.prestatore_indirizzo, NEW.prestatore_numero_rea,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.fattura, NEW.data, NEW.importo_totale,
    NEW.descrizione, NEW.numero_linea, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale, NEW.aliquota_iva,
    NEW.imponibile_importo, NEW.imposto, NEW.esigibilita_iva,
    NEW.dati_riferimento_termini, NEW.dati_scadenza_pagamento, NEW.importo_pagamento,
    'ACQUISTO'
  );

  -- update tabella principale
  INSERT OR REPLACE INTO tabella_operazione (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    NEW.operazione,
    ( SELECT somma_mc_acquisto FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_acquisto FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT pagamento FROM tabella_operazione WHERE numero = NEW.operazione )
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
    prestatore_denominazione, prestatore_indirizzo, prestatore_numero_rea,
    committente_denominazione, committente_indirizzo,
    fattura, data, importo_totale,
    descrizione, numero_linea, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposto, esigibilita_iva,
    dati_riferimento_termini, dati_scadenza_pagamento, importo_pagamento,
    typo
  )
VALUES
  (
    NEW.operazione,
    NEW.prestatore_denominazione, NEW.prestatore_indirizzo, NEW.prestatore_numero_rea,
    NEW.committente_denominazione, NEW.committente_indirizzo,
    NEW.fattura, NEW.data, NEW.importo_totale,
    NEW.descrizione, NEW.numero_linea, NEW.quantita, NEW.prezzo_unitario, NEW.prezzo_totale, NEW.aliquota_iva,
    NEW.imponibile_importo, NEW.imposto, NEW.esigibilita_iva,
    NEW.dati_riferimento_termini, NEW.dati_scadenza_pagamento, NEW.importo_pagamento,
    'ACQUISTO'
  );

  -- purge records tabella principale
  DELETE FROM tabella_principale
  WHERE id NOT IN
  ( SELECT operazione FROM tabella_acquisti UNION SELECT operazione FROM tabella_vendite );

  -- update tabella operazione new record
  INSERT OR REPLACE INTO tabella_operazione (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    NEW.operazione,
    ( SELECT somma_mc_acquisto FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_acquisto FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT pagamento FROM tabella_operazione WHERE numero = NEW.operazione )
  );

  -- update tabella operazione old record
  INSERT OR REPLACE INTO tabella_operazione (
    numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento
  ) VALUES (
    OLD.operazione,
    ( SELECT somma_mc_acquisto FROM tabella_operazione WHERE numero = OLD.operazione ),
    ( SELECT somma_eur_acquisto FROM tabella_operazione WHERE numero = OLD.operazione ),
    ( SELECT SUM(quantita) FROM tabella_vendite WHERE operazione = OLD.operazione ),
    ( SELECT SUM(prezzo_totale) FROM tabella_vendite WHERE operazione = OLD.operazione ),
    ( SELECT pagamento FROM tabella_operazione WHERE numero = OLD.operazione )
  );

  -- purge records tabella operazione
  DELETE FROM tabella_operazione
  WHERE numero NOT IN
  ( SELECT operazione FROM tabella_acquisti UNION SELECT operazione FROM tabella_vendite );

END;


----------------------------------------------------------------------------------------------------


INSERT INTO tabella_acquisti
  ( 
    prestatore_denominazione, prestatore_indirizzo, prestatore_numero_rea,
    committente_denominazione, committente_indirizzo,
    fattura, data, importo_totale,
    descrizione, numero_linea, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposto, esigibilita_iva,
    dati_riferimento_termini, dati_scadenza_pagamento, importo_pagamento
   ) VALUES (
    'COMUNE DI IMER', 'Piazzale del Piazza, 1, 38050, Imer', '',
    'DALLA SANTA LEGNO SRL', 'VIA S.S. MICHELI, 5, 38050, IMER',
    '23-31', '2024-09-16', 18422.00,
    'ACCONTO LEGNAME LOTTO VEDERNA 2023 BOSTRICO LEGNAME CERTIFICATO PEFC ICILA PEFCGFS 002720 AGV', 0001, 500.00, 30.20, 15100.00, 22.00,
    15100.00, 3322.00, 'I',
    '', '', 18422.00
  );


INSERT INTO tabella_vendite
  (
    prestatore_denominazione, prestatore_indirizzo, prestatore_numero_rea,
    committente_denominazione, committente_indirizzo,
    fattura, data, importo_totale,
    descrizione, numero_linea, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposto, esigibilita_iva,
    dati_riferimento_termini, dati_scadenza_pagamento, importo_pagamento
   ) VALUES (
    'DALLA SANTA LEGNO SRL', 'VIA SUOR S.MICHELI, 5, 38050, IMER', 161731,
    'CPA LEGNAMI SRL', 'VIA MORGANA 50, 31036, ISTRANA',
    '196', '2024-09-20', 9540.40,
    'VENDITA TRONCHI - A CATASTA PROVENIENTI DA LOTTI PRIVATI VALMESTA COMUNE DI PRIMIERO SMC
    DICHIARAZIONI N. 37-38-39-40/2024', 10, 45.00, 85.00, 3825.00, 22.00,
    7820.00, 1720.40, 'I',
    '2024-09-20', '2024-09-20', 9540.40
  );


INSERT INTO tabella_vendite
  (
    prestatore_denominazione, prestatore_indirizzo, prestatore_numero_rea,
    committente_denominazione, committente_indirizzo,
    fattura, data, importo_totale,
    descrizione, numero_linea, quantita, prezzo_unitario, prezzo_totale, aliquota_iva,
    imponibile_importo, imposto, esigibilita_iva,
    dati_riferimento_termini, dati_scadenza_pagamento, importo_pagamento
   ) VALUES (
    'DALLA SANTA LEGNO SRL', 'VIA SUOR S.MICHELI, 5, 38050, IMER', 161731,
    'CPA LEGNAMI SRL', 'VIA MORGANA 50, 31036, ISTRANA',
    '196', '2024-09-20', 9540.40,
    'VENDITA TRONCHI - A CATASTA PROVENIENTI DA LOTTO BOSTRICO 2023 VEDERNA COMUNE DI IMER', 20, 47.00, 85.00, 3995.00, 22.00,
    7820.00, 1720.40, 'I',
    '2024-09-20', '2024-09-20', 9540.40
  );


----------------------------------------------------------------------------------------------------
