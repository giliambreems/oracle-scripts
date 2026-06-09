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

