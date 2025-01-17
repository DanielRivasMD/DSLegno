////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use clap::Parser;
use std::path::PathBuf;

////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::custom::{invoice::InvoiceType, log_flag::LogFlag};

////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
pub struct Cli {
    /// Logging level
    #[arg(short, long, value_enum, default_value_t = LogFlag::Info)]
    pub log: LogFlag,

    /// Input file
    #[arg(long)]
    pub input: PathBuf,

    /// Invoice type
    #[arg(long)]
    pub invoice: InvoiceType,
}

////////////////////////////////////////////////////////////////////////////////////////////////////
