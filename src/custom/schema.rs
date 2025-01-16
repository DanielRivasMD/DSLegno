////////////////////////////////////////////////////////////////////////////////////////////////////

diesel::table! {
    tabella_acquisti {
        id -> Integer,
        operazione -> Integer,
        progetto_di_taglio -> Text,
        descrizione -> Text,
        quantita -> Text,
        prezzo_unitario -> Text,
        prezzo_totale -> Text,
        aliquota_iva -> Text,
        numero_fattura -> Text,
        giorno_data -> Text,
        importo_totale -> Text,
        prestatore_denominazione -> Text,
        prestatore_indirizzo -> Text,
        committente_denominazione -> Text,
        committente_indirizzo -> Text,
        imponibile_importo -> Text,
        imposta -> Text,
        esigibilita_iva -> Char,
        data_riferimento_termini -> Text,
        data_scadenza_pagamento -> Text,
        importo_pagamento -> Text,
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

diesel::table! {
    tabella_vendite {
        id -> Integer,
        operazione -> Integer,
        pefc -> Text,
        descrizione -> Text,
        quantita -> Text,
        prezzo_unitario -> Text,
        prezzo_totale -> Text,
        aliquota_iva -> Text,
        numero_fattura -> Text,
        giorno_data -> Text,
        importo_totale -> Text,
        prestatore_denominazione -> Text,
        prestatore_indirizzo -> Text,
        committente_denominazione -> Text,
        committente_indirizzo -> Text,
        imponibile_importo -> Text,
        imposta -> Text,
        esigibilita_iva -> Char,
        data_riferimento_termini -> Text,
        data_scadenza_pagamento -> Text,
        importo_pagamento -> Text,
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
