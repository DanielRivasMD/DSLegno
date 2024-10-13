////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
// use diesel::prelude::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

diesel::table! {
	tabella_vendite {
		id -> Integer,
		operazione -> Integer,
		prestatore_denominazione -> Text,
		prestatore_indirizzo -> Text,
		committente_denominazione -> Text,
		committente_indirizzo -> Text,
		numero_fattura -> Text,
		giorno_data -> Text,
		importo_totale -> Text,
		descrizione -> Text,
		quantita -> Text,
		prezzo_unitario -> Text,
		prezzo_totale -> Text,
		aliquota_iva -> Text,
		imponibile_importo -> Text,
		imposta -> Text,
		esigibilita_iva -> Char,
		data_riferimento_termini -> Text,
		data_scadenza_pagamento -> Text,
		importo_pagamento -> Text,
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
