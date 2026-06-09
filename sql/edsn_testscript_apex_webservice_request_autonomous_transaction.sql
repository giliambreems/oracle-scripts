set serveroutput on

declare
  l_tmp binary_integer;
  --
  cl_bericht clob;
  N_BER_ID_VERZONDEN number;
  X_RESPONSE xmltype;
  --
  -- genereer uuid om te gebruiken in xml bericht
  function uuid_genereren return varchar2
  is
    s_guid varchar2(100) ;
    s_uuid varchar2(100); 
  begin
    -- selecteer standaard guid:
    select sys_guid() into s_guid from dual ;
    -- opmaken: 
    s_uuid := substr( s_guid,  0,  8 ) || '-' || 
              substr( s_guid,  9,  4 ) || '-' ||
              substr( s_guid, 13,  4 ) || '-' ||
              substr( s_guid, 17,  4 ) || '-' ||
              substr( s_guid, 21, 12 );
    return s_uuid ;
  end uuid_genereren;
  --
  procedure bericht_maken
    ( pi_type_bericht     in       varchar2
    , pi_ean              in       varchar2
    , pi_kvk_nummer       in       varchar2
    , pi_naam             in       varchar2
    , pi_ean_eigen_lv     in       varchar2
    , pi_ean_pv           in       varchar2
    , pi_gridoperator_id  in       varchar2
    , pi_mutatie_datum    in       date
    , po_bericht              out  clob
    , po_ber_id               out  number
    )
  is
    cl_bericht       clob;
    s_uuid           varchar2(64);
    s_timestamp      varchar2(32);
    n_ber_id         fp_data.ber_bericht.ber_id%type;
    e_template_leeg  exception;
  begin
    cl_bericht := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:nedu:edsn:data:moveinrequest:1:standard">
  <soapenv:Header/>
  <soapenv:Body>
    <urn:MoveInRequestEnvelope>
      <urn:EDSNBusinessDocumentHeader>
        <urn:CreationTimestamp>#TIMESTAMP#</urn:CreationTimestamp>
        <urn:MessageID>#UUID#</urn:MessageID>
        <urn:Destination>
          <urn:Receiver>
            <urn:ContactTypeIdentifier>EDSN</urn:ContactTypeIdentifier>
            <urn:ReceiverID>8712423010208</urn:ReceiverID>
          </urn:Receiver>
        </urn:Destination>
        <urn:Source>
          <urn:ContactTypeIdentifier>DDQ_O</urn:ContactTypeIdentifier>
          <urn:SenderID>#EAN_EIGEN_LV#</urn:SenderID>
        </urn:Source>
      </urn:EDSNBusinessDocumentHeader>
      <urn:Portaal_Content>
        <urn:Portaal_MeteringPoint>
          <urn:EANID>#EANID#</urn:EANID>
          <urn:GridOperator_Company>
            <urn:ID>#GRIDOPERATOR_ID#</urn:ID>
          </urn:GridOperator_Company>
          <urn:MPCommercialCharacteristics>
            <urn:ChamberOfCommerceID>#KVKNUMMER#</urn:ChamberOfCommerceID>
            <urn:GridContractParty>
              <urn:Surname>#CONTRACTANT#</urn:Surname>
            </urn:GridContractParty>
            <urn:BalanceSupplier_Company>
              <urn:ID>#EAN_EIGEN_LV#</urn:ID>
            </urn:BalanceSupplier_Company>
            <urn:BalanceResponsibleParty_Company>
              <urn:ID>#PV_EAN#</urn:ID>
            </urn:BalanceResponsibleParty_Company>
          </urn:MPCommercialCharacteristics>
          <urn:Portaal_Mutation>
            <urn:MutationDate>#MUTATIONDATE#</urn:MutationDate>
          </urn:Portaal_Mutation>
        </urn:Portaal_MeteringPoint>
      </urn:Portaal_Content>
    </urn:MoveInRequestEnvelope>
  </soapenv:Body>
 </soapenv:Envelope>';
    --
    if cl_bericht is null
    then
      raise e_template_leeg;
    end if;
    --
    s_uuid      := lower( uuid_genereren ); -- getUUID );
    s_timestamp := fg_service.pkg_utl_date.xml_timestamp_genereren;
    --
    cl_bericht := replace( cl_bericht, '#EANID#'          , pi_ean );
    cl_bericht := replace( cl_bericht, '#KVKNUMMER#'      , pi_kvk_nummer );
    cl_bericht := replace( cl_bericht, '#CONTRACTANT#'    , pi_naam );
    cl_bericht := replace( cl_bericht, '#EAN_EIGEN_LV#'   , pi_ean_eigen_lv );
    cl_bericht := replace( cl_bericht, '#PV_EAN#'         , pi_ean_pv );
    cl_bericht := replace( cl_bericht, '#MUTATIONDATE#'   , pi_mutatie_datum );
    cl_bericht := replace( cl_bericht, '#TIMESTAMP#'      , s_timestamp );
    cl_bericht := replace( cl_bericht, '#UUID#'           , s_uuid );
    cl_bericht := replace( cl_bericht, '#GRIDOPERATOR_ID#', pi_gridoperator_id );
    --
    -- bericht opslaan:
    fp_data.pkg_tapi_ber.ins
      ( po_ber_id           => n_ber_id
      , pi_ber_uuid         => s_uuid
      , pi_ber_type         => upper(pi_type_bericht)
      , pi_ber_status       => fg_service.pkg_utl_globals.g_bericht_status_aangemaakt
      , pi_ber_richting     => 'OUT'
      , pi_ber_aanmaakdatum => sysdate
      , pi_ber_inhoud       => cl_bericht
      );
    --
    po_bericht := cl_bericht;
    po_ber_id  := n_ber_id;
    --
    exception
      when e_template_leeg
      then
        raise;
  end bericht_maken;
  
  
  function bericht_versturen
    ( pi_url           in  varchar2
    , pi_action        in  varchar2
    , pi_request_data  in  clob
    )
  return xmltype
  is
    x_response       xmltype;
    s_node_fault     varchar2(2000);
    s_errortext      varchar2(2000);
    e_fout           exception;
    --pragma autonomous_transaction;
  begin
    apex_web_service.set_request_headers
      ( p_name_01        => 'Content-Type'
      , p_value_01       => 'text/xml;charset=UTF-8'
      , p_name_02        => 'Content-Length'
      , p_value_02       => dbms_lob.getlength( pi_request_data )
      , p_name_03        => 'Connection'
      , p_value_03       => 'Keep-Alive'
      , p_name_04        => 'User-Agent'
      , p_value_04       => 'Apache-HttpClient/4.1.1 (java 1.5)'
      );
    --
    x_response := apex_web_service.make_request
                    ( p_url      => pi_url
                    , p_action   => pi_action
                    , p_envelope => pi_request_data
                    );
    --
    -- controleren op SOAP fouten, genereer error bij soap fout
    s_node_fault := apex_web_service.parse_xml
      ( p_xml   => x_response
      , p_xpath => '//Fault'
      , p_ns    => 'xmlns="http://schemas.xmlsoap.org/soap/envelope/"'
      );
    s_errortext := apex_web_service.parse_xml
      ( p_xml   => x_response
      , p_xpath => '//ns:ErrorText/text()'
      , p_ns    => 'xmlns:ns="urn:edsn:edsn:data:soapfault:1:standard"'
      );
    --
    if s_node_fault is not null
    then
      raise e_fout;
    end if;
    --
    --commit;
    return x_response;
    --
  exception
    when e_fout
    then
      dbms_output.put_line('Error: '||sqlerrm);
      raise;
