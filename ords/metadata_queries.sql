/*****************************
**
** USER views
**
******************************/
SELECT object_name
FROM all_objects
WHERE object_name LIKE 'USER_ORDS%' AND object_type = 'VIEW'
ORDER BY 1;

-- USER_ORDS_APPROVALS
-- USER_ORDS_CLIENTS
-- USER_ORDS_CLIENT_PRIVILEGES
-- USER_ORDS_CLIENT_ROLES
-- USER_ORDS_ENABLED_OBJECTS
-- USER_ORDS_HANDLERS
-- USER_ORDS_MODULES
-- USER_ORDS_OBJECTS
-- USER_ORDS_OBJ_MEMBERS
-- USER_ORDS_PARAMETERS
-- USER_ORDS_PENDING_APPROVALS
-- USER_ORDS_PRIVILEGES
-- USER_ORDS_PRIVILEGE_MAPPINGS
-- USER_ORDS_PRIVILEGE_MODULES
-- USER_ORDS_PRIVILEGE_ROLES
-- USER_ORDS_PROPERTIES
-- USER_ORDS_ROLES
-- USER_ORDS_SCHEMAS
-- USER_ORDS_SERVICES
-- USER_ORDS_TEMPLATES



/*****************************
**
** Definition metadata - user views on ORDS_METADATA tables
**
******************************/

select *
from   ords_metadata.ords_schemas
/

select *
from   ORDS_METADATA.user_ords_modules
/

select *
from   ORDS_METADATA.user_ords_templates
/

select *
from   ORDS_METADATA.user_ords_handlers
/

select *
from   ORDS_METADATA.user_ords_parameters
/


select parsing_schema,
       parsing_object,
       object_alias,
       type,
       status
from   user_ords_enabled_objects
order by 1, 2;

SELECT object_name
FROM all_objects
WHERE object_name LIKE 'USER_ORDS%' AND object_type = 'VIEW'
ORDER BY 1;



/*****************************
**
** Authorization & Authentication
**
******************************/

-- user_ords_clients
select name, description, auth_flow, client_id, client_secret, c.* from user_ords_clients c;

-- user_ords_client_roles
select client_id, client_name, role_id, role_name from user_ords_client_roles r;

-- user_ords_roles
select id, name from user_ords_roles r;

-- user_ords_privileges
select id, label, name, schema_id from user_ords_privileges p;

-- user_ords_privilege_roles
select * from  user_ords_privilege_roles;

-- user_ords_client_privileges  -- !! This is for direct access to a client without a role, better not to use this and use roles instead. However, it is possible to grant a privilege directly to a client !!
select * from  user_ords_client_privileges;

--user_ords_properties
select * from   user_ords_properties;


begin
  oauth.create_client(
    p_name            => '<client_name>',
    p_grant_type      => 'client_credentials',
    p_owner           => '<owner>',
    p_description     => '<description>',
    p_support_email   => '<support_email>',
    p_privilege_names => null
  );
end;
/

begin
  oauth.grant_client_role(
    p_client_name => '<client_name>',
    p_role_name   => '<role_name>'
  );
end;
/

commit
/





/*****************************
**
** Using ORDS_SECURITY.REGISTER_CLIENT
**
******************************/

-- https://synuora.hashnode.dev/ords-using-uri-patterns-to-protect-resources

DECLARE
  l_client_cred ords_types.t_client_credentials;
BEGIN
    l_client_cred := ORDS_SECURITY.REGISTER_CLIENT(
        p_name            => 'MyClient',
        p_grant_type      => 'client_credentials',
        p_support_email   => 'myclient.user@oracle.com',
        p_description     => 'Invoke APEX CICD Agent Rest APIs',
        p_privilege_names => 'client.services.privilege',
        p_origins_allowed => '',
        p_redirect_uri    => NULL,
        p_support_uri     => 'https://apex.oracle.com',
        p_token_duration   => NULL,
        p_refresh_duration => NULL,
        p_code_duration    => NULL
        );

    ORDS_SECURITY.GRANT_CLIENT_ROLE(
        p_client_name => 'MyClient',
        p_role_name   => 'Client Services Role'
        );

    COMMIT;

    sys.dbms_output.put_line('Client ID:' || l_client_cred.client_key.client_id);
    sys.dbms_output.put_line('Secret:'    || l_client_cred.client_secret.secret);
    sys.dbms_output.put_line('slot:'      || l_client_cred.client_secret.slot);
    sys.dbms_output.put_line('Issued On:' || l_client_cred.client_secret.issued_on);
END;

-- Client is registered but does not have a secret
-- Use rotate client secret to generate one

DECLARE
  l_client_cred ords_types.t_client_credentials;
BEGIN
  l_client_cred.client_key.name := 'MyClient';
    l_client_cred := ORDS_SECURITY.ROTATE_CLIENT_SECRET(
      p_client_key    => l_client_cred.client_key
  );
  -- No Commit Required
  sys.dbms_output.put_line('Client ID:' || l_client_cred.client_key.client_id);
  sys.dbms_output.put_line('Secret:'    || l_client_cred.client_secret.secret);
  sys.dbms_output.put_line('slot:'      || l_client_cred.client_secret.slot);
  sys.dbms_output.put_line('Issued On:' || l_client_cred.client_secret.issued_on);
END;

/* To Delete the Client
DECLARE
  l_client_cred ords_types.t_client_credentials;
BEGIN
  l_client_cred.client_key.name := 'MyClient';

  ORDS_SECURITY.DELETE_CLIENT(
      p_client_key => l_client_cred.client_key
  );
END;
*/
