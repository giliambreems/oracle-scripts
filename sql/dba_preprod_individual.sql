set serveroutput on

-- Lock developers that shouldn't have access anymore
PROMPT >> Lock user accounts that no longer have an employee contract
alter user "CHRYSTAL.BOR"   account lock;
alter user "EVA.MIKHAILOVA" account lock;
alter user "HELMUT.STEEMAN" account lock;


-- Change passw from known/existing FluxProducenten schemas
PROMPT >> Change passw for database application schemas
alter user FG_DATA     identified by "abcdefg";
alter user FG_SERVICE  identified by "abcdefg";
alter user FP_API      identified by "abcdefg";
alter user FP_DATA     identified by "abcdefg";
alter user FP_SERVICE  identified by "abcdefg";
alter user FS_SIDEKICK identified by "abcdefg";


-- Make me an admin for APEX as well
PROMPT >> Grant APEX_ADMINISTRATOR_ROLE to DBA_<<USER>>
grant APEX_ADMINISTRATOR_ROLE to "DBA_GILIAM.BREEMS"
/

-- Load the database role by default
PROMPT >> Load all users roles by default
alter user "DBA_GILIAM.BREEMS" default role all
/

-- Add developer to APEX Builder
PROMPT >> Add User to APEX Workspace user as developer
declare
  l_workspace_id   number;
  l_user_id        number;
begin
  l_workspace_id := apex_util.find_security_group_id (p_workspace => 'DGS');
  apex_util.set_security_group_id (p_security_group_id => l_workspace_id);

  l_user_id := APEX_UTIL.GET_USER_ID('GILIAM.BREEMS');
  if l_user_id is null then
    -- User doesn't exists yet
    apex_util.create_user(
      p_user_name       => 'GILIAM.BREEMS',
      p_first_name      => 'Giliam',
      p_last_name       => 'Breems',
      p_email_address   => 'giliam.breems@greenchoice.nl',
      p_default_schema  => 'FP_SERVICE',
      p_developer_privs => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
      p_web_password    => 'MyStrongPassword123',
      p_change_password_on_first_use  => 'N' );
  end if;
end;
/

commit
/

