set serveroutput on
clear screen

-- EAN_EIGEN_LV    = 8712423033931
-- EDSN_OMGEVING   = http://localhost:82/edsn_act/synchroon

declare
--  sc_endpoint_base             constant varchar2(128) default 'http://localhost:85/edsn_opt/synchroon';
--  sc_endpoint_base             constant varchar2(128) default 'http://127.0.0.1:85/edsn_opt/synchroon';
  
--  sc_endpoint_base             constant varchar2(128) default 'http://etg-ontw-001.greenchoice.rotterdam:82/edsn_act/synchroon';  -- testchannel voor zakelijk (werkt)
--  sc_endpoint_base             constant varchar2(128)  default 'http://etg-ontw-001.greenchoice.rotterdam:85/edsn_act/synchroon';  -- testchannel voor producten ACT  (werkt 08-05-2024)
  sc_endpoint_base             constant varchar2(128) default 'http://etg-ontw-001.greenchoice.rotterdam:85/edsn_opt/synchroon';  -- channel voor producten werkt nog niet

--  sc_ean_lv                    constant varchar2(18) default '8712423033931';  -- 8712423033931 voor GCZ
  sc_ean_lv                    constant varchar2(18) default '8712423034372';  -- 8712423034372 voor GCP
  
--  sc_endpoint_base             constant varchar2(128) default fg_service.pkg_utl_instelling.instelling( 'EDSN_OMGEVING' );  -- testchannel voor producten ACT  (werkt 08-05-2024)
--  sc_ean_lv                    constant varchar2(18)  default fg_service.pkg_utl_instelling.instelling( 'EAN_EIGEN_LV' );  -- 8712423034372 voor GCP

  sc_edsn_searchmeteringpoints constant varchar2(128) default '/ResponderSearchMeteringPointsMPRespondingActivity';
  sc_endpoint                  constant varchar2(256) default sc_endpoint_base || sc_edsn_searchmeteringpoints;

  sc_soap_action               constant varchar2(128) default 'SearchMeteringPoints';
  sc_header_soapaction         constant varchar2(256) default '"urn:' || sc_soap_action || '"';  -- sc_soap_action geeft een "504 Gateway Time-out

  cl_request_data      clob;
  x_response           xmltype;
  
  -- genereer uuid om te gebruiken in xml bericht
  function uuid_genereren return varchar2
  is
    s_guid varchar2(100);
    s_uuid varchar2(100); 
  begin
    -- selecteer standaard guid:
    select sys_guid() into s_guid from dual;

    -- opmaken met correcte notatie:  12345678-1234-1234-1234-123456789012
    s_uuid := substr( s_guid,  0,  8 ) || '-' || 
              substr( s_guid,  9,  4 ) || '-' ||
              substr( s_guid, 13,  4 ) || '-' ||
              substr( s_guid, 17,  4 ) || '-' ||
              substr( s_guid, 21, 12 );

    return s_uuid;
  end uuid_genereren;

  function SOAPRequest
    ( p_endpoint varchar2
    , p_request_data clob
    , p_timeout number default 100
    , p_header_soapaction varchar2 default null
    )
  return XMLType
  as
    l_request_sub_str    varchar2(32000) ;
    l_request_pos        number;
    l_request_split_size number default 32000 ;
    l_response_sub_str   varchar2(32767) ;
    l_soap_respond_clb   clob;
    l_http_req           utl_http.req;
    l_http_resp          utl_http.resp;

    l_response          xmltype ;
    l_node              xmltype ;
    l_errornode         xmltype ;
    l_errortext         varchar2(2000);
  begin  
    DBMS_LOB.createtemporary(l_soap_respond_clb, false);

    -- opzetten verbinding...
    utl_http.set_transfer_timeout(timeout => p_timeout ) ;

    l_http_req := utl_http.begin_request( url => p_endpoint, method => 'POST', http_version => 'HTTP/1.1');

    utl_http.set_header(l_http_req, 'Content-Type', 'text/xml;charset=UTF-8');
    if ( p_header_soapaction is not null )  then 
      utl_http.set_header(l_http_req, 'SOAPAction', p_header_soapaction);    
    end if;
    --
