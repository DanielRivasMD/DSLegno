////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::custom::dettaglio_linee::DettaglioLinee;
use crate::custom::dati_riepilogo::DatiRiepilogo;

////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Default, new)]
pub struct DatiBeniServizi {

	#[new(default)]
	dettaglio_linee: Vec<DettaglioLinee>,

	#[new(default)]
	dati_riepilogo: DatiRiepilogo,
}

////////////////////////////////////////////////////////////////////////////////////////////////////