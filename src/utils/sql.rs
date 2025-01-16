////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use anyhow::Result as anyResult;
use diesel::insert_into;
use diesel::prelude::*;
use diesel::sqlite::SqliteConnection;

////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::custom::fattura::*;
use crate::custom::schema::tabella_acquisti::dsl::*;
use crate::custom::schema::tabella_vendite::dsl::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

pub fn establish_db_connection() -> anyResult<SqliteConnection> {
    let db_path = get_db_path()?.clone();

    Ok(SqliteConnection::establish(db_path.as_str())
        .unwrap_or_else(|_| panic!("Error connecting to {}", db_path)))
}

pub fn insert_insertable_struct_acquisti(
    fattura: FatturaToUploadAcquisti,
    conn: &mut SqliteConnection,
) -> anyResult<()> {
    insert_into(tabella_acquisti)
        .values(&fattura)
        .execute(conn)?;
    Ok(())
}

pub fn insert_insertable_struct_vendite(
    fattura: FatturaToUploadVendite,
    conn: &mut SqliteConnection,
) -> anyResult<()> {
    insert_into(tabella_vendite)
        .values(&fattura)
        .execute(conn)?;
    Ok(())
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// DOC: hardcoded variable
// TODO: cli arg?
fn get_db_path() -> anyResult<String> {
    Ok("dallasanta.db".to_string())
}

////////////////////////////////////////////////////////////////////////////////////////////////////
