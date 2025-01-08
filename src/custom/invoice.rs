////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use clap::ValueEnum;

////////////////////////////////////////////////////////////////////////////////////////////////////

/// invoice options from command line arguments
#[derive(Clone, Debug, Eq, PartialEq, ValueEnum)]
pub enum InvoiceType {
  Acquista,
  Vendita,
}

////////////////////////////////////////////////////////////////////////////////////////////////////

