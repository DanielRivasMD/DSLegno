----------------------------------------------------------------------------------------------------

.open dallasanta.sql;

----------------------------------------------------------------------------------------------------


CREATE TABLE IF NOT EXISTS tabella_principale
  (
    ----------------------------------------
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    operazione INTEGER,                   -- correlation number
    ----------------------------------------
    -----      cedente prestatore      -----
    ----------------------------------------
    prestatore_denominazione TEXT,        -- name
    prestatore_indirizzo TEXT,            -- address
    prestatore_numero_rea INTEGER,        -- number
    ----------------------------------------
    -----   cessionario committente    -----
    ----------------------------------------
    committente_denominazione TEXT,       -- name
    committente_indirizzo TEXT,           -- address
    ----------------------------------------
    -----   dati generali documento    -----
    ----------------------------------------
    fattura TEXT,                         -- invoice number
    data TEXT,                            -- invoice date
    importo_totale REAL,                  -- total amount
    ----------------------------------------
    -----       dettaglio linee        -----
    ----------------------------------------
    descrizione TEXT,                     -- description
    numero_linea INTEGER,                 -- number
    quantita REAL,                        -- amount
    prezzo_unitario REAL,                 -- unit price
    prezzo_totale REAL,                   -- total price
    aliquota_iva REAL,                    -- tax
    ----------------------------------------
    -----        dati riepilogo        -----
    ----------------------------------------
    imponibile_importo REAL,              -- total
    imposto REAL,                         -- tax
    esigibilita_iva CHAR,                 -- tax category
    ----------------------------------------
    -----     condizioni pagamento     -----
    ----------------------------------------
    dati_riferimento_termini TEXT,        -- date
    dati_scadenza_pagamento TEXT,         -- date
    importo_pagamento REAL,               -- total
    ----------------------------------------
    typo TEXT
    ----------------------------------------
   );


CREATE TABLE IF NOT EXISTS tabella_acquisti
  (
    ----------------------------------------
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    operazione INTEGER,                   -- correlation number
    ----------------------------------------
    -----      cedente prestatore      -----
    ----------------------------------------
    prestatore_denominazione TEXT,        -- name
    prestatore_indirizzo TEXT,            -- address
    prestatore_numero_rea INTEGER,        -- number
    ----------------------------------------
    -----   cessionario committente    -----
    ----------------------------------------
    committente_denominazione TEXT,       -- name
    committente_indirizzo TEXT,           -- address
    ----------------------------------------
    -----   dati generali documento    -----
    ----------------------------------------
    fattura TEXT,                         -- invoice number
    data TEXT,                            -- invoice date
    importo_totale REAL,                  -- total amount
    ----------------------------------------
    -----       dettaglio linee        -----
    ----------------------------------------
    descrizione TEXT,                     -- description
    numero_linea INTEGER,                 -- number
    quantita REAL,                        -- amount
    prezzo_unitario REAL,                 -- unit price
    prezzo_totale REAL,                   -- total price
    aliquota_iva REAL,                    -- tax
    ----------------------------------------
    -----        dati riepilogo        -----
    ----------------------------------------
    imponibile_importo REAL,              -- total
    imposto REAL,                         -- tax
    esigibilita_iva CHAR,                 -- tax category
    ----------------------------------------
    -----     condizioni pagamento     -----
    ----------------------------------------
    dati_riferimento_termini TEXT,        -- date
    dati_scadenza_pagamento TEXT,         -- date
    importo_pagamento REAL                -- total
    ----------------------------------------
  );


