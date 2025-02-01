////////////////////////////////////////////////////////////////////////////////////////////////////

// library wrapper
use ds_legno::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use anyhow::Result as anyResult;
use clap::Parser;
use std::fs::File;

////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::custom::invoice::InvoiceType;
use crate::utils::help::*;
use crate::utils::sql::*;
use crate::utils::xml_parser::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

// DOC: check whether invoice number exists prior to inserting

////////////////////////////////////////////////////////////////////////////////////////////////////

fn main() -> anyResult<()> {
  // collect command line arguments
  let params = Cli::parse();

	// get path
	let file_path = params.input;
	let file = File::open(file_path)?;

	// parse file
	let fattura_to_capture = xml_parser(file)?;

	// open database connection
	let mut conn = establish_db_connection()?;

	match params.invoice {

		InvoiceType::Acquista => {
			// prepare data to upload
			let fatture_to_upload = fattura_to_capture.upload_formatter()?;
			// upload to database
			for fattura_to_upload in fatture_to_upload.into_iter() {
				insert_insertable_struct_acquisti(fattura_to_upload, &mut conn)?;
			}
		},

		InvoiceType::Vendita => {
			// prepare data to upload
			let fatture_to_upload = fattura_to_capture.upload_formatter()?;
			// upload to database
			for fattura_to_upload in fatture_to_upload.into_iter() {
				insert_insertable_struct_vendite(fattura_to_upload, &mut conn)?
			}
		},
	}

	Ok(())
}

////////////////////////////////////////////////////////////////////////////////////////////////////
