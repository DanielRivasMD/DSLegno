// @generated automatically by Diesel CLI.

diesel::table! {
    tabella_acquisti (id) {
        id -> Nullable<Integer>,
        lotto -> Nullable<Integer>,
        progetto_di_taglio -> Nullable<Text>,
        descrizione -> Nullable<Text>,
        quantita -> Nullable<Float>,
        prezzo_unitario -> Nullable<Float>,
        prezzo_totale -> Nullable<Float>,
        aliquota_iva -> Nullable<Float>,
        numero_fattura -> Nullable<Text>,
        giorno_data -> Nullable<Text>,
        importo_totale -> Nullable<Float>,
        prestatore_denominazione -> Nullable<Text>,
        prestatore_indirizzo -> Nullable<Text>,
        committente_denominazione -> Nullable<Text>,
        committente_indirizzo -> Nullable<Text>,
        imponibile_importo -> Nullable<Float>,
        imposta -> Nullable<Float>,
        esigibilita_iva -> Nullable<Text>,
        data_riferimento_termini -> Nullable<Text>,
        data_scadenza_pagamento -> Nullable<Text>,
        importo_pagamento -> Nullable<Float>,
    }
}

diesel::table! {
    tabella_annuale (numero) {
        numero -> Nullable<Integer>,
        anno -> Nullable<Text>,
        somma_mc_acquisto -> Nullable<Float>,
        somma_eur_acquisto -> Nullable<Float>,
        somma_eur_acquisto_no_iva -> Nullable<Float>,
        somma_mc_vendita -> Nullable<Float>,
        somma_mc_vendita_pefc -> Nullable<Float>,
        somma_eur_vendita -> Nullable<Float>,
        somma_eur_vendita_no_iva -> Nullable<Float>,
    }
}

diesel::table! {
    tabella_mensile (numero) {
        numero -> Nullable<Integer>,
        mese_anno -> Nullable<Text>,
        somma_mc_acquisto -> Nullable<Float>,
        somma_eur_acquisto -> Nullable<Float>,
        somma_eur_acquisto_no_iva -> Nullable<Float>,
        somma_mc_vendita -> Nullable<Float>,
        somma_mc_vendita_pefc -> Nullable<Float>,
        somma_eur_vendita -> Nullable<Float>,
        somma_eur_vendita_no_iva -> Nullable<Float>,
    }
}

diesel::table! {
    tabella_principale (id) {
        id -> Nullable<Integer>,
        lotto -> Nullable<Integer>,
        descrizione -> Nullable<Text>,
        quantita -> Nullable<Float>,
        prezzo_unitario -> Nullable<Float>,
        prezzo_totale -> Nullable<Float>,
        aliquota_iva -> Nullable<Float>,
        numero_fattura -> Nullable<Text>,
        giorno_data -> Nullable<Text>,
        importo_totale -> Nullable<Float>,
        prestatore_denominazione -> Nullable<Text>,
        prestatore_indirizzo -> Nullable<Text>,
        committente_denominazione -> Nullable<Text>,
        committente_indirizzo -> Nullable<Text>,
        imponibile_importo -> Nullable<Float>,
        imposta -> Nullable<Float>,
        esigibilita_iva -> Nullable<Text>,
        data_riferimento_termini -> Nullable<Text>,
        data_scadenza_pagamento -> Nullable<Text>,
        importo_pagamento -> Nullable<Float>,
        typo -> Nullable<Text>,
    }
}

diesel::table! {
    tabella_sommario (numero) {
        numero -> Nullable<Integer>,
        giorno_data -> Nullable<Text>,
        acquisto -> Nullable<Text>,
        vendita -> Nullable<Text>,
        somma_mc_acquisto -> Nullable<Float>,
        somma_eur_acquisto -> Nullable<Float>,
        somma_eur_acquisto_no_iva -> Nullable<Float>,
        somma_mc_vendita -> Nullable<Float>,
        somma_mc_vendita_pefc -> Nullable<Float>,
        somma_eur_vendita -> Nullable<Float>,
        somma_eur_vendita_no_iva -> Nullable<Float>,
        pagamento -> Nullable<Text>,
    }
}

diesel::table! {
    tabella_vendite (id) {
        id -> Nullable<Integer>,
        lotto -> Nullable<Integer>,
        pefc -> Nullable<Text>,
        descrizione -> Nullable<Text>,
        quantita -> Nullable<Float>,
        prezzo_unitario -> Nullable<Float>,
        prezzo_totale -> Nullable<Float>,
        aliquota_iva -> Nullable<Float>,
        numero_fattura -> Nullable<Text>,
        giorno_data -> Nullable<Text>,
        importo_totale -> Nullable<Float>,
        prestatore_denominazione -> Nullable<Text>,
        prestatore_indirizzo -> Nullable<Text>,
        committente_denominazione -> Nullable<Text>,
        committente_indirizzo -> Nullable<Text>,
        imponibile_importo -> Nullable<Float>,
        imposta -> Nullable<Float>,
        esigibilita_iva -> Nullable<Text>,
        data_riferimento_termini -> Nullable<Text>,
        data_scadenza_pagamento -> Nullable<Text>,
        importo_pagamento -> Nullable<Float>,
    }
}

diesel::allow_tables_to_appear_in_same_query!(
    tabella_acquisti,
    tabella_annuale,
    tabella_mensile,
    tabella_principale,
    tabella_sommario,
    tabella_vendite,
);
