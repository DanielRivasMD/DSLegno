////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::custom::participant::Participant;

////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Default, new)]
pub struct FatturaHeader {

	// dati_transmissione: DatiTrasmittente,

	#[new(default)]
	cedente_prestatore: Participant,

	#[new(default)]
	cessionario_committente: Participant,
}

////////////////////////////////////////////////////////////////////////////////////////////////////
