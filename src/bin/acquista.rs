////////////////////////////////////////////////////////////////////////////////////////////////////

use std::fs::File;
use std::io::BufReader;
use xml::common::Position;
use xml::reader::{ParserConfig, XmlEvent};

use std::fmt::{
  Display,
  Formatter,
  Result,
};

#[macro_use]
extern crate derive_new;


// TODO: migrate custom structs
#[derive(Default, new)]
struct FatturaHeader {

	// dati_transmissione: DatiTrasmittente,

	#[new(default)]
	cedente_prestatore: Participant,

	#[new(default)]
	cessionario_committente: Participant,
}


// struct DatiTrasmittente {

// 	id_trasmittente: IDTrasmittente,

// }

// struct IDTrasmittente {

// 	id_paese: String,

// 	id_codice: String,
// }

#[derive(Default, new)]
struct Participant {

	#[new(default)]
	dati_anagrafica: DatiAnagrafica,

	#[new(default)]
	sede: Sede,

	#[new(default)]
	iscrizione_rea: IscrizioneREA,
}

#[derive(Default, new)]
struct DatiAnagrafica {

	#[new(default)]
	idfiscale: IDFiscale,

	#[new(default)]
	codice_fiscale: String,

	#[new(default)]
	anagrafica: Anagrafica,

	#[new(default)]
	regime_fiscale: String,
}

#[derive(Default, new)]
struct IDFiscale {

	#[new(default)]
	idpaese: String,

	#[new(default)]
	idcodice: String,
}

#[derive(Default, new)]
struct Anagrafica {

	#[new(default)]
	denominazine: String,
}

#[derive(Default, new)]
struct Sede {

	#[new(default)]
	indirizzo: String,

	#[new(default)]
	numero_civico: String,

	#[new(default)]
	cap: String,

	#[new(default)]
	comune: String,

	#[new(default)]
	provinzia: String,

	#[new(default)]
	nazione: String,
}

#[derive(Default, new)]
struct IscrizioneREA {

	#[new(default)]
	ufficio: String,

	#[new(default)]
	numero_rea: String,

	#[new(default)]
	capitale_sociale: String,

	#[new(default)]
	socio_unico: String,

	#[new(default)]
	stato_liquidazione: String,
}

#[derive(Default, new)]
struct FatturaBody {

	#[new(default)]
	dati_generale: DatiGenerale,

	#[new(default)]
	dati_beni_servizi: DatiBeniServizi,

	#[new(default)]
	dati_pagamento: DatiPagamento,
}

#[derive(Default, new)]
struct DatiGenerale {

	#[new(default)]
	tipo_documento: String,

	#[new(default)]
	divisa: String,

	#[new(default)]
	data: String,

	#[new(default)]
	numero: String,

	#[new(default)]
	importo_totale: f32,
}

#[derive(Default, new)]
struct DatiBeniServizi {

	#[new(default)]
	dettaglio_linee: Vec<DettaglioLinee>,

	#[new(default)]
	dati_riepilogo: DatiRiepilogo,
}

#[derive(new)]
struct DettaglioLinee {

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

#[derive(Default, new)]
struct DatiRiepilogo {

	#[new(default)]
	aliquota_iva: f32,

	#[new(default)]
	imponinile_importo: f32,

	#[new(default)]
	imposta: f32,

	#[new(default)]
	esigibilita_iva: String,
}

#[derive(Default, new)]
struct DatiPagamento {

	#[new(default)]
	condizioni_pagamento: String,

	#[new(default)]
	dettaglio_pagamento: DettaglioPagamento,
}

#[derive(Default, new)]
struct DettaglioPagamento {

	#[new(default)]
	modalita_pagamento: String,

	#[new(default)]
	data_riferimento: String,

	#[new(default)]
	data_scadenza_pagamento: String,

	#[new(default)]
	importo_pagamento: f32,

	#[new(default)]
	iban: u32,
}


#[derive(Clone, new)]
struct Tag {

  #[new(default)]
 	child: String,

  #[new(default)]
 	parent: String,

  #[new(default)]
 	grandparent: String,
}


impl Tag {
	fn check_lineage(
		&self,
	) -> (bool, bool) {
		(self.grandparent != "", self.parent != "")
	}

	fn identify(
		&mut self,
		name: String,
	) {
		self.child = name;
	}

	fn up_scroll(
		&mut self,
		name: String,
	) {
		self.grandparent = self.parent.clone();
		self.parent = self.child.clone();
		self.identify(name);
	}

