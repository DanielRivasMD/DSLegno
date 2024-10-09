////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::custom::dati_anagrafica::DatiAnagrafica;
use crate::custom::iscrizione_rea::IscrizioneREA;
use crate::custom::sede::Sede;

////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Default, new)]
pub struct Participant {

	#[new(default)]
	dati_anagrafica: DatiAnagrafica,

	#[new(default)]
	sede: Sede,

	#[new(default)]
	iscrizione_rea: IscrizioneREA,
}

////////////////////////////////////////////////////////////////////////////////////////////////////
