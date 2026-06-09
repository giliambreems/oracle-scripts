-- Make sure your sqlcl is in PATH variable to run it from anywhere
-- set PATH=%PATH%;c:\oracle\sqlcl_21_1\sqlcl\bin;
-- run as "sql <schema_owner>/<passwd>@<connection_string> @scripts/sqlcl/apex_upload_static_file.sql"

set term off

rem trick to assign values to &3 and &4 so that SQL*Plus does not ask
col workspace new_value 3
col workspace_id new_value 4

select workspace
     , workspace_id
from   apex_workspaces
where  workspace = upper('&3')
/

rem if values were passed in, use them
select '&3'  workspace
,      '&4'  workspace_id
from   dual
/

rem the values, either passed in or defaults are now in &1, &2, &3 and &4

rem put the values in meaningful variables
def static_file_name='&1'
def apex_user='&2'
def workspace='&3'
def workspace_id='&4'

set term on

PROMPT Call script and pass (default) parameters - "script scripts/sqlcl/apex_upload_static_file.js &static_file_name &apex_user &workspace &workspace_id"
script scripts/sqlcl/apex_upload_static_file.js "&static_file_name" "&apex_user" "&workspace" "&workspace_id"
exit
