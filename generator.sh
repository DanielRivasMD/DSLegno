#!/bin/bash
####################################################################################################
# This script generates 100 XML files with:
# - A fixed <Descrizione> ("RANDOM SAMPLE")
# - Coordinated incremental numbers for <Numero> and <NumeroLinea> (from 001 to 100)
# - A random date, with the year evenly distributed among 2020 through 2024
# - <ProgressivoInvio> calculated as <Numero> + 1000 (ranging from 1001 to 1100)
# The output file names are prefixed based on the command-line argument: either "acquista" or "vendita".
####################################################################################################

# Check for exactly one argument and ensure it's either "acquista" or "vendita".
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 [acquista|vendita]"
  return 1
fi

type="$1"
if [ "$type" != "acquista" ] && [ "$type" != "vendita" ]; then
  echo "Invalid type provided. Please use 'acquista' or 'vendita'."
  return 1
fi

# Create output directory if it doesn't exist
mkdir -p sample

# Loop to generate 100 files.
for i in $(seq -w 1 100); do
    # Determine the year based on the file number.
    # 100 files evenly distributed over 5 years: 20 files per year.
    # For i from 1 to 20 -> year=2020, 21 to 40 -> year=2021, etc.
    year=$(( (10#$i - 1) / 20 + 2020 ))
    
    # Randomize month (1 to 12) and day (1 to 28)
    month=$(( RANDOM % 12 + 1 ))
    day=$(( RANDOM % 28 + 1 ))
    data=$(printf "%04d-%02d-%02d" "$year" "$month" "$day")
    
    # Fixed <Descrizione>
    descrizione="RANDOM SAMPLE"
    
    # <Numero> and <NumeroLinea> will be the same (from 001 to 100)
    # Also, compute <ProgressivoInvio> as current number + 1000.
    progressivo=$((10#$i + 1000))
    
    # Output file name based on the provided type.
    outfile="sample/${type}_${i}.xml"
    
    cat <<EOF > "$outfile"
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
      <ProgressivoInvio>${progressivo}</ProgressivoInvio>
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
