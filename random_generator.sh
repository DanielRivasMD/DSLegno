#!/bin/bash
####################################################################################################

# Generate 100 XML files with fixed descrizione,
# coordinated incremental numbers for <Numero> and <NumeroLinea>,
# and a random date between 2020 and 2025 using $RANDOM.

####################################################################################################

for i in $(seq -w 1 100); do
    # Random date generation using $RANDOM:
    # years from 2020 to 2025 (6 possible years: 0-5 +2020).
    year=$(( RANDOM % 6 + 2020 ))
    # months from 1 to 12 (RANDOM % 12 gives 0-11, then +1)
    month=$(( RANDOM % 12 + 1 ))
    # days from 1 to 28 (to keep it simple)
    day=$(( RANDOM % 28 + 1 ))
    data=$(printf "%04d-%02d-%02d" "$year" "$month" "$day")
    
    # Fixed descrizione as in the sample.
    descrizione="RANDOM SAMPLE"
    
    # Create the XML file using a heredoc.
    cat <<EOF > sample/acquista_${i}.xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<FatturaElettronica xmlns="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2"
                     xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     versione="FPR12">
  <FatturaElettronicaHeader xmlns="">
    <DatiTrasmissione>
      <IdTrasmittente>
        <IdPaese>IT</IdPaese>
        <IdCodice>00276510229</IdCodice>
      </IdTrasmittente>
      <ProgressivoInvio>148</ProgressivoInvio>
      <FormatoTrasmissione>FPR12</FormatoTrasmissione>
      <CodiceDestinatario>0000000</CodiceDestinatario>
      <PECDestinatario>dallasantasnc@pec.trovarti.it</PECDestinatario>
    </DatiTrasmissione>
    <CedentePrestatore>
      <DatiAnagrafici>
        <IdFiscaleIVA>
          <IdPaese>IT</IdPaese>
          <IdCodice>00276510229</IdCodice>
        </IdFiscaleIVA>
        <CodiceFiscale>00276510229</CodiceFiscale>
        <Anagrafica>
          <Denominazione>COMUNE DI IMER</Denominazione>
        </Anagrafica>
        <RegimeFiscale>RF01</RegimeFiscale>
      </DatiAnagrafici>
      <Sede>
        <Indirizzo>Piazzale del Piazza, 1</Indirizzo>
        <CAP>38050</CAP>
        <Comune>IMER</Comune>
        <Provincia>TN</Provincia>
        <Nazione>IT</Nazione>
      </Sede>
    </CedentePrestatore>
    <CessionarioCommittente>
      <DatiAnagrafici>
        <IdFiscaleIVA>
          <IdPaese>IT</IdPaese>
          <IdCodice>01572210225</IdCodice>
        </IdFiscaleIVA>
        <Anagrafica>
          <Denominazione>DALLA SANTA LEGNO SRL</Denominazione>
        </Anagrafica>
      </DatiAnagrafici>
      <Sede>
        <Indirizzo>VIA S.S. MICHELI</Indirizzo>
        <NumeroCivico>5</NumeroCivico>
        <CAP>38050</CAP>
        <Comune>IMER</Comune>
        <Provincia>TN</Provincia>
        <Nazione>IT</Nazione>
      </Sede>
    </CessionarioCommittente>
  </FatturaElettronicaHeader>
  <FatturaElettronicaBody xmlns="">
    <DatiGenerali>
      <DatiGeneraliDocumento>
        <TipoDocumento>TD01</TipoDocumento>
        <Divisa>EUR</Divisa>
        <Data>${data}</Data>
        <Numero>${i}</Numero>
        <ImportoTotaleDocumento>100.00</ImportoTotaleDocumento>
        <Causale>ACCONTO LEGNAME VEDERNA 2023 BOSTRICO</Causale>
      </DatiGeneraliDocumento>
    </DatiGenerali>
    <DatiBeniServizi>
      <DettaglioLinee>
        <NumeroLinea>${i}</NumeroLinea>
        <Descrizione>${descrizione}</Descrizione>
        <Quantita>100.000000</Quantita>
        <PrezzoUnitario>10.000000</PrezzoUnitario>
        <PrezzoTotale>100.00</PrezzoTotale>
        <AliquotaIVA>1.00</AliquotaIVA>
      </DettaglioLinee>
      <DatiRiepilogo>
        <AliquotaIVA>1.00</AliquotaIVA>
        <ImponibileImporto>100.00</ImponibileImporto>
        <Imposta>10.00</Imposta>
        <EsigibilitaIVA>I</EsigibilitaIVA>
        <RiferimentoNormativo>IVA 22%</RiferimentoNormativo>
      </DatiRiepilogo>
    </DatiBeniServizi>
    <DatiPagamento>
      <CondizioniPagamento>TP02</CondizioniPagamento>
      <DettaglioPagamento>
        <ModalitaPagamento>MP23</ModalitaPagamento>
        <ImportoPagamento>100.00</ImportoPagamento>
      </DettaglioPagamento>
    </DatiPagamento>
  </FatturaElettronicaBody>
</FatturaElettronica>
EOF

done

####################################################################################################
