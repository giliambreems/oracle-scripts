-- Workspaces in the APEX Instance
select aws.workspace_id, aws.workspace, aws.workspace_banner_label, aws.sessions, aws.applications, aws.application_pages, aws.apex_users, aws.apex_developers, aws.apex_workspace_administrators
from   apex_workspaces aws
order by workspace_id
/

-- Workspace Users in the APEX Instance
select * --aws.workspace_id, aws.workspace, aws.workspace_banner_label, aws.sessions, aws.applications, aws.application_pages, aws.apex_users, aws.apex_developers, aws.apex_workspace_administrators
from   APEX_WORKSPACE_APEX_USERS aws
where user_name like upper('giliam%')
/


-- Set security group id
BEGIN
    APEX_UTIL.SET_SECURITY_GROUP_ID ( 1877955024274397);
end;
/

-- Set Workspace (id equals to security_group_id)
BEGIN
    APEX_UTIL.SET_WORKSPACE ( 'DGS');
end;
/

-- Unlock Admin User (APEX_ADMINISTRATOR_ROLE is required)
begin
  APEX_230100.APEX_UNLOCK_ADMIN_USER( P_USER_NAME => 'GILIAM.BREEMS', P_NEW_PASSWORD => 'Oracle_ww1', P_WORKSPACE => 'DGS');
end;
/

-- Grant  APEX_ADMINISTRATOR_ROLE
grant APEX_ADMINISTRATOR_ROLE to "DBA_GILIAM.BREEMS"
/

alter user "DBA_GILIAM.BREEMS" default role all
/

select  APEX_UTIL.GET_USER_ID( 'GILIAM.BREEMS') from dual
/


-- Set/rename username
begin
  APEX_UTIL.SET_USERNAME( 136492571540142551, 'GILIAM.BREEMS');
end;
/

-- Get roles from apex user
select APEX_UTIL.GET_USER_ROLES(p_username=>'GILIAM.BREEMS')
from dual
/

-- Give Workspace ADMIN rights to a default end-user
DECLARE
    l_user_id                       NUMBER;
    l_workspace                     VARCHAR2(255);
    l_user_name                     VARCHAR2(100);
    l_first_name                    VARCHAR2(255);
    l_last_name                     VARCHAR2(255);
    l_web_password                  VARCHAR2(255);
    l_email_address                 VARCHAR2(240);
    l_start_date                    DATE;
    l_end_date                      DATE;
    l_employee_id                   NUMBER(15,0);
    l_allow_access_to_schemas       VARCHAR2(4000);
    l_person_type                   VARCHAR2(1);
    l_default_schema                VARCHAR2(30);
    l_groups                        VARCHAR2(1000);
    l_developer_role                VARCHAR2(60);
    l_description                   VARCHAR2(240);
    l_account_expiry                DATE;
    l_account_locked                VARCHAR2(1);
    l_failed_access_attempts        NUMBER;
    l_change_password_on_first_use  VARCHAR2(1);
    l_first_password_use_occurred   VARCHAR2(1);
BEGIN
    l_user_id := APEX_UTIL.GET_USER_ID('GILIAM.BREEMS');

APEX_UTIL.FETCH_USER(
    p_user_id                       => l_user_id,
    p_workspace                     => l_workspace,
    p_user_name                     => l_user_name,
    p_first_name                    => l_first_name,
    p_last_name                     => l_last_name,
    p_web_password                  => l_web_password,
    p_email_address                 => l_email_address,
    p_start_date                    => l_start_date,
    p_end_date                      => l_end_date,
    p_employee_id                   => l_employee_id,
    p_allow_access_to_schemas       => l_allow_access_to_schemas,
    p_person_type                   => l_person_type,
    p_default_schema                => l_default_schema,
    p_groups                        => l_groups,
    p_developer_role                => l_developer_role,
    p_description                   => l_description,
    p_account_expiry                => l_account_expiry,
    p_account_locked                => l_account_locked,
    p_failed_access_attempts        => l_failed_access_attempts,
    p_change_password_on_first_use  => l_change_password_on_first_use,
    p_first_password_use_occurred   => l_first_password_use_occurred);
    
APEX_UTIL.EDIT_USER (
    p_user_id                       => l_user_id,
    p_user_name                     => l_user_name,
    p_first_name                    => l_first_name,
    p_last_name                     => l_last_name,
    p_web_password                  => l_web_password,
    p_new_password                  => l_web_password,
    p_email_address                 => l_email_address,
    p_start_date                    => l_start_date,
    p_end_date                      => l_end_date,
    p_employee_id                   => l_employee_id,
    p_allow_access_to_schemas       => l_allow_access_to_schemas,
    p_person_type                   => l_person_type,
    p_default_schema                => l_default_schema,
    p_group_ids                     => l_groups,
    p_developer_roles               => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
    p_description                   => l_description,
    p_account_expiry                => l_account_expiry,
    p_account_locked                => l_account_locked,
    p_failed_access_attempts        => l_failed_access_attempts,
    p_change_password_on_first_use  => l_change_password_on_first_use,
    p_first_password_use_occurred   => l_first_password_use_occurred);
END;
/


declare
  l_workspace_id   number;
begin
  l_workspace_id := apex_util.find_security_group_id (p_workspace => 'DGS');
  apex_util.set_security_group_id (p_security_group_id => l_workspace_id);    
  apex_util.create_user(
    p_user_name       => 'GILIAM.BREEMS',
    p_first_name      => 'Giliam',
    p_last_name       => 'Breems',
    p_email_address   => 'giliam.breems@greenchoice.nl',
    p_default_schema  => 'FP_SERVICE',
    p_developer_privs => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
    p_web_password    => 'MyStrongPassword123');
  commit;
end;
/