--    pkg_utl_log.add_system('PKG_UTL_SOAP.SOAPRequest(p_endpoint => {0}, p_header_soapaction => {1}, p_request_data => {2})', p_endpoint, p_header_soapaction, DBMS_LOB.SUBSTR(p_request_data, 2048, 1));
    --

    utl_http.set_header(l_http_req, 'Content-Length', DBMS_LOB.getlength( p_request_data )  );
    utl_http.set_header(l_http_req, 'Connection', 'Keep-Alive');
    utl_http.set_header(l_http_req, 'User-Agent', 'Apache-HttpClient/4.1.1 (java 1.5)');

    -- knip invoer en stuur data naar endpoint    
    l_request_pos := 1;
    while l_request_pos <= DBMS_LOB.getlength( p_request_data ) loop
      utl_http.write_text(l_http_req, DBMS_LOB.SUBSTR(p_request_data,l_request_split_size,l_request_pos));
      -- next...
      l_request_pos := l_request_pos + l_request_split_size;
    end loop ;

    -- 
    l_http_resp := utl_http.get_response(l_http_req);

    -- ophalen response
    begin
        loop
          utl_http.read_text(l_http_resp, l_response_sub_str, 32767);

          DBMS_LOB.writeappend (l_soap_respond_clb, LENGTH(l_response_sub_str), l_response_sub_str);
        end loop;
    exception
          when UTL_HTTP.end_of_body then  
                utl_http.end_response(l_http_resp);
          when others then
                utl_http.end_response(l_http_resp);
                raise; 
    end; 

    begin
      dbms_output.put_line('----------');
      dbms_output.put_line('RESPONSE :');
      dbms_output.put_line('----------');
      --dbms_output.put_line(l_soap_respond_clb);
      l_response := XMLType.createXML(l_soap_respond_clb);

      select xmlserialize( document l_response as clob indent size=4) into l_soap_respond_clb from dual; -- Zorgt voor een pretty print
      dbms_output.put_line( l_soap_respond_clb);

--    exception when others then
--      pkg_utl_log.add_exception('PKG_UTL_SOAP.SOAPRequest({0}); -> {1}', p_endpoint, dbms_lob.substr(l_soap_respond_clb, 2000, 1));
    end;

    -- controleere op SOAP fouten, genereer error bij soap fout
    l_node := l_response.extract('//Fault','xmlns="http://schemas.xmlsoap.org/soap/envelope/"');
--    l_node := l_response.extract('//ns:SOAPFault','xmlns:ns="urn:edsn:edsn:data:soapfault:1:standard"');
    l_errornode := l_response.extract('//ns:ErrorText/text()','xmlns:ns="urn:edsn:edsn:data:soapfault:1:standard"');
    if l_errornode is not null then
        l_errortext := l_errornode.getStringVal();
    end if;

    if l_node is not null then 
        -- als er geen e
--        pkg_utl_log.add_system('Soap error in action {0}: ' || l_node.getStringVal(), p_header_soapaction);

--        begin
          raise_application_error( -20101, l_errortext );
--        exception when others then
--          pkg_utl_log.add_exception( 'Soap error in action ' || p_header_soapaction );
--          raise;
--        end;
    end if;

    return l_response ;
  end;

  function nvl2
    ( p_value               in varchar2
    , p_newval_if_not_null  in varchar2
    , p_newval_if_null      in varchar2
    )
  return varchar2
  deterministic
  is
  begin
    if p_value is not null then
      return( p_newval_if_not_null );
    else
      return( p_newval_if_null );
    end if;
  end nvl2;
  
  function replace_or_comment_out( pi_source in clob, pi_substition_string in varchar2, pi_substition_value in varchar2 default null)
  return clob
  is
    sc_character_tag varchar2(1) default '#';
    
    sc_comment_tag       varchar2(12) default 'XML_COMMENT';
    sc_comment_start_tag varchar2(20) default sc_comment_tag || '_START_';
    sc_comment_eind_tag  varchar2(20) default sc_comment_tag || '_EIND_';
    sc_xml_comment_start varchar2(5)  default '<!-- ';
    sc_xml_comment_eind  varchar2(5)  default ' -->';

    s_substition_string varchar2(100);
    s_result clob default pi_source;
  begin
    s_substition_string :=  replace( pi_substition_string, sc_character_tag, null); -- Remove start/end character
    
    -- Replace comment start/end tags if incoming value is null, otherwise remove comment start/eind tags
    s_result := replace( s_result, sc_character_tag || sc_comment_start_tag || s_substition_string || sc_character_tag, nvl2( pi_substition_value, null, sc_xml_comment_start ) );
    s_result := replace( s_result, sc_character_tag ||                         s_substition_string || sc_character_tag, pi_substition_value );
    s_result := replace( s_result, sc_character_tag || sc_comment_eind_tag  || s_substition_string || sc_character_tag, nvl2( pi_substition_value, null, sc_xml_comment_eind ) );
    
    return s_result;
  end replace_or_comment_out;
  
begin


