-- Make sure your sqlcl is in PATH variable to run it from anywhere
-- set PATH=%PATH%;c:\oracle\sqlcl_21_1\sqlcl\bin;
-- run as "sql <schema_owner>/<passwd>@<connection_string> @scripts/sqlcl/schema_export.sql "<OBJ_OWNER>" "<OBJ_TYPE>" "<OBJ_NAME>""

set term off

rem setup default values
def DEFAULT_OBJ_TYPE='ALL'
def DEFAULT_OBJ_NAME='ALL'
def DEFAULT_SPLIT_FK='N'
def DEFAULT_SPLIT_GRANT='N'

rem trick to assign values to &1, &2 and &3 so that SQL*Plus does not ask
col obj_type new_value 2
col obj_name new_value 3
col split_fks new_value 5
col split_grants new_value 6

select null obj_type
,      null obj_name
,      null split_fks
,      null split_grants
from   dual
where  1=2
/

rem if values were passed in, use them, if not, use the defaults
select nvl('&2','&DEFAULT_OBJ_TYPE')  obj_type
,      nvl('&3','&DEFAULT_OBJ_NAME')  obj_name
,      nvl('&5','&DEFAULT_SPLIT_FK')  split_fks
,      nvl('&6','&DEFAULT_SPLIT_GRANT')  split_grants
from   dual
/
rem the values, either passed in or defaults are now in &1, &2 and &3

rem put the values in meaningful variables
def obj_owner='&1'
def obj_type='&2'
def obj_name='&3'
def grantee="&4"
def split_fks='&5'
def split_grants='&6'

set term on

PROMPT Call script and pass (default) parameters - "script scripts/sqlcl/schema_export.js &obj_owner &obj_type &obj_name"
script scripts/sqlcl/schema_export.js "&obj_owner" "&obj_type" "&obj_name" "&grantee" "&split_fks" "&split_grants"
exit
