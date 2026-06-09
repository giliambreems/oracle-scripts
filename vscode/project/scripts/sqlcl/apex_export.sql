-- Make sure your sqlcl is in PATH variable to run it from anywhere
-- set PATH=%PATH%;c:\oracle\sqlcl_21_1\sqlcl\bin;
-- run as "sql <schema_owner>/<passwd>@<connection_string> @scripts/sqlcl/apex_export.sql <APP_ID> <WORKSPACE> <WORKSPACE_ID>"
-- run as "sql <schema_owner>/<passwd>@<connection_string> @scripts/sqlcl/apex_export.sql wsf" for workspace static files

set term off

rem trick to assign values to &2 and &3 so that SQL*Plus does not ask
col workspace new_value 2
col workspace_id new_value 3

select workspace
     , workspace_id
from   apex_workspaces
where  workspace = upper('&2')
/

rem if values were passed in, use them
select '&2'  workspace
,      '&3'  workspace_id
from   dual
/
rem the values, either passed in or defaults are now in &1, &2 and &3

rem put the values in meaningful variables
def app_id='&1'
def workspace='&2'
def workspace_id='&3'

set term on

PROMPT Call script and pass (default) parameters - "script scripts/sqlcl/apex_export.js &app_id &workspace &workspace_id"
script scripts/sqlcl/apex_export.js "&app_id" "&workspace" "&workspace_id"
exit