CREATE TABLE IF NOT EXISTS tabella_vendite
  (
    ----------------------------------------
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- automatic tracker
    operazione INTEGER,                   -- correlation number
    ----------------------------------------
    -----      cedente prestatore      -----
    ----------------------------------------
    prestatore_denominazione TEXT,        -- name
    prestatore_indirizzo TEXT,            -- address
    prestatore_numero_rea INTEGER,        -- number
    ----------------------------------------
    -----   cessionario committente    -----
    ----------------------------------------
    committente_denominazione TEXT,       -- name
    committente_indirizzo TEXT,           -- address
    ----------------------------------------
    -----   dati generali documento    -----
    ----------------------------------------
    fattura TEXT,                         -- invoice number
    data TEXT,                            -- invoice date
    importo_totale REAL,                  -- total amount
    ----------------------------------------
    -----       dettaglio linee        -----
    ----------------------------------------
    descrizione TEXT,                     -- description
    numero_linea INTEGER,                 -- number
    quantita REAL,                        -- amount
    prezzo_unitario REAL,                 -- unit price
    prezzo_totale REAL,                   -- total price
    aliquota_iva REAL,                    -- tax
    ----------------------------------------
    -----        dati riepilogo        -----
    ----------------------------------------
    imponibile_importo REAL,              -- total
    imposto REAL,                         -- tax
    esigibilita_iva CHAR,                 -- tax category
    ----------------------------------------
    -----     condizioni pagamento     -----
    ----------------------------------------
    dati_riferimento_termini TEXT,        -- date
    dati_scadenza_pagamento TEXT,         -- date
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

INSERT INTO tabella_acquisti
  ( numero, fattura, mc, eur, ditta, indirizzo, specie_legnosa ) VALUES
  ( 1, 0001, 7868, 3566, 'commune', 'via xxx', 'legna1' ),
  ( 2, 0002, 7868, 3566, 'commune', 'via xxx', 'legna1' ),
  ( 3, 0003, 7868, 3566, 'commune', 'via xxx', 'legna1' ),
  ( 4, 0014, 7868, 3566, 'altro', 'via xxx', 'legna5' ),
  ( 5, 0035, 7868, 3566, 'commune', 'via xxx', 'legna1' ),
  ( 6, 0006, 7868, 3566, 'commune', 'via xxx', 'legna5' ),
  ( 7, 0307, 7868, 3566, 'commune', 'via xxx', 'legna7' );


INSERT INTO tabella_vendite
  ( numero, fattura, mc, eur, cliente, indirizzo, denominazione_commerciale ) VALUES
  ( 1, 0101, 685, 657474, 'cliente1', 'via xxx', 'lavoro1' ),
  ( 2, 0102, 685, 657474, 'cliente2', 'via xxx', 'lavoro2' ),
  ( 3, 0103, 685, 657474, 'cliente3', 'via xxx', 'lavoro3' ),
  ( 4, 0104, 685, 657474, 'cliente1', 'via xxx', 'lavoro4' ),
  ( 5, 0105, 685, 657474, 'cliente3', 'via xxx', 'lavoro5' );


----------------------------------------------------------------------------------------------------

CREATE TRIGGER update_acquisti
  AFTER UPDATE ON tabella_acquisti
  WHEN ( NEW.operazione IS NOT NULL )
BEGIN
  INSERT INTO tabella_principale (
    operazione,
    numero,
    fattura,
    typo
  )
VALUES
  (
    NEW.operazione,
    NEW.numero,
    NEW.fattura,
    'ACQUISTO'
  );

  INSERT OR REPLACE INTO tabella_operazione ( numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento ) VALUES (
    NEW.operazione,
    ( SELECT SUM(mc) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT SUM(eur) FROM tabella_acquisti WHERE operazione = NEW.operazione ),
    ( SELECT somma_mc_vendita FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_vendita FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT pagamento FROM tabella_operazione WHERE numero = NEW.operazione ));
END;


CREATE TRIGGER update_vendite
  AFTER UPDATE ON tabella_vendite
  WHEN ( NEW.operazione IS NOT NULL )
BEGIN
  INSERT INTO tabella_principale (
    operazione,
    numero,
    fattura,
    typo
  )
VALUES
  (
    new.operazione,
    new.numero,
    new.fattura,
    'VENDITA'
  );

  INSERT OR REPLACE INTO tabella_operazione ( numero, somma_mc_acquisto, somma_eur_acquisto, somma_mc_vendita, somma_eur_vendita, pagamento ) VALUES (
    NEW.operazione,
    ( SELECT somma_mc_acquisto FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT somma_eur_acquisto FROM tabella_operazione WHERE numero = NEW.operazione ),
    ( SELECT SUM(mc) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT SUM(eur) FROM tabella_vendite WHERE operazione = NEW.operazione ),
    ( SELECT pagamento FROM tabella_operazione WHERE numero = NEW.operazione ));
END;


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
