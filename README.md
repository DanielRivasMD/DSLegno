### Dalla Santa Legno

Welcome to **Dalla Santa Legno** database manager

The files uploaded to this shared folder are:

- `dallasanta.db`: a database that contains the tables required to hold and display the data loaded from the invoices. Additionally, this database also contains triggers that will update the values on the corresponding summary tables once the values on `operazione` are manually changed.

- `fattura.exe`: a program executable that reads the data contained in `xml` files, communicate with `dallasanta.db` and upload data to the corresponding tables.
