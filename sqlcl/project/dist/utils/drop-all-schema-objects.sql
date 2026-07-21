--
-- !! DO NOT RUN THIS SCRIPT ON PRODUCTION SYSTEMS !!
--

COLUMN ts NEW_VALUE ts
SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') ts FROM dual;

spool sqlcl-dropall-&ts..log


set define on
set serveroutput ON

---------------------
-- ENVIRONMENT GUARD
--
-- Verify that we are running on the expected environment host, if not an error is raised, the script stops and SQLcl exits with a failure code. SQLcl output will be written to "sqlcl-reinstall-*.log".
--
-- The expected host can be changed by setting the ALLOWED_ENVIRONMENT_LIST substitution variable below.
---------------------
whenever sqlerror exit sql.sqlcode

-- Comma separated list of allowed envs
define allowed_environment_list='dev,ps'

prompt
prompt Environment guard: allowed environments are "&allowed_environment_list"
prompt
declare
  l_host_name    varchar2(100);
  l_env_token    varchar2(50);
  l_allowed_list varchar2(200) := lower('&allowed_environment_list');
begin
  select lower(host_name)
  into   l_host_name
  from   v$instance;

  -- extract the env part between two dashes  (dev / ps)
  l_env_token := lower( regexp_substr( l_host_name, '[^-]+', 1, 2));

  -- check if env is in allowed list
  if instr(',' || l_allowed_list || ',', ',' || l_env_token || ',') = 0 then
    raise_application_error( -20000, apex_string.format('Environment guard failed: env "%s" from host "%s" does not exist in allowed list (%s)', l_env_token, l_host_name, l_allowed_list));
  end if;
end;
/

---------------------
-- Drop script
--
-- Remove all objects from the specified schemas.
---------------------
whenever sqlerror continue

define schemas="<COMMA_SEPERATED_SCHEMA_OWNERS>"

var p_schemas varchar2(4000)
exec :p_schemas :='&schemas';

set feedback off pagesize 100 linesize 150 heading on

prompt
prompt Remove all objects from schemas &schemas.
prompt

set feedback on pagesize 50 linesize 150 heading on

-- Drop all records in Liquibase tables for schemas &schemas
prompt Drop all records in Liquibase tables for schemas &schemas
delete from fp_release.databasechangelog cl where upper(cl.author) in (select upper(trim(regexp_substr(:p_schemas, '[^,]+', 1, level))) from dual connect by level <= regexp_count(:p_schemas, ',') + 1);
delete from fp_release.databasechangelog_actions cla where upper(cla.author) in (select upper(trim(regexp_substr(:p_schemas, '[^,]+', 1, level))) from dual connect by level <= regexp_count(:p_schemas, ',') + 1);
commit;

-- Drop all objects
prompt Drop all objects from schemas &schemas
declare
  cursor c
  is
    select o.object_type, o.owner, o.object_name
    from   all_objects o
    where  upper(o.owner) in (select upper(trim(regexp_substr(:p_schemas, '[^,]+', 1, level))) from dual connect by level <= regexp_count(:p_schemas, ',') + 1)
    and    o.object_type in ('TABLE','PACKAGE','PACKAGE BODY','SEQUENCE','VIEW','SYNONYM','FUNCTION','PROCEDURE','TYPE','DATABASE LINK');

  l_stmt varchar2(4000);

  e_object_not_exists exception;
  pragma EXCEPTION_INIT( e_object_not_exists, -4043 );
begin
  for r in c loop
    begin
      l_stmt := apex_string.format('DROP %s %s.%s %s', r.object_type, dbms_assert.enquote_name(r.owner), dbms_assert.enquote_name(r.object_name), case r.object_type when 'TABLE' then 'CASCADE CONSTRAINTS PURGE' else null end);
      dbms_output.put_line( l_stmt );

      execute immediate l_stmt;
    exception
        when e_object_not_exists then
          null; --ignore error
    end;
  end loop;
end;
/

-- Drop all scheduler jobs
prompt Drop all scheduler jobs
declare
  cursor c_scheduler_jobs
  is
    select j.owner, j.job_name
    from   all_scheduler_jobs j
    where  upper(j.owner) in (select upper(trim(regexp_substr(:p_schemas, '[^,]+', 1, level))) from dual connect by level <= regexp_count(:p_schemas, ',') + 1);

  l_stmt varchar2(4000);

  e_object_not_exists exception;
  pragma EXCEPTION_INIT( e_object_not_exists, -4043 );
begin
  -- Drop the scheduler job
  for r in c_scheduler_jobs loop
    begin

      -- Drop the scheduler job
      l_stmt := apex_string.format('begin sys.dbms_scheduler.drop_job(job_name => ''%s.%s'', defer => false, force => true); end;', dbms_assert.enquote_name(r.owner), dbms_assert.enquote_name(r.job_name));
      dbms_output.put_line( l_stmt );

      execute immediate l_stmt;

    exception
        when e_object_not_exists then
          null; --ignore error
    end;
  end loop;
end;
/

-- Drop all queues and queue tables
prompt Drop all queues and queue tables from schema &schemas
declare
  cursor c_queues
  is
    select q.owner, q.name
    from   all_queues q
    where  upper(q.owner) in (select upper(trim(regexp_substr(:p_schemas, '[^,]+', 1, level))) from dual connect by level <= regexp_count(:p_schemas, ',') + 1)
    and    q.queue_type = 'NORMAL_QUEUE';

  cursor c_queue_tables
  is
    SELECT q.owner, q.queue_table
    FROM   dba_queue_tables q
    WHERE  upper(q.owner) in (select upper(trim(regexp_substr(:p_schemas, '[^,]+', 1, level))) from dual connect by level <= regexp_count(:p_schemas, ',') + 1);

  l_stmt varchar2(4000);

  e_object_not_exists exception;
  pragma EXCEPTION_INIT( e_object_not_exists, -4043 );
begin
  -- Stop and drop queues
  for r in c_queues loop
    begin

      -- Stop the Queue
      l_stmt := apex_string.format('begin sys.dbms_aqadm.stop_queue (queue_name => ''%s.%s'', enqueue => TRUE, dequeue => TRUE); end;', dbms_assert.enquote_name(r.owner), dbms_assert.enquote_name(r.name));
      dbms_output.put_line( l_stmt );

      execute immediate l_stmt;

      -- Drop the Queue
      l_stmt := apex_string.format('begin sys.dbms_aqadm.drop_queue( queue_name => ''%s.%s''); end;', dbms_assert.enquote_name(r.owner), dbms_assert.enquote_name(r.name));
      dbms_output.put_line( l_stmt );

      execute immediate l_stmt;
    exception
        when e_object_not_exists then
          null; --ignore error
    end;
  end loop;

  -- Drop the queue tables
  for r in c_queue_tables loop
    begin

      -- Drop the Queue Table
      l_stmt := apex_string.format('begin sys.dbms_aqadm.drop_queue_table( queue_table => ''%s.%s''); end;', dbms_assert.enquote_name(r.owner), dbms_assert.enquote_name(r.queue_table));
      dbms_output.put_line( l_stmt );

      execute immediate l_stmt;
    exception
        when e_object_not_exists then
          null; --ignore error
    end;
  end loop;
end;
/

spool off
