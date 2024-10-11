////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Debug, Default, new)]
pub struct Sede {

	#[new(default)]
	pub indirizzo: String,

	#[new(default)]
	pub numero_civico: String,

	#[new(default)]
	pub cap: String,

	#[new(default)]
	pub comune: String,

	#[new(default)]
	pub provinzia: String,

	#[new(default)]
	pub nazione: String,
}

////////////////////////////////////////////////////////////////////////////////////////////////////
