////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Debug, Default, new)]
pub struct DatiGenerale {

	#[new(default)]
	pub giorno_data: String,

	#[new(default)]
	pub numero: String,

	#[new(default)]
	pub importo_totale: f32,
}

////////////////////////////////////////////////////////////////////////////////////////////////////