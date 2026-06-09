declare
  l_workspace_id number default xxxx;
begin
  wwv_flow_api.set_security_group_id(l_workspace_id);
end;
/

-- TODO:
PROMPT
PROMPT Lock application(s) before export
--begin  apex_util.set_app_build_status( p_application_id => 100, p_build_status   => 'RUN_ONLY' ); commit; end; 

PROMPT
PROMPT Export 'APEX application' (GIT source files)
apex export -workspaceid xxxx -applicationid 100 -dir .\\apex\\project\\apps -skipExportDate -split

-- Only run in DEV environment
apex export -workspaceid xxxx -applicationid xxx -dir .\\apex\\omisklu\\apps -skipExportDate -split    

PROMPT
PROMPT Export 'Static Application/Workspace Files' (GIT source files)
script scripts/sqlcl/apex_export_all.js

PROMPT
PROMPT Export 'APEX application' (APEX release file)
apex export -workspaceid xxxx -applicationid xxx -dir .\\oplev -skipExportDate

PROMPT Exporting Workspace Static File
apex export -workspaceid xxxx -expfiles -dir .\\oplev 

-- TODO:
PROMPT
PROMPT Unlock application(s) after export
--begin  apex_util.set_app_build_status( p_application_id => 100, p_build_status   => 'RUN_AND_BUILD' ); commit; end; 


!cd
exit
