select 'ALTER SYSTEM DISCONNECT SESSION ' || apex_string.format('%0%1,%2%3', chr(39), s.sid, s.serial#, chr(39)) || ' IMMEDIATE'
from   v$session s
where  schemaname = 'GDX_API'
/

ALTER SYSTEM DISCONNECT SESSION '15,1526' IMMEDIATE
/
