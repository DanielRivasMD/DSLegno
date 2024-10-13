////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use std::fmt::{
  Display,
  Formatter,
  Result,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

// TODO: add variants to capture address
#[derive(Debug, new)]
pub enum Tagged {
	PrestatoreDenominazione,
	PrestatoreIndirizzo,
	PrestatoreRea,
	CommittenteDenominazione,
	CommittenteIndirizzo,
	Fattura,
	GiornoData,
	ImportoTotale,
	Descrizione,
	Quantita,
	PrezzoUnitario,
	PrezzoTotale,
	AliquotaIVA,
	ImponibileImporto,
	Imposta,
	EsigibilitaIVA,
	DataRiferimentoTermini,
	DataScadenzaPagamento,
	ImportoPagamento,
	None,
}


////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Clone, new)]
pub struct Tag {

  #[new(default)]
 	pub child: String,

  #[new(default)]
 	pub parent: String,

  #[new(default)]
 	pub gparent: String,

  #[new(default)]
 	pub ggparent: String,
}

////////////////////////////////////////////////////////////////////////////////////////////////////

impl Tag {
	pub fn check_lineage(
		&self,
	) -> (bool, bool) {
		(self.gparent != "", self.parent != "")
	}

	pub fn identify(
		&mut self,
		name: String,
	) {
		self.child = name;
	}

	pub fn up_scroll(
		&mut self,
		name: String,
	) {
		self.ggparent = self.gparent.clone();
		self.gparent = self.parent.clone();
		self.parent = self.child.clone();
		self.identify(name);
	}

	pub fn down_scroll(
		&mut self,
	) {
		self.child = self.parent.clone();
		self.parent = self.gparent.clone();
		self.gparent = self.ggparent.clone();
		self.ggparent = String::new();
	}
}

/// Implement Display for Ind.
impl Display for Tag {
  fn fmt(
    &self,
    f: &mut Formatter,
  ) -> Result {
    writeln!(
      f,
      "\t{:<30}{:?}\n\t{:<30}{:?}\n\t{:<30}{:?}\n",
      "Child:", self.child, "Parent:", self.parent, "GrandParent: ", self.gparent,
    )
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
