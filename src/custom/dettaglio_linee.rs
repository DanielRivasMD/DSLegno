////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(new)]
pub struct DettaglioLinee {

	#[new(default)]
	numero_linea: u32,

	#[new(default)]
	descrizione: String,

	#[new(default)]
	quantita: f32,

	#[new(default)]
	unita_misura: String,

	#[new(default)]
	prezzo_unitario: String,

	#[new(default)]
	preazzo_totale: f32,

	#[new(default)]
	aliquota_iva: f32,
}

////////////////////////////////////////////////////////////////////////////////////////////////////
