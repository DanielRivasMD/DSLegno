////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Debug, new)]
pub struct DettaglioLinee {

	#[new(default)]
	pub descrizione: String,

	#[new(default)]
	pub quantita: f32,

	#[new(default)]
	pub prezzo_unitario: String,

	#[new(default)]
	pub prezzo_totale: f32,

	#[new(default)]
	pub aliquota_iva: f32,
}

////////////////////////////////////////////////////////////////////////////////////////////////////

impl DettaglioLinee {
	pub fn check(
		&self,
	) -> bool {
		!(self.descrizione.is_empty() | self.quantita.is_nan() | self.prezzo_unitario.is_empty() | self.prezzo_totale.is_nan() | self.aliquota_iva.is_nan())
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
