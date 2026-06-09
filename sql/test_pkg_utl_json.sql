set serveroutput on

-- pkg_utl_json.plist_to_json_clob
declare
  l_list  apex_t_varchar2 := apex_t_varchar2();
  l_clob  clob;
  i pls_integer;
begin
  --
  apex_string.push(l_list, 'name_a');  apex_string.push(l_list, 'value_a');  
  apex_string.push(l_list, 'name_b');  apex_string.push(l_list, 'value_b');  
  apex_string.push(l_list, 'name_c');  apex_string.push(l_list, '12');  
  apex_string.push(l_list, 'name_d');  apex_string.push(l_list, '2024-11-01"T"12:30:00Z');

  l_clob := pkg_utl_json.plist_to_json_clob(l_list);
  dbms_output.put_line( l_clob);
end;
/

select *
from   fg_data.log_logging log
where log.log_datumtijd >= trunc(sysdate) -1 
order by log.log_id desc
/

select log.log_id,
       log.log_id_start,
       log.log_datumtijd,
       log.log_id_sessie,
       log.log_level,
       log.log_job,
       log.log_hierarchie,
       upper(log.log_aanroep_schema),
--       upper(log.log_aanroep_object),
       lpad( '>', (log.log_hierarchie*2), '>>') || ' ' || upper(log.log_aanroep_object), 
       log.log_type,
       log.log_info,
       log.log_parameters,
       log.log_apex_user,
       log.log_db_user,
       log.log_os_user,
       log.log_proxy_user
from   fg_Data.log_logging log
where  log.log_id_start = :log_id or log_id = :log_id
order by log_id
/

