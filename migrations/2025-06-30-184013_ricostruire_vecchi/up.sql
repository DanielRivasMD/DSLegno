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


