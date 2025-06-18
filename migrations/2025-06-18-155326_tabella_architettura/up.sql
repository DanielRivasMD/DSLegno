-----------------------------------------------------------------------------  
-- Update table create
-----------------------------------------------------------------------------  

PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;

-----------------------------------------------------------------------------  
-- 1) tabella_acquisti → add attiva TEXT DEFAULT 'si', reorder columns
-----------------------------------------------------------------------------  

CREATE TABLE tabella_acquisti_new (
  id                        INTEGER PRIMARY KEY AUTOINCREMENT,
  attiva                    TEXT    NOT NULL DEFAULT 'si',
  lotto                     INTEGER,
  progetto_di_taglio        TEXT,
  descrizione               TEXT,
  quantita                  REAL,
  prezzo_unitario           REAL,
  prezzo_totale             REAL,
  aliquota_iva              REAL,
  numero_fattura            TEXT,
  giorno_data               TEXT,
  importo_totale            REAL,
  prestatore_denominazione  TEXT,
  prestatore_indirizzo      TEXT,
  committente_denominazione TEXT,
  committente_indirizzo     TEXT,
  imponibile_importo        REAL,
  imposta                   REAL,
  esigibilita_iva           CHAR,
  data_riferimento_termini  TEXT,
  data_scadenza_pagamento   TEXT,
  importo_pagamento         REAL
);

INSERT INTO tabella_acquisti_new (
  id,
  attiva,
  lotto,
  progetto_di_taglio,
  descrizione,
  quantita,
  prezzo_unitario,
  prezzo_totale,
  aliquota_iva,
  numero_fattura,
  giorno_data,
  importo_totale,
  prestatore_denominazione,
  prestatore_indirizzo,
  committente_denominazione,
  committente_indirizzo,
  imponibile_importo,
  imposta,
  esigibilita_iva,
  data_riferimento_termini,
  data_scadenza_pagamento,
  importo_pagamento
)
SELECT
  id,
  'si'       AS attiva,    -- all existing rows default to "si"
  lotto,
  progetto_di_taglio,
  descrizione,
  quantita,
  prezzo_unitario,
  prezzo_totale,
  aliquota_iva,
  numero_fattura,
  giorno_data,
  importo_totale,
  prestatore_denominazione,
  prestatore_indirizzo,
  committente_denominazione,
  committente_indirizzo,
  imponibile_importo,
  imposta,
  esigibilita_iva,
  data_riferimento_termini,
  data_scadenza_pagamento,
  importo_pagamento
FROM tabella_acquisti;

DROP TABLE tabella_acquisti;
ALTER TABLE tabella_acquisti_new RENAME TO tabella_acquisti;

-----------------------------------------------------------------------------  
-- 2) tabella_vendite → add attiva TEXT DEFAULT 'si', reorder columns
-----------------------------------------------------------------------------

CREATE TABLE tabella_vendite_new (
  id                        INTEGER PRIMARY KEY AUTOINCREMENT,
  attiva                    TEXT    NOT NULL DEFAULT 'si',
  lotto                     INTEGER,
  pefc                      TEXT,
  descrizione               TEXT,
  quantita                  REAL,
  prezzo_unitario           REAL,
  prezzo_totale             REAL,
  aliquota_iva              REAL,
  numero_fattura            TEXT,
  giorno_data               TEXT,
  importo_totale            REAL,
  prestatore_denominazione  TEXT,
  prestatore_indirizzo      TEXT,
  committente_denominazione TEXT,
  committente_indirizzo     TEXT,
  imponibile_importo        REAL,
  imposta                   REAL,
  esigibilita_iva           CHAR,
  data_riferimento_termini  TEXT,
  data_scadenza_pagamento   TEXT,
  importo_pagamento         REAL
);

INSERT INTO tabella_vendite_new (
  id,
  attiva,
  lotto,
  pefc,
  descrizione,
  quantita,
  prezzo_unitario,
  prezzo_totale,
  aliquota_iva,
  numero_fattura,
  giorno_data,
  importo_totale,
  prestatore_denominazione,
  prestatore_indirizzo,
  committente_denominazione,
  committente_indirizzo,
  imponibile_importo,
  imposta,
  esigibilita_iva,
  data_riferimento_termini,
  data_scadenza_pagamento,
  importo_pagamento
)
SELECT
  id,
  'si'       AS attiva,
  lotto,
  pefc,
  descrizione,
  quantita,
  prezzo_unitario,
  prezzo_totale,
  aliquota_iva,
  numero_fattura,
  giorno_data,
  importo_totale,
  prestatore_denominazione,
  prestatore_indirizzo,
  committente_denominazione,
  committente_indirizzo,
  imponibile_importo,
  imposta,
  esigibilita_iva,
  data_riferimento_termini,
  data_scadenza_pagamento,
  importo_pagamento
FROM tabella_vendite;

DROP TABLE tabella_vendite;
ALTER TABLE tabella_vendite_new RENAME TO tabella_vendite;

COMMIT;
PRAGMA foreign_keys = ON;

----------------------------------------------------------------------------------------------------