--      raise_application_error( -20101, s_errortext ); -- hoe gaan we dit doen?
    when others
    then
      dbms_output.put_line('Error: '||sqlerrm);
      return null;
  end bericht_versturen;
  --
  
begin
      -- TODO: controles voor enkelvoudige verwerking (met gevulde pi_coa_id):
      -- implementeren als we ooit een knop toevoegen op COA scherm
         -- status controleren:
         -- switchtype controleren
         -- EDSN dagen controleren
      bericht_maken
        ( pi_type_bericht    => 'moveinrequest' --type_request( pi_switchtype )
        , pi_ean             => '9876543210178' --rec.coa_ean
        , pi_kvk_nummer      => '012345678' --rec.kla_kvk_nummer
        , pi_naam            => 'Breems' --rec.kla_naam
        , pi_ean_eigen_lv    => '8712423033931' --s_ean_eigen_lv
        , pi_ean_pv          => '8714252018332' --ean_pv( rec.aab_productsoort )
        , pi_gridoperator_id => '2564851235648' --rec.amp_netbeheerder_ean
        , pi_mutatie_datum   => sysdate
        , po_bericht         => cl_bericht
        , po_ber_id          => n_ber_id_verzonden
        );

      --commit;
      dbms_output.put_line( 'new.BER_ID : ' || n_ber_id_verzonden);
      
      x_response := bericht_versturen
        ( pi_url          => 'http://127.0.0.1:85' -- fg_service.pkg_utl_instelling.instelling( 'EDSN_OMGEVING' ) --|| g_edsn_moveinrequest
        , pi_action       => 'http://127.0.0.1:85/mockMoveInBinding' -- action( pi_switchtype TODO: hardcoded url vervangen door instelling
        , pi_request_data => cl_bericht
        );

      for i in (select ber.ber_id into l_tmp from fp_data.ber_bericht ber where ber.ber_id = n_ber_id_verzonden)
      loop
        dbms_output.put_line( 'new.BER_ID : ' || i.ber_id || ' gevonden!' );
      end loop;

end;