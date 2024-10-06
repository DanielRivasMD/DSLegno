----------------------------------------------------------------------------------------------------

.open dallasanta.sql;

----------------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS tabella_principale
  ( id_numero INTEGER PRIMARY KEY AUTOINCREMENT,
    operazione INTEGER,
    numero INTEGER,
    fattura INTEGER,
    typo TEXT
   );


CREATE TABLE IF NOT EXISTS tabella_acquisti
  (
    numero INTEGER PRIMARY KEY,
    operazione INTEGER,
    fattura INTEGER,
    mc REAL,
    eur REAL,
    ditta TEXT,
    indirizzo TEXT,
    specie_legnosa TEXT
  );


CREATE TABLE IF NOT EXISTS tabella_vendite
  (
    numero INTEGER PRIMARY KEY,
    operazione INTEGER,
    fattura INTEGER,
    mc REAL,
    eur REAL,
    cliente TEXT,
    indirizzo TEXT,
    denominazione_commerciale TEXT
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
  ( numero, fattura, ditta, indirizzo, specie_legnosa ) VALUES
  ( 1, 0001, 'commune', 'via xxx', 'legna1' ),
  ( 2, 0002, 'commune', 'via xxx', 'legna1' ),
  ( 3, 0003, 'commune', 'via xxx', 'legna1' ),
  ( 4, 0014, 'altro', 'via xxx', 'legna5' ),
  ( 5, 0035, 'commune', 'via xxx', 'legna1' ),
  ( 6, 0006, 'commune', 'via xxx', 'legna5' ),
  ( 7, 0307, 'commune', 'via xxx', 'legna7' );


INSERT INTO tabella_vendite
  ( numero, fattura, cliente, indirizzo, denominazione_commerciale ) VALUES
  ( 1, 0101, 'cliente1', 'via xxx', 'lavoro1' ),
  ( 2, 0102, 'cliente2', 'via xxx', 'lavoro2' ),
  ( 3, 0103, 'cliente3', 'via xxx', 'lavoro3' ),
  ( 4, 0104, 'cliente1', 'via xxx', 'lavoro4' ),
  ( 5, 0105, 'cliente3', 'via xxx', 'lavoro5' );


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
    new.operazione,
    new.numero,
    new.fattura,
    'ACQUISTO'
  );
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
END;


----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
