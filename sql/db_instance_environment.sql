select * from v$instance
/

select sys_context ( 'USERENV', 'DB_NAME' ) db_name,
       sys_context ( 'USERENV', 'SESSION_USER' ) user_name,
       sys_context ( 'USERENV', 'SERVER_HOST' ) db_host,
       sys_context ( 'USERENV', 'HOST' ) user_host
from   dual
/


select sys_context ( 'USERENV', 'SERVER_HOST' ) db_host from dual
/

set serveroutput on
declare
  c_prod_hostname varchar2(12) default 'etg-prod-001';
  
  s_host  varchar2(30);
begin
  s_host := sys_context ( 'USERENV', 'SERVER_HOST' );
  
  if lower(s_host) = lower(c_prod_hostname) then
    dbms_output.put_line( 'THIS IS A PRODUCTION ENVIRONMENT!' );
  else
    dbms_output.put_line( 'This is NOT a production environment..' );
  end if;
    
end;
/
