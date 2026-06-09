alter session set current_schema = NONE;

with data as (
select decode(ins_omgeving, 'LOK', 'ONTW', ins_omgeving) ins_omgeving,
       ins_code,
       ins_type,
       case ins_type
         when 'W' then  rawtohex( utl_raw.cast_to_raw(ins_waarde))
         else ins_waarde
        end ins_waarde
from  dgs.ins_instelling
where 1=1
--and ins_omgeving = 'ACC'
and ins_code like '%VERTEX%'
and ins_Code in ('VERTEX_ENTRA_KEY','VERTEX_CLIENT_ID_ENTRA_ID','VERTEX_CLIENT_SECRET_ENTRA_ID','VERTEX_ENTRA_ID_URL', 'VERTEX_BASE_URL','VERTEX_X-EE-TENANT_ENTRA', 'VERTEX_TIMESERIES_URL')
)
select apex_string.format('  ins_ins(''%s'', ''%s'', ''%s'', ''%s'');', ins_omgeving, ins_code, ins_type, ins_waarde )
from data
/


alter session set current_schema = FP_SERVICE;

set serveroutput on

declare
  l_date_1 date;
  l_date_2 date;
  l_tmp clob;
begin
  l_date_1 := date '2024-08-01';
  l_date_2 := sysdate;
  
  l_tmp := fp_service.pkg_vertex_api.ophalen_epex_tarieven( l_date_1, l_date_2);
  dbms_output.put_line( substr(l_tmp, 1, 32767));

  l_tmp := fp_service.pkg_vertex_api.ophalen_ttf_eex_tarieven( l_date_1, l_date_2);
  dbms_output.put_line( substr(l_tmp, 1, 32767));

  l_tmp := fp_service.pkg_vertex_api.ophalen_ttf_leba_tarieven( l_date_1, l_date_2);
  dbms_output.put_line( substr(l_tmp, 1, 32767));
end;
/

select * from fg_data.log_logging order by 1 desc
/