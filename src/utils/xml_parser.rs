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
