set serveroutput on
-- bericht request klaarzetten
declare
  --s_ean varchar2(20) default '871685920003871319' ;
  s_ean varchar2(20) default '871694831000003123' ;

  p_ber_id_req_srch number;
  p_ber_id_rsp_srch number;

  p_ber_id_req_gt number;
  p_ber_id_rsp_gt number;
begin
  -- searchMeteringPoint klaarzetten
  fp_service.pkg_edsn.srchmp_req_bericht_klaarzetten( pi_ean    => s_ean
                                                    , po_ber_id => p_ber_id_req_srch );
  dbms_output.put_line(apex_string.format('srchmp_req_bericht_klaarzetten %s', p_ber_id_req_srch));

  -- searchMeteringPoint versturen
  fp_service.pkg_edsn.srchmp_req_bericht_versturen( pi_ber_id     => p_ber_id_req_srch
                                                  , po_ber_id_rsp => p_ber_id_rsp_srch );
  dbms_output.put_line(apex_string.format('srchmp_req_bericht_versturen %s', p_ber_id_rsp_srch));

  -- searchMeteringPoint verwerken
  fp_service.pkg_edsn.srchmp_rsp_bericht_verwerken( pi_ber_id => p_ber_id_rsp_srch );
  dbms_output.put_line(apex_string.format('srchmp_rsp_bericht_verwerken %s', p_ber_id_rsp_srch));


  -- getMeteringPoint klaarzetten
  fp_service.pkg_edsn.gtmp_req_bericht_klaarzetten( pi_ean    => s_ean
                                                  , po_ber_id => p_ber_id_req_gt );
  dbms_output.put_line(apex_string.format('gtmp_req_bericht_klaarzetten %s', p_ber_id_req_gt));

  -- getMeteringPoint versturen
  fp_service.pkg_edsn.gtmp_req_bericht_versturen( pi_ber_id     => p_ber_id_req_gt
                                                , po_ber_id_rsp => p_ber_id_rsp_gt);
  dbms_output.put_line(apex_string.format('gtmp_req_bericht_versturen %s', p_ber_id_rsp_gt));


  fp_service.pkg_edsn.gtmp_rsp_bericht_verwerken( p_ber_id_rsp_gt );
  dbms_output.put_line(apex_string.format('gtmp_rsp_bericht_verwerken %s', p_ber_id_rsp_gt ));
end;
/
