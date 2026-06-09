with xml_bericht as
( select  '<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
    <SOAP-ENV:Body>
        <ns0:MeterReadingExchangeResponseEnvelope xmlns:ns0="urn:nedu:edsn:data:meterreadingexchangeresponse:1:standard">
            <ns0:EDSNBusinessDocumentHeader>
                <ns0:CreationTimestamp>2024-06-05T09:22:37.43+02:00</ns0:CreationTimestamp>
                <ns0:MessageID>602f7d20-2c77-4d8a-b887-4811579368c6</ns0:MessageID>
                <ns0:Destination>
                    <ns0:Receiver>
                        <ns0:Authority>EAN.UCC</ns0:Authority>
                        <ns0:ContactTypeIdentifier>DDQ_O</ns0:ContactTypeIdentifier>
                        <ns0:ReceiverID>8712423033931</ns0:ReceiverID>
                    </ns0:Receiver>
                </ns0:Destination>
                <ns0:Source>
                    <ns0:Authority>EAN.UCC</ns0:Authority>
                    <ns0:ContactTypeIdentifier>EDSN</ns0:ContactTypeIdentifier>
                    <ns0:SenderID>8712423010208</ns0:SenderID>
                </ns0:Source>
            </ns0:EDSNBusinessDocumentHeader>
            <ns0:Portaal_Content>
                <ns0:Portaal_MeteringPoint>
                    <ns0:EANID>871694840032773737</ns0:EANID>
                    <ns0:ProductType>ELK</ns0:ProductType>
                    <ns0:Portaal_EnergyMeter>
                        <ns0:ID>000000000000351334</ns0:ID>
                        <ns0:NrOfRegisters>4</ns0:NrOfRegisters>
                        <ns0:Register>
                            <ns0:MeasureUnit>KWH</ns0:MeasureUnit>
                            <ns0:MeteringDirection>LVR</ns0:MeteringDirection>
                            <ns0:NrOfDigits>6</ns0:NrOfDigits>
                            <ns0:TariffType>L</ns0:TariffType>
                            <ns0:Volume>
                                <ns0:CalorificCorrectedVolume/>
                                <ns0:Volume>697</ns0:Volume>
                                <ns0:Reading>
                                    <ns0:Reading>14253</ns0:Reading>
                                    <ns0:ReadingDate>2024-01-01</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                                <ns0:Reading>
                                    <ns0:Reading>14950</ns0:Reading>
                                    <ns0:ReadingDate>2024-06-04</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                            </ns0:Volume>
                        </ns0:Register>
                        <ns0:Register>
                            <ns0:MeasureUnit>KWH</ns0:MeasureUnit>
                            <ns0:MeteringDirection>LVR</ns0:MeteringDirection>
                            <ns0:NrOfDigits>6</ns0:NrOfDigits>
                            <ns0:TariffType>N</ns0:TariffType>
                            <ns0:Volume>
                                <ns0:CalorificCorrectedVolume/>
                                <ns0:Volume>812</ns0:Volume>
                                <ns0:Reading>
                                    <ns0:Reading>20617</ns0:Reading>
                                    <ns0:ReadingDate>2024-01-01</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                                <ns0:Reading>
                                    <ns0:Reading>21429</ns0:Reading>
                                    <ns0:ReadingDate>2024-06-04</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                            </ns0:Volume>
                        </ns0:Register>
                        <ns0:Register>
                            <ns0:MeasureUnit>KWH</ns0:MeasureUnit>
                            <ns0:MeteringDirection>TLV</ns0:MeteringDirection>
                            <ns0:NrOfDigits>6</ns0:NrOfDigits>
                            <ns0:TariffType>L</ns0:TariffType>
                            <ns0:Volume>
                                <ns0:CalorificCorrectedVolume/>
                                <ns0:Volume>0</ns0:Volume>
                                <ns0:Reading>
                                    <ns0:Reading>0</ns0:Reading>
                                    <ns0:ReadingDate>2024-01-01</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                                <ns0:Reading>
                                    <ns0:Reading>0</ns0:Reading>
                                    <ns0:ReadingDate>2024-06-04</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                            </ns0:Volume>
                        </ns0:Register>
                        <ns0:Register>
                            <ns0:MeasureUnit>KWH</ns0:MeasureUnit>
                            <ns0:MeteringDirection>TLV</ns0:MeteringDirection>
                            <ns0:NrOfDigits>6</ns0:NrOfDigits>
                            <ns0:TariffType>N</ns0:TariffType>
                            <ns0:Volume>
                                <ns0:CalorificCorrectedVolume/>
                                <ns0:Volume>0</ns0:Volume>
                                <ns0:Reading>
                                    <ns0:Reading>0</ns0:Reading>
                                    <ns0:ReadingDate>2024-01-01</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                                <ns0:Reading>
                                    <ns0:Reading>0</ns0:Reading>
                                    <ns0:ReadingDate>2024-06-04</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                            </ns0:Volume>
                        </ns0:Register>
                    </ns0:Portaal_EnergyMeter>
                    <ns0:Portaal_Mutation>
                        <ns0:Consumer>8712423033931</ns0:Consumer>
                        <ns0:ExternalReference>TPM610951243</ns0:ExternalReference>
                        <ns0:Initiator>8716948000003</ns0:Initiator>
                        <ns0:MutationReason>MOVEIN</ns0:MutationReason>
                        <ns0:Dossier>
                            <ns0:ID>2213899457</ns0:ID>
                        </ns0:Dossier>
                    </ns0:Portaal_Mutation>
                </ns0:Portaal_MeteringPoint>
                <ns0:Portaal_MeteringPoint>
                    <ns0:EANID>871685900008556077</ns0:EANID>
                    <ns0:ProductType>ELK</ns0:ProductType>
                    <ns0:Portaal_EnergyMeter>
                        <ns0:ID>E0043007366264119</ns0:ID>
                        <ns0:NrOfRegisters>4</ns0:NrOfRegisters>
                        <ns0:Register>
                            <ns0:MeasureUnit>KWH</ns0:MeasureUnit>
                            <ns0:MeteringDirection>LVR</ns0:MeteringDirection>
                            <ns0:NrOfDigits>6</ns0:NrOfDigits>
                            <ns0:TariffType>L</ns0:TariffType>
                            <ns0:Volume>
                                <ns0:CalorificCorrectedVolume/>
                                <ns0:Volume>1</ns0:Volume>
                                <ns0:Reading>
                                    <ns0:Reading>3296</ns0:Reading>
                                    <ns0:ReadingDate>2024-05-12</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                                <ns0:Reading>
                                    <ns0:Reading>3297</ns0:Reading>
                                    <ns0:ReadingDate>2024-06-04</ns0:ReadingDate>
                                    <ns0:ReadingMethod>003</ns0:ReadingMethod>
                                </ns0:Reading>
                            </ns0:Volume>
                        </ns0:Register>
                        <ns0:Register>
                            <ns0:MeasureUnit>KWH</ns0:MeasureUnit>
                            <ns0:MeteringDirection>LVR</ns0:MeteringDirection>
                            <ns0:NrOfDigits>6</ns0:NrOfDigits>
                            <ns0:TariffType>N</ns0:TariffType>
                            <ns0:Volume>
                                <ns0:CalorificCorrectedVolume/>
                                <ns0:Volume>0</ns0:Volume>
                                <ns0:Reading>
                                    <ns0:Reading>2896</ns0:Reading>
                                    <ns0:ReadingDate>2024-05-12</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                                <ns0:Reading>
                                    <ns0:Reading>2896</ns0:Reading>
                                    <ns0:ReadingDate>2024-06-04</ns0:ReadingDate>
                                    <ns0:ReadingMethod>003</ns0:ReadingMethod>
                                </ns0:Reading>
                            </ns0:Volume>
                        </ns0:Register>
                        <ns0:Register>
                            <ns0:MeasureUnit>KWH</ns0:MeasureUnit>
                            <ns0:MeteringDirection>TLV</ns0:MeteringDirection>
                            <ns0:NrOfDigits>6</ns0:NrOfDigits>
                            <ns0:TariffType>L</ns0:TariffType>
                            <ns0:Volume>
                                <ns0:CalorificCorrectedVolume/>
                                <ns0:Volume>59</ns0:Volume>
                                <ns0:Reading>
                                    <ns0:Reading>178</ns0:Reading>
                                    <ns0:ReadingDate>2024-05-12</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                                <ns0:Reading>
                                    <ns0:Reading>237</ns0:Reading>
                                    <ns0:ReadingDate>2024-06-04</ns0:ReadingDate>
                                    <ns0:ReadingMethod>003</ns0:ReadingMethod>
                                </ns0:Reading>
                            </ns0:Volume>
                        </ns0:Register>
                        <ns0:Register>
                            <ns0:MeasureUnit>KWH</ns0:MeasureUnit>
                            <ns0:MeteringDirection>TLV</ns0:MeteringDirection>
                            <ns0:NrOfDigits>6</ns0:NrOfDigits>
                            <ns0:TariffType>N</ns0:TariffType>
                            <ns0:Volume>
                                <ns0:CalorificCorrectedVolume/>
                                <ns0:Volume>97</ns0:Volume>
                                <ns0:Reading>
                                    <ns0:Reading>379</ns0:Reading>
                                    <ns0:ReadingDate>2024-05-12</ns0:ReadingDate>
                                    <ns0:ReadingMethod>004</ns0:ReadingMethod>
                                </ns0:Reading>
                                <ns0:Reading>
                                    <ns0:Reading>476</ns0:Reading>
                                    <ns0:ReadingDate>2024-06-04</ns0:ReadingDate>
                                    <ns0:ReadingMethod>003</ns0:ReadingMethod>
                                </ns0:Reading>
                            </ns0:Volume>
                        </ns0:Register>
                    </ns0:Portaal_EnergyMeter>
                    <ns0:Portaal_Mutation>
                        <ns0:Consumer>8712423033931</ns0:Consumer>
                        <ns0:ExternalReference>8a4913cd-72b4-42fd-8ed2-3b73f1696535_elec</ns0:ExternalReference>
                        <ns0:Initiator>8716859000017</ns0:Initiator>
                        <ns0:MutationReason>MTRUPD</ns0:MutationReason>
                        <ns0:Dossier>
                            <ns0:ID>2214297313</ns0:ID>
                        </ns0:Dossier>
                    </ns0:Portaal_Mutation>
                </ns0:Portaal_MeteringPoint>
            </ns0:Portaal_Content>
        </ns0:MeterReadingExchangeResponseEnvelope>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>' ber_inhoud
  from    dual
)
, portaal_content as
( select  t.portaal_meteringpoint
        , t.portaal_rejection
  from    xml_bericht xbt
        , xmltable
          ( xmlnamespaces( 'http://schemas.xmlsoap.org/soap/envelope/' as "SOAP-ENV",
                           'urn:nedu:edsn:data:meterreadingexchangeresponse:1:standard' as "ns0" ),
            'SOAP-ENV:Envelope/SOAP-ENV:Body/ns0:*/ns0:Portaal_Content'
            passing xmltype(xbt.ber_inhoud)
            columns portaal_meteringpoint  xmltype  path 'ns0:Portaal_MeteringPoint'
                  , portaal_rejection      xmltype  path 'ns0:Portaal_Rejection'
          ) t
)
, meteringpoint as
( select  t.*
  from    portaal_content pct
        , xmltable
          ( xmlnamespaces( 'urn:nedu:edsn:data:meterreadingexchangeresponse:1:standard' as "ns0" ),
            'ns0:Portaal_MeteringPoint'
            passing pct.portaal_meteringpoint
            columns EANID                       varchar2(256)  path 'ns0:EANID'
                  , ProductType                 varchar2(256)  path 'ns0:ProductType'
                  , Datum_vanaf                 varchar2(256)  path 'ns0:ValidFromDate'
                  , Datum_tot                   varchar2(256)  path 'ns0:ValidToDate'
                  , GridOperator_Company        varchar2(256)  path 'ns0:GridOperator_Company/ns0:ID'
                  , BalanceSupplier_Company     varchar2(256)  path 'ns0:MPCommercialCharacteristics/ns0:BalanceSupplier_Company/ns0:ID'
                  , OldBalanceSupplier_Company  varchar2(256)  path 'ns0:MPCommercialCharacteristics/ns0:OldBalanceSupplier_Company/ns0:ID'
                  , MutationDate                varchar2(256)  path 'ns0:Portaal_Mutation/ns0:MutationDate'
                  , MutationReason              varchar2(256)  path 'ns0:Portaal_Mutation/ns0:MutationReason'
                  , Dossier                     varchar2(256)  path 'ns0:Portaal_Mutation/ns0:Dossier/ns0:ID'
                  , Meternummer                 varchar2(256)  path 'ns0:Portaal_EnergyMeter/ns0:ID'
          ) t
)
, rejection as
( select  t.*
  from    portaal_content pct
        , xmltable
          ( xmlnamespaces( 'urn:nedu:edsn:data:meterreadingexchangeresponse:1:standard' as "ns0"),
            'ns0:Portaal_Rejection'
            passing pct.portaal_rejection
            columns RejectionCode            varchar2(256)  path 'ns0:Rejection/ns0:RejectionCode'
                  , RejectionText            varchar2(256)  path 'ns0:Rejection/ns0:RejectionText'
                  , EANID                    varchar2(256)  path 'ns0:Portaal_MeteringPoint/ns0:EANID'
                  , GridOperator_Company     varchar2(256)  path 'ns0:Portaal_MeteringPoint/ns0:GridOperator_Company/ns0:ID'
                  , BalanceSupplier_Company  varchar2(256)  path 'ns0:Portaal_MeteringPoint/ns0:MPCommercialCharacteristics/ns0:BalanceSupplier_Company/ns0:ID'
                  , MutationDate             varchar2(256)  path 'ns0:Portaal_MeteringPoint/ns0:Portaal_Mutation/ns0:MutationDate'
                  , MutationReason           varchar2(256)  path 'ns0:Portaal_MeteringPoint/ns0:Portaal_Mutation/ns0:MutationReason'
                  , Dossier                  varchar2(256)  path 'ns0:Portaal_MeteringPoint/ns0:Portaal_Mutation/ns0:Dossier/ns0:ID'
          ) t
)
select  eanid
      , producttype
      , datum_vanaf
      , datum_tot
      , gridoperator_company
      , balancesupplier_company
      , oldbalancesupplier_company
      , mutationdate
      , mutationreason
      , dossier
      , meternummer
      , null as rejectioncode
      , null as rejectiontext
