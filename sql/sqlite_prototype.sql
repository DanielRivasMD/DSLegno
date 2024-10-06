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

INSERT INTO tabella_principale
  ( numero_operazione, numero_acquisto, numero_vendita, fattura_acquisto, fattura_vendita ) VALUES
  ( 1, 1, 1, 0001, 0101 ),
  ( 2, 2, 2, 0002, 0102 ),
  ( 2, 3, 2, 0003, 0102 ),
  ( 3, 4, 3, 0014, 0103 ),
  ( 4, 5, 4, 0035, 0104 ),
  ( 5, 6, 5, 0006, 0105 ),
  ( 5, 7, 5, 0307, 0105 );

INSERT INTO tabella_operazione
  ( numero ) VALUES
  ( 1 ),
  ( 2 ),
  ( 3 ),
  ( 4 ),
  ( 5 );

----------------------------------------------------------------------------------------------------