-->> START - Get message template from TEM_TEMPLATES

  cl_request_data := '
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
	<soapenv:Header/>
	<soapenv:Body>
		<urn:SearchMeteringPointsRequestEnvelope xmlns:urn="urn:nedu:edsn:data:searchmeteringpointsrequest:1:standard">
			<urn:EDSNBusinessDocumentHeader>
				<urn:CreationTimestamp>#TIMESTAMP#</urn:CreationTimestamp>
				<urn:MessageID>#UUID#</urn:MessageID>
				<urn:Destination>
					<urn:Receiver>
						<urn:Authority>EAN.UCC</urn:Authority>
						<urn:ContactTypeIdentifier>EDSN</urn:ContactTypeIdentifier>
						<urn:ReceiverID>8712423010208</urn:ReceiverID>
					</urn:Receiver>
				</urn:Destination>
				<urn:Source>
					<urn:Authority>EAN.UCC</urn:Authority>
					<urn:ContactTypeIdentifier>DDQ_O</urn:ContactTypeIdentifier>
					<urn:SenderID>#EAN_LV#</urn:SenderID>
				</urn:Source>
			</urn:EDSNBusinessDocumentHeader>
			<urn:Portaal_Content>
				<urn:Portaal_MeteringPoint>
                   #XML_COMMENT_START_ADDRESS# <urn:EDSN_AddressSearch> #XML_COMMENT_EIND_ADDRESS#
                      #XML_COMMENT_START_HUISNUMMER# <urn:BuildingNr>#HUISNUMMER#</urn:BuildingNr> #XML_COMMENT_EIND_HUISNUMMER#
                      #XML_COMMENT_START_HUISNUMMER_TOEV# <urn:ExBuildingNr>#HUISNUMMER_TOEV#</urn:ExBuildingNr> #XML_COMMENT_EIND_HUISNUMMER_TOEV#
                      #XML_COMMENT_START_POSTCODE# <urn:ZIPCode>#POSTCODE#</urn:ZIPCode> #XML_COMMENT_EIND_POSTCODE#
                   #XML_COMMENT_START_ADDRESS# </urn:EDSN_AddressSearch> #XML_COMMENT_EIND_ADDRESS#
                   #XML_COMMENT_START_EAN# <urn:EANID>#EAN#</urn:EANID> #XML_COMMENT_EIND_EAN#
				</urn:Portaal_MeteringPoint>
			</urn:Portaal_Content>
		</urn:SearchMeteringPointsRequestEnvelope>
	</soapenv:Body>
</soapenv:Envelope>
';

--<< EIND - Get message template from TEM_TEMPLATES


-->> START - Search and replace substitution variables

  -- pas parameters toe op bericht template 
  cl_request_data := replace( cl_request_data, '#UUID#'     , uuid_genereren() );
  cl_request_data := replace( cl_request_data, '#TIMESTAMP#', to_char( sysdate, 'YYYY-MM-DD"T"HH24:MI:SS' ));
  cl_request_data := replace( cl_request_data, '#EAN_LV#'   , sc_ean_lv );  -- 8712423033931 voor GCZ, 8712423034372 voor GCP

  -- OF address postcode (en evt huisnummer) vullen
--  cl_request_data := replace_or_comment_out( cl_request_data, '#HUISNUMMER#'     , 1214 );  -- pi_huisnummer  -- '1214'
--  cl_request_data := replace_or_comment_out( cl_request_data, '#HUISNUMMER_TOEV#', null );  -- pi_huisnummertoev
--  cl_request_data := replace_or_comment_out( cl_request_data, '#POSTCODE#'       , '6545NE' );  -- pi_postcode  -- '6545NE'
--  cl_request_data := replace_or_comment_out( cl_request_data, '#ADDRESS#'        , 5 || null || null || null );  -- all address fields empty (or not)

  cl_request_data := replace_or_comment_out( cl_request_data, '#HUISNUMMER#'     , 5 );  -- pi_huisnummer  -- '1214'
  cl_request_data := replace_or_comment_out( cl_request_data, '#HUISNUMMER_TOEV#', null );  -- pi_huisnummertoev
  cl_request_data := replace_or_comment_out( cl_request_data, '#POSTCODE#'       , '2807LH' );  -- pi_postcode  -- '6545NE'
  cl_request_data := replace_or_comment_out( cl_request_data, '#ADDRESS#'        , 5 || null || null || null );  -- all address fields empty (or not)

  -- OF EAN vullen
  cl_request_data := replace_or_comment_out( cl_request_data, '#EAN#'            , null );  -- pi_ean  -- '111242300000110578'

--<< EIND - Search and replace substitution variables


-->> START - Output some content for developing/debugging
  dbms_output.put_line( 'URL Endpoint : ' || sc_endpoint );
  dbms_output.put_line( 'SOAPAction   : ' || sc_header_soapaction );
  dbms_output.put_line( chr(13) );
  
  
  dbms_output.put_line('----------');
  dbms_output.put_line('REQUEST :');
  dbms_output.put_line('----------');
  dbms_output.put_line( ltrim(cl_request_data,chr(10)) );
--<< EIND - Output some content for developing/debugging


-->> START - Execute SOAP Request
  x_response := soaprequest( p_endpoint => sc_endpoint, p_request_data => cl_request_data, p_header_soapaction => sc_header_soapaction );
--<< EIND - Execute SOAP Request

end;
/
