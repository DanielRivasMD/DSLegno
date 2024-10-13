////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use std::fs::File;
use std::io::BufReader;
use xml::common::Position;
use xml::reader::{ParserConfig, XmlEvent};
use diesel::sqlite::SqliteConnection;
use diesel::insert_into;
use diesel::prelude::*;
use std::error::Error;

////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::custom::tag::*;
use crate::custom::fattura::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

mod schema {
	diesel::table! {
		tabella_vendite {
			id -> Integer,
			operazione -> Integer,
			prestatore_denominazione -> Text,
			prestatore_indirizzo -> Text,
			committente_denominazione -> Text,
			committente_indirizzo -> Text,
			fattura -> Text,
			giorno_data -> Text,
			importo_totale -> Text,
			descrizione -> Text,
			quantita -> Text,
			prezzo_unitario -> Text,
			prezzo_totale -> Text,
			aliquota_iva -> Text,
			imponibile_importo -> Text,
			imposta -> Text,
			esigibilita_iva -> Char,
			data_riferimento_termini -> Text,
			data_scadenza_pagamento -> Text,
			importo_pagamento -> Text,
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

fn get_db_path() -> String {
	// let home_dir = dirs::home_dir().unwrap();
	// home_dir.to_str().unwrap().to_string() + "/.config/orion/database.sqlite"
	"dallasanta.sql".to_string()
}

fn establish_db_connection() -> SqliteConnection {
	let db_path = get_db_path().clone();
	// let db_path = "dallasanta.sql".to_string();

	SqliteConnection::establish(db_path.as_str())
		.unwrap_or_else(|_| panic!("Error connecting to {}", db_path))
}

pub fn insert_insertable_struct(fattura: FatturaToUpload, conn: &mut SqliteConnection) -> Result<(), Box<dyn Error>> {
	// use schema::tabella_vendite::dsl::*;

	// let vendite_form = serde_json::to_string(&fattura).unwrap();
// println!("{}", vendite_form);

	// insert_into(tabella_vendite).values(&vendite_form).execute(conn)?;
	insert_into(tabella_vendite).values(&fattura).execute(conn)?;

	Ok(())
}

/// parse xml file (fattura)
pub fn xml_parser(file: File) {

	// get file reader
	let mut reader = ParserConfig::default()
		.ignore_root_level_whitespace(false)
		.create_reader(BufReader::new(file));

	// initialize tags
	let mut tag = Tag::new();
	let mut tagged = Tagged::new_none();

	// initialize invoice
	let mut fattura_to_capture = FatturaToCapture::new();

	// iterate on file
	loop {
		match reader.next() {
			Ok(line) => {

				match line {

					XmlEvent::EndDocument => {
						break;
					},

					XmlEvent::StartElement { name, attributes, .. } => {
						if attributes.is_empty() {
							tag.up_scroll(name.to_string());
							tagged = data_tagger(&tag);
						}
					},

					XmlEvent::EndElement { name } => {
						tag.down_scroll();
					},

					XmlEvent::Comment(data) | XmlEvent::CData(data) | XmlEvent::Characters(data) => {
						data_extractor(&data, &tagged, &mut fattura_to_capture);
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

	// open database connection
	let mut conn = establish_db_connection();

	// prepare data to upload
	let fatture_to_upload = fattura_to_capture.upload_formatter();

	// upload to database
	for fattura_to_upload in fatture_to_upload.into_iter() {
		let _ = insert_insertable_struct(fattura_to_upload, &mut conn);
	}
	println!("{}", "inserted!");
}

////////////////////////////////////////////////////////////////////////////////////////////////////

fn data_tagger(tag: &Tag) -> Tagged {
	match (tag.child.as_str(), tag.parent.as_str(), tag.gparent.as_str()) {
		// cedente prestatore
		("Indirizzo", "Sede", "CedentePrestatore") => Tagged::PrestatoreIndirizzo,
		// cessionario committente
		("Indirizzo", "Sede", "CessionarioCommittente") => Tagged::CommittenteIndirizzo,
		// dati generali documento
		("Numero", "DatiGeneraliDocumento", "DatiGenerali") => Tagged::Fattura,
		("Data", "DatiGeneraliDocumento", "DatiGenerali") => Tagged::GiornoData,
		("ImportoTotaleDocumento", "DatiGeneraliDocumento", "DatiGenerali") => Tagged::ImportoTotale,
		// dettaglio linee
		("Descrizione", "DettaglioLinee", "DatiBeniServizi") => Tagged::Descrizione,
		("Quantita", "DettaglioLinee", "DatiBeniServizi") => Tagged::Quantita,
		("PrezzoUnitario", "DettaglioLinee", "DatiBeniServizi") => Tagged::PrezzoUnitario,
		("PrezzoTotale", "DettaglioLinee", "DatiBeniServizi") => Tagged::PrezzoTotale,
		("AliquotaIVA", "DettaglioLinee", "DatiBeniServizi") => Tagged::AliquotaIVA,
		// dati riepilogo
		("ImponibileImporto", "DatiRiepilogo", "DatiBeniServizi") => Tagged::ImponibileImporto,
		("Imposta", "DatiRiepilogo", "DatiBeniServizi") => Tagged::Imposta,
		("EsigibilitaIVA", "DatiRiepilogo", "DatiBeniServizi") => Tagged::EsigibilitaIVA,
		// condizioni pagamento
		("DataRiferimentoTerminiPagamento", "DettaglioPagamento", "DatiPagamento") => Tagged::DataRiferimentoTermini,
		("DataScadenzaPagamento", "DettaglioPagamento", "DatiPagamento") => Tagged::DataScadenzaPagamento,
		("ImportoPagamento", "DettaglioPagamento", "DatiPagamento") => Tagged::ImportoPagamento,
		// denominazione
		("Denominazione", "Anagrafica", "DatiAnagrafici") => {
			match tag.ggparent.as_str() {
				"CedentePrestatore" => Tagged::PrestatoreDenominazione,
				"CessionarioCommittente" => Tagged::CommittenteDenominazione,
				_ => Tagged::None,
			}
		},
		// none
		(_, _, _) => Tagged::None
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

/// extract data from fields
fn data_extractor(data: &String, tagged: &Tagged, fattura: &mut FatturaToCapture) {
	match tagged {
		Tagged::Descrizione => {
			println!("{}", "descrizione");
			// TODO: better implementation for adding elements
			if fattura.dettaglio_linee.len() == 0 || fattura.dettaglio_linee.last().unwrap().check() {
				fattura.dettaglio_linee.push(DettaglioLinee::new());
			}
			fattura.dettaglio_linee.last_mut().unwrap().descrizione = data.to_string();
		}
		Tagged::Quantita => {
			println!("{}", "quantita");
			if fattura.dettaglio_linee.last().unwrap().check() {
				fattura.dettaglio_linee.push(DettaglioLinee::new());
			}
			fattura.dettaglio_linee.last_mut().unwrap().quantita = data.to_string();
		}
		Tagged::PrezzoUnitario => {
			println!("{}", "prezzo_unitario");
			if fattura.dettaglio_linee.last().unwrap().check() {
				fattura.dettaglio_linee.push(DettaglioLinee::new());
			}
			fattura.dettaglio_linee.last_mut().unwrap().prezzo_unitario = data.to_string();
		}
		Tagged::PrezzoTotale => {
			println!("{}", "prezzo_totale");
			if fattura.dettaglio_linee.last().unwrap().check() {
				fattura.dettaglio_linee.push(DettaglioLinee::new());
			}
			fattura.dettaglio_linee.last_mut().unwrap().prezzo_totale = data.to_string();
		}
		Tagged::AliquotaIVA => {
			println!("{}", "aliquota_iva");
			if fattura.dettaglio_linee.last().unwrap().check() {
				fattura.dettaglio_linee.push(DettaglioLinee::new());
			}
			fattura.dettaglio_linee.last_mut().unwrap().aliquota_iva = data.to_string();
		}
		Tagged::Fattura => {
			println!("{}", "fattura");
			fattura.numero_fattura = data.to_string();
		}
		Tagged::GiornoData => {
			println!("{}", "giorno_data");
			fattura.giorno_data = data.to_string();
		}
		Tagged::ImportoTotale => {
			println!("{}", "importo_totale");
			fattura.importo_totale = data.to_string();
		}
		Tagged::PrestatoreDenominazione => {
			println!("{}", "prestatore denominazione");
			fattura.prestatore_denominazione = data.to_string();
		}
		Tagged::PrestatoreIndirizzo => {
			println!("{}", "prestatore indirizzo");
			fattura.prestatore_indirizzo = data.to_string();
		}
		Tagged::CommittenteDenominazione => {
			println!("{}", "committente denominazione");
			fattura.committente_denominazione = data.to_string();
		}
		Tagged::CommittenteIndirizzo => {
			println!("{}", "committente indirizzo");
			fattura.committente_indirizzo = data.to_string();
		}
		Tagged::ImponibileImporto => {
			println!("{}", "imponibile_importo");
			fattura.imponibile_importo = data.to_string();
		}
		Tagged::Imposta => {
			println!("{}", "imposta");
			fattura.imposta = data.to_string();
		}
		Tagged::EsigibilitaIVA => {
			println!("{}", "esigibilita_iva");
			fattura.esigibilita_iva = data.to_string();
		}
		Tagged::DataRiferimentoTermini => {
			println!("{}", "data_riferimento_termini");
			fattura.data_riferimento_termini = data.to_string();
		}
		Tagged::DataScadenzaPagamento => {
			println!("{}", "data_scadenza_pagamento");
			fattura.data_scadenza_pagamento = data.to_string();
		}
		Tagged::ImportoPagamento => {
			println!("{}", "importo_pagamento");
			fattura.importo_pagamento = data.to_string();
		}
		_ => (),
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
