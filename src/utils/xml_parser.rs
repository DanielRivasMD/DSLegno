////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use std::fs::File;
use std::io::BufReader;
use xml::common::Position;
use xml::reader::{ParserConfig, XmlEvent};

////////////////////////////////////////////////////////////////////////////////////////////////////

pub fn xml_parser(reader: EventReader<BufReader<File>>) {
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
////////////////////////////////////////////////////////////////////////////////////////////////////
