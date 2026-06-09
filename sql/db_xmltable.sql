-- Alter session necessary for correct interpretation of date/timestamp values in xml (iso-format)
alter session set NLS_DATE_FORMAT= 'YYYY-MM-DD"T"HH24:MI:SS';
alter session set NLS_TIMESTAMP_FORMAT= 'YYYY-MM-DD"T"HH24:MI:SS.FF3';
alter session set NLS_TIMESTAMP_TZ_FORMAT= 'YYYY-MM-DD"T"HH24:MI:SS.FF3 TZH:TZM';
-- Alter session nls_numeric_characters necessary for timestamp with time zone only
alter session set nls_numeric_characters = '.,';
-- original
--alter session set nls_numeric_characters = ',.';



with xmldata as
( select xmltype('<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
  <SOAP-ENV:Body>
    <ns0:ResponseEnvelope xmlns:ns0="urn:nedu:example:data:response:1:standard">
      <ns0:DocumentHeader>
        <ns0:CreationDate>2024-12-20T15:02:22</ns0:CreationDate>
        <ns0:CreationTimestamp>2024-12-20T15:02:22.488</ns0:CreationTimestamp>
        <ns0:CreationTimestampTZ>2024-12-20T15:02:22.488+02:00</ns0:CreationTimestampTZ>
        <ns0:MessageID>a69a7e61-ab1c-471d-837a-e0fe8de375b1</ns0:MessageID>
        <ns0:Destination>
          <ns0:Receiver>
            <ns0:ReceiverID>123456789</ns0:ReceiverID>
          </ns0:Receiver>
        </ns0:Destination>
        <ns0:Source>
          <ns0:SenderID>987654321</ns0:SenderID>
        </ns0:Source>
      </ns0:DocumentHeader>
      <ns0:Content>
        <ns0:Segment>
          <ns0:EANID>11124230000012264</ns0:EANID>
          <ns0:ProductType>ELK</ns0:ProductType>
          <ns0:Company>
            <ns0:ID>26458156478</ns0:ID>
          </ns0:Company>
          <ns0:MPCommercialCharacteristics>
            <ns0:BalanceSupplier_Company>
              <ns0:ID>4512354658</ns0:ID>
            </ns0:BalanceSupplier_Company>
            <ns0:OldBalanceSupplier_Company>
              <ns0:ID>92546752112</ns0:ID>
            </ns0:OldBalanceSupplier_Company>
          </ns0:MPCommercialCharacteristics>
          <ns0:Mutation>
            <ns0:MutationDate>2025-01-01</ns0:MutationDate>
            <ns0:MutationReason>TEST</ns0:MutationReason>
            <ns0:Dossier>
              <ns0:ID>113624685</ns0:ID>
            </ns0:Dossier>
          </ns0:Mutation>
        </ns0:Segment>
        <ns0:Segment>
          <ns0:EANID>11124230000012265</ns0:EANID>
          <ns0:ProductType>ELK</ns0:ProductType>
          <ns0:Company>
            <ns0:ID>26458156479</ns0:ID>
          </ns0:Company>
          <ns0:MPCommercialCharacteristics>
            <ns0:BalanceSupplier_Company>
              <ns0:ID>4512354658</ns0:ID>
            </ns0:BalanceSupplier_Company>
            <ns0:OldBalanceSupplier_Company>
              <ns0:ID>92546752112</ns0:ID>
            </ns0:OldBalanceSupplier_Company>
          </ns0:MPCommercialCharacteristics>
          <ns0:Mutation>
            <ns0:MutationDate>2025-01-01</ns0:MutationDate>
            <ns0:MutationReason>TEST</ns0:MutationReason>
            <ns0:Dossier>
              <ns0:ID>113624685</ns0:ID>
            </ns0:Dossier>
          </ns0:Mutation>
        </ns0:Segment>
      </ns0:Content>
    </ns0:ResponseEnvelope>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>') as doc
  from dual
)
select x.*,
       doc.*,
       data.*
from   xmldata x
  -- cross apply xmltable() equals to outer join
  cross apply xmltable( xmlnamespaces( 'http://schemas.xmlsoap.org/soap/envelope/' as "SOAP-ENV",
                                       'urn:nedu:example:data:response:1:standard' as "ns0"),
                        'SOAP-ENV:Envelope/SOAP-ENV:Body/ns0:ResponseEnvelope'
                        passing x.doc
                        columns
                          envelope      xmltype                   path  '.',
                          header        xmltype                   path  'ns0:DocumentHeader',
                          datetime      varchar2(20)              path  'ns0:DocumentHeader/ns0:CreationDate',
                          timestamp     timestamp                 path  'ns0:DocumentHeader/ns0:CreationTimestamp',
                          timestamp_tz  timestamp with time zone  path  'ns0:DocumentHeader/ns0:CreationTimestampTZ',
                          content       xmltype                   path  'ns0:Content',
                          chunks        xmltype                   path  'ns0:Content/ns0:Segment'
                      ) doc
  -- outer apply xmltable() equals to outer join
  cross apply xmltable( xmlnamespaces( 'urn:nedu:example:data:response:1:standard' as "ns0"),
                        'ns0:Segment'
                        passing doc.chunks
                        columns
                          chunk         xmltype      path  '.',
                          ean           varchar2(18) path  'ns0:EANID',
                          product_type  varchar2(4)  path  'ns0:ProductType',
                          company_id    number       path  'ns0:Company/ns0:ID'
                      ) data
/

