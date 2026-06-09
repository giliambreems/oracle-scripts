with vw_sys_context as (
  select 'USERENV' as namespace, 'ACTION'                    as parameter, sys_context('userenv','ACTION'                   ) as value, 'Returns the position in the module' as description from dual union all
  select 'USERENV' as namespace, 'AUDITED_CURSORID'          as parameter, sys_context('userenv','AUDITED_CURSORID'         ) as value, 'Returns the cursor ID of the SQL that triggered the audit' from dual union all
  select 'USERENV' as namespace, 'AUTHENTICATED_IDENTITY'    as parameter, sys_context('userenv','AUTHENTICATED_IDENTITY'   ) as value, 'Returns the identity used in authentication' from dual union all
  select 'USERENV' as namespace, 'AUTHENTICATION_DATA'       as parameter, sys_context('userenv','AUTHENTICATION_DATA'      ) as value, 'Authentication data' from dual union all
  select 'USERENV' as namespace, 'AUTHENTICATION_METHOD'     as parameter, sys_context('userenv','AUTHENTICATION_METHOD'    ) as value, 'Returns the method of authentication' from dual union all
  select 'USERENV' as namespace, 'BG_JOB_ID'                 as parameter, sys_context('userenv','BG_JOB_ID'                ) as value, 'If the session was established by an Oracle background process, this parameter will return the Job ID. Otherwise, it will return NULL.' from dual union all
  select 'USERENV' as namespace, 'CLIENT_IDENTIFIER'         as parameter, sys_context('userenv','CLIENT_IDENTIFIER'        ) as value, 'Returns the client identifier (global context)' from dual union all
  select 'USERENV' as namespace, 'CLIENT_INFO'               as parameter, sys_context('userenv','CLIENT_INFO'              ) as value, 'User session information' from dual union all
  select 'USERENV' as namespace, 'CURRENT_BIND'              as parameter, sys_context('userenv','CURRENT_BIND'             ) as value, 'Bind variables for fine-grained auditing' from dual union all
  select 'USERENV' as namespace, 'CURRENT_EDITION_ID'        as parameter, sys_context('userenv','CURRENT_EDITION_ID'       ) as value, null from dual union all
  select 'USERENV' as namespace, 'CURRENT_EDITION_NAME'      as parameter, sys_context('userenv','CURRENT_EDITION_NAME'     ) as value, null from dual union all
  select 'USERENV' as namespace, 'CURRENT_SCHEMA'            as parameter, sys_context('userenv','CURRENT_SCHEMA'           ) as value, 'Returns the default schema used in the current schema' from dual union all
  select 'USERENV' as namespace, 'CURRENT_SCHEMAID'          as parameter, sys_context('userenv','CURRENT_SCHEMAID'         ) as value, 'Returns the identifier of the default schema used in the current schema' from dual union all
  select 'USERENV' as namespace, 'CURRENT_SQL'               as parameter, sys_context('userenv','CURRENT_SQL'              ) as value, 'Returns the SQL that triggered the audit event' from dual union all
  select 'USERENV' as namespace, 'CURRENT_SQL7'              as parameter, sys_context('userenv','CURRENT_SQL7'             ) as value, null from dual union all
  select 'USERENV' as namespace, 'CURRENT_SQL_LENGTH'        as parameter, sys_context('userenv','CURRENT_SQL_LENGTH'       ) as value, 'Returns the length of the current SQL statement that triggered the audit event' from dual union all
  select 'USERENV' as namespace, 'CURRENT_USER'              as parameter, sys_context('userenv','CURRENT_USER'             ) as value, 'Name of the current user' from dual union all
  select 'USERENV' as namespace, 'CURRENT_USERID'            as parameter, sys_context('userenv','CURRENT_USERID'           ) as value, 'Userid of the current user' from dual union all
  select 'USERENV' as namespace, 'DATABASE_ROLE'             as parameter, sys_context('userenv','DATABASE_ROLE'            ) as value, null from dual union all
  select 'USERENV' as namespace, 'DB_DOMAIN'                 as parameter, sys_context('userenv','DB_DOMAIN'                ) as value, 'Domain of the database from the DB_DOMAIN initialization parameter' from dual union all
  select 'USERENV' as namespace, 'DB_NAME'                   as parameter, sys_context('userenv','DB_NAME'                  ) as value, 'Name of the database from the DB_NAME initialization parameter' from dual union all
  select 'USERENV' as namespace, 'DB_UNIQUE_NAME'            as parameter, sys_context('userenv','DB_UNIQUE_NAME'           ) as value, 'Name of the database from the DB_UNIQUE_NAME initialization parameter' from dual union all
  select 'USERENV' as namespace, 'DBLINK_INFO'               as parameter, sys_context('userenv','DBLINK_INFO'              ) as value, null from dual union all
  select 'USERENV' as namespace, 'ENTRYID'                   as parameter, sys_context('userenv','ENTRYID'                  ) as value, 'Available auditing entry identifier' from dual union all
  select 'USERENV' as namespace, 'ENTERPRISE_IDENTITY'       as parameter, sys_context('userenv','ENTERPRISE_IDENTITY'      ) as value, 'Returns the user''s enterprise-wide identity' from dual union all
  select 'USERENV' as namespace, 'EXTERNAL_NAME'             as parameter, sys_context('userenv','EXTERNAL_NAME'            ) as value, 'External of the database user' from dual union all
  select 'USERENV' as namespace, 'FG_JOB_ID'                 as parameter, sys_context('userenv','FG_JOB_ID'                ) as value, 'If the session was established by a client foreground process, this parameter will return the Job ID. Otherwise, it will return NULL.' from dual union all
  select 'USERENV' as namespace, 'GLOBAL_CONTEXT_MEMORY'     as parameter, sys_context('userenv','GLOBAL_CONTEXT_MEMORY'    ) as value, 'The number used in the System Global Area by the globally accessed context' from dual union all
  select 'USERENV' as namespace, 'GLOBAL_UID'                as parameter, sys_context('userenv','GLOBAL_UID'               ) as value, 'The global user ID from Oracle Internet Directory for enterprise security logins. Returns NULL for all other logins.' from dual union all
  select 'USERENV' as namespace, 'HOST'                      as parameter, sys_context('userenv','HOST'                     ) as value, 'Name of the host machine from which the client has connected' from dual union all
  select 'USERENV' as namespace, 'IDENTIFICATION_TYPE'       as parameter, sys_context('userenv','IDENTIFICATION_TYPE'      ) as value, 'Returns the way the user''s schema was created' from dual union all
  select 'USERENV' as namespace, 'INSTANCE'                  as parameter, sys_context('userenv','INSTANCE'                 ) as value, 'The identifier number of the current instance' from dual union all
  select 'USERENV' as namespace, 'INSTANCE_NAME'             as parameter, sys_context('userenv','INSTANCE_NAME'            ) as value, 'The name of the current instance' from dual union all
  select 'USERENV' as namespace, 'IP_ADDRESS'                as parameter, sys_context('userenv','IP_ADDRESS'               ) as value, 'IP address of the machine from which the client has connected' from dual union all
  select 'USERENV' as namespace, 'ISDBA'                     as parameter, sys_context('userenv','ISDBA'                    ) as value, 'Returns TRUE if the user has DBA privileges. Otherwise, it will return FALSE.' from dual union all
  select 'USERENV' as namespace, 'LANG'                      as parameter, sys_context('userenv','LANG'                     ) as value, 'The ISO abbreviate for the language' from dual union all
  select 'USERENV' as namespace, 'LANGUAGE'                  as parameter, sys_context('userenv','LANGUAGE'                 ) as value, 'The language, territory, and character of the session. In the following format: language_territory.characterset' from dual union all
  select 'USERENV' as namespace, 'MODULE'                    as parameter, sys_context('userenv','MODULE'                   ) as value, 'Returns the appplication name set through DBMS_APPLICATION_INFO package or OCI' from dual union all
  select 'USERENV' as namespace, 'NETWORK_PROTOCOL'          as parameter, sys_context('userenv','NETWORK_PROTOCOL'         ) as value, 'Network protocol used' from dual union all
  select 'USERENV' as namespace, 'NLS_CALENDAR'              as parameter, sys_context('userenv','NLS_CALENDAR'             ) as value, 'The calendar of the current session' from dual union all
  select 'USERENV' as namespace, 'NLS_CURRENCY'              as parameter, sys_context('userenv','NLS_CURRENCY'             ) as value, 'The currency of the current session' from dual union all
  select 'USERENV' as namespace, 'NLS_DATE_FORMAT'           as parameter, sys_context('userenv','NLS_DATE_FORMAT'          ) as value, 'The date format for the current session' from dual union all
  select 'USERENV' as namespace, 'NLS_DATE_LANGUAGE'         as parameter, sys_context('userenv','NLS_DATE_LANGUAGE'        ) as value, 'The language used for dates' from dual union all
  select 'USERENV' as namespace, 'NLS_SORT'                  as parameter, sys_context('userenv','NLS_SORT'                 ) as value, 'BINARY or the linguistic sort basis' from dual union all
  select 'USERENV' as namespace, 'NLS_TERRITORY'             as parameter, sys_context('userenv','NLS_TERRITORY'            ) as value, 'The territory of the current session' from dual union all
  select 'USERENV' as namespace, 'OS_USER'                   as parameter, sys_context('userenv','OS_USER'                  ) as value, 'The OS username for the user logged in' from dual union all
  select 'USERENV' as namespace, 'POLICY_INVOKER'            as parameter, sys_context('userenv','POLICY_INVOKER'           ) as value, 'The invoker of row-level security policy functions' from dual union all
  select 'USERENV' as namespace, 'PROXY_ENTERPRISE_IDENTITY' as parameter, sys_context('userenv','PROXY_ENTERPRISE_IDENTITY') as value, 'The Oracle Internet Directory DN when the proxy user is an enterprise user' from dual union all
  select 'USERENV' as namespace, 'PROXY_USER'                as parameter, sys_context('userenv','PROXY_USER'               ) as value, 'The name of the user who opened the current session on behalf of SESSION_USER' from dual union all
  select 'USERENV' as namespace, 'PROXY_USERID'              as parameter, sys_context('userenv','PROXY_USERID'             ) as value, 'The identifier of the user who opened the current session on behalf of SESSION_USER' from dual union all
  select 'USERENV' as namespace, 'SERVER_HOST'               as parameter, sys_context('userenv','SERVER_HOST'              ) as value, 'The host name of the machine where the instance is running' from dual union all
  select 'USERENV' as namespace, 'SERVICE_NAME'              as parameter, sys_context('userenv','SERVICE_NAME'             ) as value, 'The name of the service that the session is connected to' from dual union all
  select 'USERENV' as namespace, 'SESSION_EDITION_ID'        as parameter, sys_context('userenv','SESSION_EDITION_ID'       ) as value, null from dual union all
  select 'USERENV' as namespace, 'SESSION_EDITION_NAME'      as parameter, sys_context('userenv','SESSION_EDITION_NAME'     ) as value, null from dual union all
  select 'USERENV' as namespace, 'SESSION_USER'              as parameter, sys_context('userenv','SESSION_USER'             ) as value, 'The database user name of the user logged in' from dual union all
  select 'USERENV' as namespace, 'SESSION_USERID'            as parameter, sys_context('userenv','SESSION_USERID'           ) as value, 'The database identifier of the user logged in' from dual union all
  select 'USERENV' as namespace, 'SESSIONID'                 as parameter, sys_context('userenv','SESSIONID'                ) as value, 'The identifier of the auditing session' from dual union all
  select 'USERENV' as namespace, 'SID'                       as parameter, sys_context('userenv','SID'                      ) as value, 'Session number' from dual union all
  select 'USERENV' as namespace, 'STATEMENTID'               as parameter, sys_context('userenv','STATEMENTID'              ) as value, 'The auditing statement identifier' from dual union all
  select 'USERENV' as namespace, 'TERMINAL'                  as parameter, sys_context('userenv','TERMINAL'                 ) as value, 'The OS identifier of the current session' from dual
)
select namespace, parameter, value, description
from  vw_sys_context
where value is not null
order by parameter
/
