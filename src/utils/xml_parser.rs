////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use std::fs::File;
use std::io::BufReader;
use xml::common::Position;
use xml::reader::{ParserConfig, XmlEvent};
use diesel::sqlite::SqliteConnection;
use diesel::insert_into;
use diesel::prelude::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::custom::tag::*;

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

/// parse xml file (fattura)
pub fn xml_parser(file: File) {

	let mut reader = ParserConfig::default()
		.ignore_root_level_whitespace(false)
		.create_reader(BufReader::new(file));

	let mut tag = Tag::new();
	let mut tagged = Tagged::new_none();

	let mut conn = establish_db_connection();

	loop {
		match reader.next() {
			Ok(e) => {
				// print!("{}\t", reader.position());

				match e {

					XmlEvent::EndDocument => {
						// println!("EndDocument");
						break;
					},

					XmlEvent::StartElement { name, attributes, .. } => {
						if attributes.is_empty() {

							tag.up_scroll(name.to_string());
							tagged = data_tagger(&tag);
							println!("{}", tag);
						}
					},

					XmlEvent::EndElement { name } => {
						tag.down_scroll();
						// tagged = Tagged::new_none();
					},

					XmlEvent::Comment(data) => {
						// println!("{:?}", &tagged);
						data_extractor(&data, &tagged, &mut conn);
						// println!(r#"Comment("{}")"#, data.escape_debug());
					},

					XmlEvent::CData(data) => {
						// println!("{:?}", &tagged);
						data_extractor(&data, &tagged, &mut conn);
						// println!("{}", data.escape_debug());
					}

					XmlEvent::Characters(data) => {
						// println!("{:?}", &tagged);
						data_extractor(&data, &tagged, &mut conn);
						// println!(r#"Characters("{}")"#, data.escape_debug())
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
		// ("AliquotaIVA", "DatiRiepilogo", "DatiBeniServizi") => Tagged::AliquotaIVA,
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
fn data_extractor(data: &String, tagged: &Tagged, fattura: &mut Fattura) {
	match tagged {
		Tagged::Descrizione => {
			println!("{}", "descrizione");
			// TODO: better implementation for adding elements
			if fattura.fattura_body.dati_beni_servizi.dettaglio_linee.len() == 0 || fattura.fattura_body.dati_beni_servizi.dettaglio_linee.last().unwrap().check() {
				fattura.fattura_body.dati_beni_servizi.dettaglio_linee.push(DettaglioLinee::new());
			}
			fattura.fattura_body.dati_beni_servizi.dettaglio_linee.last_mut().unwrap().descrizione = data.to_string();
		}
		Tagged::Quantita => {
			println!("{}", "quantita");
			if fattura.fattura_body.dati_beni_servizi.dettaglio_linee.last().unwrap().check() {
				fattura.fattura_body.dati_beni_servizi.dettaglio_linee.push(DettaglioLinee::new());
			}
			fattura.fattura_body.dati_beni_servizi.dettaglio_linee.last_mut().unwrap().quantita = data.parse::<f32>().unwrap();
		}
		Tagged::PrezzoUnitario => {
			println!("{}", "prezzo_unitario");
			if fattura.fattura_body.dati_beni_servizi.dettaglio_linee.last().unwrap().check() {
				fattura.fattura_body.dati_beni_servizi.dettaglio_linee.push(DettaglioLinee::new());
			}
			fattura.fattura_body.dati_beni_servizi.dettaglio_linee.last_mut().unwrap().prezzo_unitario = data.to_string();
		}
		Tagged::PrezzoTotale => {
			println!("{}", "prezzo_totale");
			if fattura.fattura_body.dati_beni_servizi.dettaglio_linee.last().unwrap().check() {
				fattura.fattura_body.dati_beni_servizi.dettaglio_linee.push(DettaglioLinee::new());
			}
			fattura.fattura_body.dati_beni_servizi.dettaglio_linee.last_mut().unwrap().prezzo_totale = data.parse::<f32>().unwrap();
		}
		Tagged::AliquotaIVA => {
			println!("{}", "aliquota_iva");
			if fattura.fattura_body.dati_beni_servizi.dettaglio_linee.last().unwrap().check() {
				fattura.fattura_body.dati_beni_servizi.dettaglio_linee.push(DettaglioLinee::new());
			}
			fattura.fattura_body.dati_beni_servizi.dettaglio_linee.last_mut().unwrap().aliquota_iva = data.parse::<f32>().unwrap();
		}
		Tagged::Fattura => {
			println!("{}", "fattura");
			fattura.fattura_body.dati_generale.numero = data.to_string();
		}
		Tagged::GiornoData => {
			println!("{}", "giorno_data");
			fattura.fattura_body.dati_generale.giorno_data = data.to_string();
		}
		Tagged::ImportoTotale => {
			println!("{}", "importo_totale");
			fattura.fattura_body.dati_generale.importo_totale = data.parse::<f32>().unwrap();
		}
		Tagged::PrestatoreDenominazione => {
			println!("{}", "prestatore denominazione");
			fattura.fattura_header.cedente_prestatore.dati_anagrafica.anagrafica.denominazione = data.to_string();
		}
		Tagged::PrestatoreIndirizzo => {
			println!("{}", "prestatore indirizzo");
			fattura.fattura_header.cedente_prestatore.sede.indirizzo = data.to_string();
		}
		Tagged::CommittenteDenominazione => {
			println!("{}", "committente denominazione");
			fattura.fattura_header.cessionario_committente.dati_anagrafica.anagrafica.denominazione = data.to_string();
		}
		Tagged::CommittenteIndirizzo => {
			println!("{}", "committente indirizzo");
			fattura.fattura_header.cessionario_committente.sede.indirizzo = data.to_string();
		}
		Tagged::ImponibileImporto => {
			println!("{}", "imponibile_importo");
			fattura.fattura_body.dati_beni_servizi.dati_riepilogo.imponibile_importo = data.parse::<f32>().unwrap();
		}
		Tagged::Imposta => {
			println!("{}", "imposta");
			fattura.fattura_body.dati_beni_servizi.dati_riepilogo.imposta = data.parse::<f32>().unwrap();
		}
		Tagged::EsigibilitaIVA => {
			println!("{}", "esigibilita_iva");
			fattura.fattura_body.dati_beni_servizi.dati_riepilogo.esigibilita_iva = data.to_string();
		}
		Tagged::DataRiferimentoTermini => {
			println!("{}", "data_riferimento_termini");
			fattura.fattura_body.dati_pagamento.dettaglio_pagamento.data_riferimento = data.to_string();
		}
		Tagged::DataScadenzaPagamento => {
			println!("{}", "data_scadenza_pagamento");
			fattura.fattura_body.dati_pagamento.dettaglio_pagamento.data_scadenza_pagamento = data.to_string();
		}
		Tagged::ImportoPagamento => {
			println!("{}", "importo_pagamento");
			fattura.fattura_body.dati_pagamento.dettaglio_pagamento.importo_pagamento = data.parse::<f32>().unwrap();
		}
		_ => (),
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
