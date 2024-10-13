////////////////////////////////////////////////////////////////////////////////////////////////////

// library wrapper
use ds_legno::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use std::fs::File;

////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::utils::sql::*;
use crate::utils::xml_parser::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

fn main() {
	// get path
	let file_path = std::env::args_os().nth(1).expect("Please specify a path to an XML file");
	let file = File::open(file_path).unwrap();

	// parse file
	let fattura_to_capture = xml_parser(file);

	// open database connection
	let mut conn = establish_db_connection();

	// prepare data to upload
	let fatture_to_upload = fattura_to_capture.upload_formatter();

	// upload to database
	for fattura_to_upload in fatture_to_upload.into_iter() {
		let _ = insert_insertable_struct(fattura_to_upload, &mut conn);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
