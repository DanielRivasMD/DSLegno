////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use std::fmt::{
  Display,
  Formatter,
  Result,
};

////////////////////////////////////////////////////////////////////////////////////////////////////

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
	Imposto,
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
 	child: String,

  #[new(default)]
 	parent: String,

  #[new(default)]
 	grandparent: String,
}

////////////////////////////////////////////////////////////////////////////////////////////////////

impl Tag {
	pub fn check_lineage(
		&self,
	) -> (bool, bool) {
		(self.grandparent != "", self.parent != "")
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
		self.grandparent = self.parent.clone();
		self.parent = self.child.clone();
		self.identify(name);
	}

	pub fn down_scroll(
		&mut self,
	) {
		self.child = self.parent.clone();
		self.parent = self.grandparent.clone();
		self.grandparent = String::new();
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
      "Child:", self.child, "Parent:", self.parent, "GrandParent: ", self.grandparent,
    )
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
