-- Run as SYS
set serveroutput on size unlimited
set define on
set verify on
set feedback on
set termout on


PROMPT Drop Existing Schemas for proxy-user testing
DROP USER "PROXY";
DROP USER "PROXY.USER";
DROP USER "SCHEMA_OWNER";

PROMPT Creating Schema 'PROXY'
CREATE USER "PROXY" IDENTIFIED BY "oracle" account unlock;

PROMPT Creating Schema 'PROXY.USER'
CREATE USER "PROXY.USER" IDENTIFIED BY "oracle" account unlock;

PROMPT Creating Schema 'SCHEMA_OWNER'
CREATE USER "SCHEMA_OWNER" IDENTIFIED BY "oracle" account unlock;

PROMPT Granting Create Session to these users
grant  CREATE SESSION   to  "PROXY";
grant  CREATE SESSION   to  "PROXY.USER";
grant  CREATE SESSION   to  "SCHEMA_OWNER";

PROMPT Granting Connect as [proxy] user
alter user "SCHEMA_OWNER" grant connect through  "PROXY";
alter user "SCHEMA_OWNER" grant connect through  "PROXY.USER";




PROMPT Connect to SCHEMA_OWNER
conn schema_owner/oracle@localhost/hmedb001

PROMPT Connect to "SCHEMA_OWNER"
conn "SCHEMA_OWNER"/oracle@localhost/hmedb001

PROMPT Connect to PROXY
conn proxy/oracle@localhost/hmedb001

PROMPT Connect to "PROXY"
conn "PROXY"/oracle@localhost/hmedb001

PROMPT Connect to "PROXY.USER"
conn "PROXY.USER"/oracle@localhost/hmedb001


PROMPT Connect to PROXY[schema_owner]
conn proxy[schema_owner]/oracle@localhost/hmedb001

PROMPT Connect to "PROXY"[schema_owner]
conn "PROXY"[schema_owner]/oracle@localhost/hmedb001

PROMPT Connect to "PROXY.USER"[schema_owner]
conn "PROXY.USER"[schema_owner]/oracle@localhost/hmedb001
