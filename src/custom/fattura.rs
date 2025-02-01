////////////////////////////////////////////////////////////////////////////////////////////////////

// standard libraries
use anyhow::Result as anyResult;
use diesel::prelude::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

// crate utilities
use crate::custom::schema::*;

////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Debug, Default, Insertable, new)]
#[diesel(table_name = tabella_acquisti)]
pub struct FatturaToUploadAcquisti {
    #[new(default)]
    pub descrizione: String,

    #[new(default)]
    pub quantita: String,

    #[new(default)]
    pub prezzo_unitario: String,

    #[new(default)]
    pub prezzo_totale: String,

    #[new(default)]
    pub aliquota_iva: String,

    #[new(default)]
    pub numero_fattura: String,

    #[new(default)]
    pub giorno_data: String,

    #[new(default)]
    pub importo_totale: String,

    #[new(default)]
    pub prestatore_denominazione: String,

    #[new(default)]
    pub prestatore_indirizzo: String,

    #[new(default)]
    pub committente_denominazione: String,

    #[new(default)]
    pub committente_indirizzo: String,

    #[new(default)]
    pub imponibile_importo: String,

    #[new(default)]
    pub imposta: String,

    #[new(default)]
    pub esigibilita_iva: String,

    #[new(default)]
    pub data_riferimento_termini: String,

    #[new(default)]
    pub data_scadenza_pagamento: String,

    #[new(default)]
    pub importo_pagamento: String,
}

#[derive(Debug, Default, Insertable, new)]
#[diesel(table_name = tabella_vendite)]
pub struct FatturaToUploadVendite {
    #[new(default)]
    pub descrizione: String,

    #[new(default)]
    pub quantita: String,

    #[new(default)]
    pub prezzo_unitario: String,

    #[new(default)]
    pub prezzo_totale: String,

    #[new(default)]
    pub aliquota_iva: String,

    #[new(default)]
    pub numero_fattura: String,

    #[new(default)]
    pub giorno_data: String,

    #[new(default)]
    pub importo_totale: String,

    #[new(default)]
    pub prestatore_denominazione: String,

    #[new(default)]
    pub prestatore_indirizzo: String,

    #[new(default)]
    pub committente_denominazione: String,

    #[new(default)]
    pub committente_indirizzo: String,

    #[new(default)]
    pub imponibile_importo: String,

    #[new(default)]
    pub imposta: String,

    #[new(default)]
    pub esigibilita_iva: String,

    #[new(default)]
    pub data_riferimento_termini: String,

    #[new(default)]
    pub data_scadenza_pagamento: String,

    #[new(default)]
    pub importo_pagamento: String,
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Debug, Default, new)]
pub struct FatturaToCapture {
    #[new(default)]
    pub dettaglio_linee: Vec<DettaglioLinee>,

    #[new(default)]
    pub numero_fattura: String,

    #[new(default)]
    pub giorno_data: String,

    #[new(default)]
    pub importo_totale: String,

    #[new(default)]
    pub prestatore_denominazione: String,

    #[new(default)]
    pub prestatore_indirizzo: String,

    #[new(default)]
    pub committente_denominazione: String,

    #[new(default)]
    pub committente_indirizzo: String,

    #[new(default)]
    pub imponibile_importo: String,

    #[new(default)]
    pub imposta: String,

    #[new(default)]
    pub esigibilita_iva: String,

    #[new(default)]
    pub data_riferimento_termini: String,

    #[new(default)]
    pub data_scadenza_pagamento: String,

    #[new(default)]
    pub importo_pagamento: String,
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// trait for common behavior
pub trait FatturaUpload<T> {
    fn from_details(details: &DettaglioLinee, fattura: &FatturaToCapture) -> T;
}

// implement the trait for acquisti
impl FatturaUpload<FatturaToUploadAcquisti> for FatturaToUploadAcquisti {
    fn from_details(details: &DettaglioLinee, fattura: &FatturaToCapture) -> Self {
        Self {
            descrizione: details.descrizione.clone(),
            quantita: details.quantita.clone(),
            prezzo_unitario: details.prezzo_unitario.clone(),
            prezzo_totale: details.prezzo_totale.clone(),
            aliquota_iva: details.aliquota_iva.clone(),
            numero_fattura: fattura.numero_fattura.clone(),
            giorno_data: fattura.giorno_data.clone(),
            importo_totale: fattura.importo_totale.clone(),
            prestatore_denominazione: fattura.prestatore_denominazione.clone(),
            prestatore_indirizzo: fattura.prestatore_indirizzo.clone(),
            committente_denominazione: fattura.committente_denominazione.clone(),
            committente_indirizzo: fattura.committente_indirizzo.clone(),
            imponibile_importo: fattura.imponibile_importo.clone(),
            imposta: fattura.imposta.clone(),
            esigibilita_iva: fattura.esigibilita_iva.clone(),
            data_riferimento_termini: fattura.data_riferimento_termini.clone(),
            data_scadenza_pagamento: fattura.data_scadenza_pagamento.clone(),
            importo_pagamento: fattura.importo_pagamento.clone(),
        }
    }
}

// implement the trait for vendite
impl FatturaUpload<FatturaToUploadVendite> for FatturaToUploadVendite {
    fn from_details(details: &DettaglioLinee, fattura: &FatturaToCapture) -> Self {
        Self {
            descrizione: details.descrizione.clone(),
            quantita: details.quantita.clone(),
            prezzo_unitario: details.prezzo_unitario.clone(),
            prezzo_totale: details.prezzo_totale.clone(),
            aliquota_iva: details.aliquota_iva.clone(),
            numero_fattura: fattura.numero_fattura.clone(),
            giorno_data: fattura.giorno_data.clone(),
            importo_totale: fattura.importo_totale.clone(),
            prestatore_denominazione: fattura.prestatore_denominazione.clone(),
            prestatore_indirizzo: fattura.prestatore_indirizzo.clone(),
            committente_denominazione: fattura.committente_denominazione.clone(),
            committente_indirizzo: fattura.committente_indirizzo.clone(),
            imponibile_importo: fattura.imponibile_importo.clone(),
            imposta: fattura.imposta.clone(),
            esigibilita_iva: fattura.esigibilita_iva.clone(),
            data_riferimento_termini: fattura.data_riferimento_termini.clone(),
            data_scadenza_pagamento: fattura.data_scadenza_pagamento.clone(),
            importo_pagamento: fattura.importo_pagamento.clone(),
        }
    }
}

// generalized method FatturaToCapture
impl FatturaToCapture {
    pub fn upload_formatter<T: FatturaUpload<T>>(&self) -> anyResult<Vec<T>> {
        let fatture: Vec<T> = self
            .dettaglio_linee
            .iter()
            .map(|details| T::from_details(details, self))
            .collect();
        Ok(fatture)
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#[derive(Debug, new)]
pub struct DettaglioLinee {
    #[new(default)]
    pub descrizione: String,

    #[new(default)]
    pub quantita: String,

    #[new(default)]
    pub prezzo_unitario: String,

    #[new(default)]
    pub prezzo_totale: String,

    #[new(default)]
    pub aliquota_iva: String,
}

////////////////////////////////////////////////////////////////////////////////////////////////////

impl DettaglioLinee {
    pub fn check(&self) -> anyResult<bool> {
        Ok(!(self.descrizione.is_empty()
            | self.quantita.is_empty()
            | self.prezzo_unitario.is_empty()
            | self.prezzo_totale.is_empty()
            | self.aliquota_iva.is_empty()))
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
