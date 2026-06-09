select *
from   APEX_INSTANCE_PARAMETERS
where  name in ('MAX_SESSION_IDLE_SEC', 'MAX_SESSION_LENGTH_SEC', 'SESSION_TIMEOUT_WARNING_SEC')
/

select
  'INSTANCE' as level_setting,
  null as application,
  (select to_number(value DEFAULT -999 ON CONVERSION ERROR) from APEX_INSTANCE_PARAMETERS where name = 'MAX_SESSION_LENGTH_SEC') as maximum_session_life_seconds,
  (select to_number(value DEFAULT -999 ON CONVERSION ERROR) from APEX_INSTANCE_PARAMETERS where name = 'MAX_SESSION_IDLE_SEC') as maximum_session_idle_seconds,
  (select to_number(value DEFAULT -999 ON CONVERSION ERROR) from APEX_INSTANCE_PARAMETERS where name = 'SESSION_TIMEOUT_WARNING_SEC') as SESSION_TIMEOUT_WARN_SECONDS
from dual
union all
select
  'WORKSPACE' as level_setting,
  null,
  maximum_session_life_seconds,
  maximum_session_idle_seconds,
  session_timeout_warn_seconds
from   apex_workspaces
where  workspace = 'DGS'
union all
select
  'APPLICATION' as level_setting,
  application_id || ' - ' || application_name,
  maximum_session_life_seconds,
  maximum_session_idle_seconds,
  session_timeout_warn_seconds
from   apex_applications s
where  application_id <= 1000
order by 2 nulls first, level_setting
/

select
  'APPLICATION' as level_setting,
  application_id || ' - ' || application_name,
  s.*
from   apex_applications s
where  application_id <= 1000
/
select *
from   apex_applications s
where  application_id <= 1000
/


begin
    dbms_output.put_line( 'INSTANCE');
    dbms_output.put_line( APEX_STRING.FORMAT( '    MAX_SESSION_IDLE_SEC        : %s', APEX_INSTANCE_ADMIN.GET_PARAMETER ( p_parameter  => 'MAX_SESSION_IDLE_SEC' )));
    dbms_output.put_line( APEX_STRING.FORMAT( '    MAX_SESSION_LENGTH_SEC      : %s', APEX_INSTANCE_ADMIN.GET_PARAMETER ( p_parameter  => 'MAX_SESSION_LENGTH_SEC' )));
    dbms_output.put_line( APEX_STRING.FORMAT( '    SESSION_TIMEOUT_WARNING_SEC : %s', APEX_INSTANCE_ADMIN.GET_PARAMETER ( p_parameter  => 'SESSION_TIMEOUT_WARNING_SEC' )));
    
    dbms_output.put_line( 'WORKSPACE');
    dbms_output.put_line( APEX_STRING.FORMAT( '    MAX_SESSION_IDLE_SEC        : %s', APEX_INSTANCE_ADMIN.GET_WORKSPACE_PARAMETER ( p_workspace => 'DGS', p_parameter  => 'MAX_SESSION_IDLE_SEC' )));
    dbms_output.put_line( APEX_STRING.FORMAT( '    MAX_SESSION_LENGTH_SEC      : %s', APEX_INSTANCE_ADMIN.GET_WORKSPACE_PARAMETER ( p_workspace => 'DGS', p_parameter  => 'MAX_SESSION_LENGTH_SEC' )));
    dbms_output.put_line( APEX_STRING.FORMAT( '    SESSION_TIMEOUT_WARNING_SEC : %s', APEX_INSTANCE_ADMIN.GET_WORKSPACE_PARAMETER ( p_workspace => 'DGS', p_parameter  => 'SESSION_TIMEOUT_WARNING_SEC' )));
    
    dbms_output.put_line( 'APP');
    dbms_output.put_line( APEX_STRING.FORMAT( '    MAX_SESSION_IDLE_SEC        : %s', APEX_APP_SETTING.GET_VALUE ( p_name  => 'MAX_SESSION_IDLE_SEC' )));
    dbms_output.put_line( APEX_STRING.FORMAT( '    MAX_SESSION_LENGTH_SEC      : %s', APEX_APP_SETTING.GET_VALUE ( p_name  => 'MAX_SESSION_LENGTH_SEC' )));
    dbms_output.put_line( APEX_STRING.FORMAT( '    SESSION_TIMEOUT_WARNING_SEC : %s', APEX_APP_SETTING.GET_VALUE ( p_name  => 'SESSION_TIMEOUT_WARNING_SEC' )));
end;
/