from meteringpoint
union all
select  eanid
      , null
      , null
      , null
      , gridoperator_company
      , balancesupplier_company
      , null
      , mutationdate
      , mutationreason
      , dossier
      , null
      , rejectioncode
      , rejectiontext
from rejection
/

-- Query on BER_BERICHT table
with xml_bericht as
( select  bei.bei_inhoud ber_inhoud
  from    dgs.ber_bericht ber
    join   dgs.bei_bericht_inhoud bei on bei.bei_ber_uuid = ber.ber_uuid
  where   ber.ber_uuid = '49fe942e-ed63-4783-96bb-45731aa487a1' --_ber_uuid
  fetch first 10000 rows only
)
, portaal_content as
(
select  t.portaal_meteringpoint
      , t.portaal_rejection
from    xml_bericht xbt
      , xmltable
        ( xmlnamespaces( 'http://schemas.xmlsoap.org/soap/envelope/' as "SOAP-ENV",
                         'urn:nedu:edsn:data:meterreadingexchangeresponse:1:standard' as "ns0" ),
          'SOAP-ENV:Envelope/SOAP-ENV:Body/ns0:*/ns0:Portaal_Content'
          passing xbt.ber_inhoud
          columns portaal_meteringpoint  xmltype  path 'ns0:Portaal_MeteringPoint'
                , portaal_rejection      xmltype  path 'ns0:Portaal_Rejection'
        ) t
)
, meteringpoint as
( select  t.*
  from    portaal_content pct
        , xmltable
          ( xmlnamespaces( 'urn:nedu:edsn:data:meterreadingexchangeresponse:1:standard' as "ns0" ),
            'ns0:Portaal_MeteringPoint'
            passing pct.portaal_meteringpoint
            columns EANID                       varchar2(256)  path 'ns0:EANID'
                  , ProductType                 varchar2(256)  path 'ns0:ProductType'
                  , GridOperator_Company        varchar2(256)  path 'ns0:GridOperator_Company/ns0:ID'
                  , BalanceSupplier_Company     varchar2(256)  path 'ns0:MPCommercialCharacteristics/ns0:BalanceSupplier_Company/ns0:ID'
                  , OldBalanceSupplier_Company  varchar2(256)  path 'ns0:MPCommercialCharacteristics/ns0:OldBalanceSupplier_Company/ns0:ID'
                  , MutationDate                varchar2(256)  path 'ns0:Portaal_Mutation/ns0:MutationDate'
                  , MutationReason              varchar2(256)  path 'ns0:Portaal_Mutation/ns0:MutationReason'
                  , Dossier                     varchar2(256)  path 'ns0:Portaal_Mutation/ns0:Dossier/ns0:ID'
          ) t
)
select * from meteringpoint
/