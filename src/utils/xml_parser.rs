////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use std::fs::File;
use std::io::BufReader;
use xml::common::Position;
use xml::reader::{ParserConfig, XmlEvent};

////////////////////////////////////////////////////////////////////////////////////////////////////

pub fn xml_parser(reader: EventReader<BufReader<File>>) {
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
			imposto -> Text,
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
		("Imposto", "DatiRiepilogo", "DatiBeniServizi") => Tagged::Imposto,
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
fn data_extractor(data: &String, tagged: &Tagged, conn: &mut SqliteConnection) {
	use schema::tabella_vendite::dsl::*;

	match tagged {
		Tagged::Descrizione => {
			println!("{}", "descrizione");
			let _ = insert_into(tabella_vendite).values(descrizione.eq(data)).execute(conn);
		}
		Tagged::Quantita => {
			println!("{}", "quantita");
			let _ = insert_into(tabella_vendite).values(quantita.eq(data)).execute(conn);
		}
		Tagged::PrezzoUnitario => {
			println!("{}", "prezzo_unitario");
			let _ = insert_into(tabella_vendite).values(prezzo_unitario.eq(data)).execute(conn);
		}
		Tagged::PrezzoTotale => {
			println!("{}", "prezzo_totale");
			let _ = insert_into(tabella_vendite).values(prezzo_totale.eq(data)).execute(conn);
		}
		Tagged::AliquotaIVA => {
			println!("{}", "aliquota_iva");
			let _ = insert_into(tabella_vendite).values(aliquota_iva.eq(data)).execute(conn);
		}
		Tagged::Fattura => {
			println!("{}", "fattura");
			let _ = insert_into(tabella_vendite).values(fattura.eq(data)).execute(conn);
		}
		Tagged::GiornoData => {
			println!("{}", "giorno_data");
			let _ = insert_into(tabella_vendite).values(giorno_data.eq(data)).execute(conn);
		}
		Tagged::ImportoTotale => {
			println!("{}", "importo_totale");
			let _ = insert_into(tabella_vendite).values(importo_totale.eq(data)).execute(conn);
		}
		Tagged::PrestatoreDenominazione => {
			println!("{}", "prestatore denominazione");
			let _ = insert_into(tabella_vendite).values(prestatore_denominazione.eq(data)).execute(conn);
		}
		Tagged::PrestatoreIndirizzo => {
			println!("{}", "prestatore indirizzo");
			let _ = insert_into(tabella_vendite).values(prestatore_indirizzo.eq(data)).execute(conn);
		}
		Tagged::CommittenteDenominazione => {
			println!("{}", "committente denominazione");
			let _ = insert_into(tabella_vendite).values(committente_denominazione.eq(data)).execute(conn);
		}
		Tagged::CommittenteIndirizzo => {
			println!("{}", "committente indirizzo");
			let _ = insert_into(tabella_vendite).values(committente_indirizzo.eq(data)).execute(conn);
		}
		Tagged::ImponibileImporto => {
			println!("{}", "imponibile_importo");
			let _ = insert_into(tabella_vendite).values(imponibile_importo.eq(data)).execute(conn);
		}
		Tagged::Imposto => {
			println!("{}", "imposto");
			let _ = insert_into(tabella_vendite).values(imposto.eq(data)).execute(conn);
		}
		Tagged::EsigibilitaIVA => {
			println!("{}", "esigibilita_iva");
			let _ = insert_into(tabella_vendite).values(esigibilita_iva.eq(data)).execute(conn);
		}
		Tagged::DataRiferimentoTermini => {
			println!("{}", "data_riferimento_termini");
			let _ = insert_into(tabella_vendite).values(data_riferimento_termini.eq(data)).execute(conn);
		}
		Tagged::DataScadenzaPagamento => {
			println!("{}", "data_scadenza_pagamento");
			let _ = insert_into(tabella_vendite).values(data_scadenza_pagamento.eq(data)).execute(conn);
		}
		Tagged::ImportoPagamento => {
			println!("{}", "importo_pagamento");
			let _ = insert_into(tabella_vendite).values(importo_pagamento.eq(data)).execute(conn);
		}
		_ => (),
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