	fn down_scroll(
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

// TODO: parser functional. select desired fields. IMPORTANT: multiple records on one file
fn main() {
	let file_path = std::env::args_os().nth(1).expect("Please specify a path to an XML file");
	let file = File::open(file_path).unwrap();

	let mut reader = ParserConfig::default()
		.ignore_root_level_whitespace(false)
		.create_reader(BufReader::new(file));

	let mut tag = Tag::new();

	// TODO: move xml reader logic to function
	loop {
		match reader.next() {
			Ok(e) => {
				// print!("{}\t", reader.position());

				match e {

					XmlEvent::EndDocument => {
						println!("EndDocument");
						break;
					},

					XmlEvent::StartElement { name, attributes, .. } => {
						if attributes.is_empty() {

							tag.up_scroll(name.to_string());

						} else {
							let attrs: Vec<_> = attributes
								.iter()
								.map(|a| format!("{}={:?}", &a.name, a.value))
								.collect();
							println!("StartElement({name} [{}])", attrs.join(", "));
						}
					},

					XmlEvent::EndElement { name } => {
						tag.down_scroll();
					},

					XmlEvent::Comment(data) => {
						println!(r#"Comment("{}")"#, data.escape_debug());
					},

					XmlEvent::CData(data) => {
						// if tag.child == "IdPaese" {
							println!("{}", tag);
							println!("{}", data.escape_debug());
						// }
					}

					XmlEvent::Characters(data) => {
						println!("{}", tag);
							println!("{}", data.escape_debug());
						// println!(r#"Characters("{}")"#, data.escape_debug())
					},

					XmlEvent::Whitespace(data) => {  
						// println!(r#"Whitespace("{}")"#, data.escape_debug())
					},

					_ => (),

				}
			},
			Err(e) => {
				eprintln!("Error at {}: {e}", reader.position());
				break;
			},
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////////////////////////////////////////////////////////////////

// #![allow(non_snake_case)]

// ////////////////////////////////////////////////////////////////////////////////////////////////////

// use dioxus::prelude::*;

// ////////////////////////////////////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////////////////////////////////////////////////////////////////

// use chrono::{DateTime, Utc};
// use serde::{Deserialize, Serialize};

// fn main() {
// 	launch(App);
// }

// pub fn App() -> Element {
// 	rsx! {
// 		StoryListing {
// 			story: StoryItem {
// 				id: 0,
// 				title: "hello hackernews".to_string(),
// 				url: None,
// 				text: None,
// 				by: "Author".to_string(),
// 				score: 0,
// 				descendants: 0,
// 				time: chrono::Utc::now(),
// 				kids: vec![],
// 				r#type: "".to_string(),
// 			}
// 		}
// 	}
// }

// // Define the Hackernews types
// #[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
// pub struct StoryPageData {
// 	#[serde(flatten)]
// 	pub item: StoryItem,
// 	#[serde(default)]
// 	pub comments: Vec<Comment>,
// }

// #[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
// pub struct Comment {
// 	pub id: i64,
// 	/// there will be no by field if the comment was deleted
// 	#[serde(default)]
// 	pub by: String,
// 	#[serde(default)]
// 	pub text: String,
// 	#[serde(with = "chrono::serde::ts_seconds")]
// 	pub time: DateTime<Utc>,
// 	#[serde(default)]
// 	pub kids: Vec<i64>,
// 	#[serde(default)]
// 	pub sub_comments: Vec<Comment>,
// 	pub r#type: String,
// }

// #[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
// pub struct StoryItem {
// 	pub id: i64,
// 	pub title: String,
// 	pub url: Option<String>,
// 	pub text: Option<String>,
// 	#[serde(default)]
// 	pub by: String,
// 	#[serde(default)]
// 	pub score: i64,
// 	#[serde(default)]
// 	pub descendants: i64,
// 	#[serde(with = "chrono::serde::ts_seconds")]
// 	pub time: DateTime<Utc>,
// 	#[serde(default)]
// 	pub kids: Vec<i64>,
// 	pub r#type: String,
// }

// #[component]
// fn StoryListing(story: ReadOnlySignal<StoryItem>) -> Element {
// 	let StoryItem {
// 		title,
// 		url,
// 		by,
// 		score,
// 		time,
// 		kids,
// 		..
// 	} = &*story.read();

// 	let url = url.as_deref().unwrap_or_default();
// 	let hostname = url
// 		.trim_start_matches("https://")
// 		.trim_start_matches("http://")
// 		.trim_start_matches("www.");
// 	let score = format!("{score} {}", if *score == 1 { " point" } else { " points" });
// 	let comments = format!(
// 		"{} {}",
// 		kids.len(),
// 		if kids.len() == 1 {
// 			" comment"
// 		} else {
// 			" comments"
// 		}
// 	);
// 	let time = time.format("%D %l:%M %p");

// 	rsx! {
// 		div { padding: "0.5rem", position: "relative",
// 			div { font_size: "1.5rem",
// 				a { href: url, "{title}" }
// 				a {
// 					color: "gray",
// 					href: "https://news.ycombinator.com/from?site={hostname}",
// 					text_decoration: "none",
// 					" ({hostname})"
// 				}
// 			}
// 			div { display: "flex", flex_direction: "row", color: "gray",
// 				div { "{score}" }
// 				div { padding_left: "0.5rem", "by {by}" }
// 				div { padding_left: "0.5rem", "{time}" }
// 				div { padding_left: "0.5rem", "{comments}" }
//             }
//         }
//     }
// }

// ////////////////////////////////////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////////////////////////////////////////////////////////////////
