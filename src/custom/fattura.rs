////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use serde::{Deserialize, Serialize};
use diesel::prelude::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::custom::schema::tabella_vendite;

////////////////////////////////////////////////////////////////////////////////////////////////////

// TODO: find how to transfer fields
#[derive(Debug, Default, Deserialize, Insertable, Serialize, new)]
// #[diesel(table_name = crate::custom::schema::tabella_vendite)]
#[diesel(table_name = tabella_vendite)]
pub struct FatturaToUpload {

	#[new(default)]
	pub descrizione: String,

	#[new(default)]
	pub quantita: String,

	#[new(default)]
	pub prezzo_unitario: String,

	#[new(default)]
	pub prezzo_totale: String,

	#[new(default)]
	pub aliquota_iva: String,

	#[new(default)]
	pub numero_fattura: String,

	#[new(default)]
	pub giorno_data: String,

	#[new(default)]
	pub importo_totale: String,

	#[new(default)]
	pub prestatore_denominazione: String,

	#[new(default)]
	pub prestatore_indirizzo: String,

	#[new(default)]
	pub committente_denominazione: String,

	#[new(default)]
	pub committente_indirizzo: String,

	#[new(default)]
	pub imponibile_importo: String,

	#[new(default)]
	pub imposta: String,

	#[new(default)]
	pub esigibilita_iva: String,

	#[new(default)]
	pub data_riferimento_termini: String,

	#[new(default)]
	pub data_scadenza_pagamento: String,

	#[new(default)]
	pub importo_pagamento: String,
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Debug, Default, new)]
pub struct FatturaToCapture {

	#[new(default)]
	pub dettaglio_linee: Vec<DettaglioLinee>,

	#[new(default)]
	pub numero_fattura: String,

	#[new(default)]
	pub giorno_data: String,

	#[new(default)]
	pub importo_totale: String,

	#[new(default)]
	pub prestatore_denominazione: String,

	#[new(default)]
	pub prestatore_indirizzo: String,

	#[new(default)]
	pub committente_denominazione: String,

	#[new(default)]
	pub committente_indirizzo: String,

	#[new(default)]
	pub imponibile_importo: String,

	#[new(default)]
	pub imposta: String,

	#[new(default)]
	pub esigibilita_iva: String,

	#[new(default)]
	pub data_riferimento_termini: String,

	#[new(default)]
	pub data_scadenza_pagamento: String,

	#[new(default)]
	pub importo_pagamento: String,
}

////////////////////////////////////////////////////////////////////////////////////////////////////

impl FatturaToCapture {
	pub fn upload_formatter(
		&self,
	) -> Vec<FatturaToUpload> {
		let mut fatture: Vec<FatturaToUpload> = vec![];
		for details in self.dettaglio_linee.iter() {
			fatture.push(
				FatturaToUpload {
					descrizione: details.descrizione.clone(),
					quantita: details.quantita.clone(),
					prezzo_unitario: details.prezzo_unitario.clone(),
					prezzo_totale: details.prezzo_totale.clone(),
					aliquota_iva: details.aliquota_iva.clone(),
					numero_fattura: self.numero_fattura.clone(),
					giorno_data: self.giorno_data.clone(),
					importo_totale: self.importo_totale.clone(),
					prestatore_denominazione: self.prestatore_denominazione.clone(),
					prestatore_indirizzo: self.prestatore_indirizzo.clone(),
					committente_denominazione: self.committente_denominazione.clone(),
					committente_indirizzo: self.committente_indirizzo.clone(),
					imponibile_importo: self.imponibile_importo.clone(),
					imposta: self.imposta.clone(),
					esigibilita_iva: self.esigibilita_iva.clone(),
					data_riferimento_termini: self.data_riferimento_termini.clone(),
					data_scadenza_pagamento: self.data_scadenza_pagamento.clone(),
					importo_pagamento: self.importo_pagamento.clone(),
				}
			);
		}
		return fatture;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Debug, new)]
pub struct DettaglioLinee {

	#[new(default)]
	pub descrizione: String,

	#[new(default)]
	pub quantita: String,

	#[new(default)]
	pub prezzo_unitario: String,

	#[new(default)]
	pub prezzo_totale: String,

	#[new(default)]
	pub aliquota_iva: String,
}

////////////////////////////////////////////////////////////////////////////////////////////////////

impl DettaglioLinee {
	pub fn check(
		&self,
	) -> bool {
		!(self.descrizione.is_empty() | self.quantita.is_empty() | self.prezzo_unitario.is_empty() | self.prezzo_totale.is_empty() | self.aliquota_iva.is_empty())
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
