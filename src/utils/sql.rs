////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use diesel::sqlite::SqliteConnection;
use diesel::insert_into;
use diesel::prelude::*;
use std::error::Error;

////////////////////////////////////////////////////////////////////////////////////////////////////


// crate utilities
use crate::custom::fattura::*;
use crate::custom::schema::tabella_vendite::dsl::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

pub fn establish_db_connection() -> SqliteConnection {
	let db_path = get_db_path().clone();

	SqliteConnection::establish(db_path.as_str())
		.unwrap_or_else(|_| panic!("Error connecting to {}", db_path))
}

pub fn insert_insertable_struct(fattura: FatturaToUpload, conn: &mut SqliteConnection) -> Result<(), Box<dyn Error>> {
	insert_into(tabella_vendite).values(&fattura).execute(conn)?;
	Ok(())
}

////////////////////////////////////////////////////////////////////////////////////////////////////

fn get_db_path() -> String {
	// let home_dir = dirs::home_dir().unwrap();
	// home_dir.to_str().unwrap().to_string() + "/.config/orion/database.sqlite"
	"dallasanta.sql".to_string()
}

////////////////////////////////////////////////////////////////////////////////////////////////////
