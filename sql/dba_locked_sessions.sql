-- Blocking Objects and Sessions
select
   b.sid,
   b.serial#,
   nvl(b.username, '(oracle)') AS username,
   c.owner object_owner,
   c.object_name,
   c.object_type,
   b.status,
   b.osuser,
   b.machine,
   b.program,
   decode(a.locked_mode, 0, a.locked_mode || ' / ' || 'None',
                         1, a.locked_mode || ' / ' || 'Null (NULL)',
                         2, a.locked_mode || ' / ' || 'Row-S (SS)',
                         3, a.locked_mode || ' / ' || 'Row-X (SX)',
                         4, a.locked_mode || ' / ' || 'Share (S)',
                         5, a.locked_mode || ' / ' || 'S/Row-X (SSX)',
                         6, a.locked_mode || ' / ' || 'Exclusive (X)',
                         a.locked_mode) locked_mode,
   nvl2(b.sql_id, null, b.prev_sql_id) blocking_sql_id,
   b.sql_id  waiting_sql_id,
   nvl( b.sql_exec_start, b.prev_exec_start) blocking_lock_since,
   b.logon_time
from
   v$locked_object a
join
   v$session b on b.sid = a.session_id
join
   dba_objects c on c.object_id = a.object_id
order by
   1, 2, 3, 4, 5;


-- Get SQL that causes the blocking lock
select
   s.sql_id, s.sql_text, s.sql_fulltext
from
   v$sql s
where
   s.sql_id = :sql_id;


-- Active Sessions
SELECT s.inst_id,
       s.sid,
       s.serial#,
       --s.sql_id,
       p.spid,
       s.username,
       s.osuser,
       s.program,
       s.schemaname,
       s.status,
       s.state,
       s.event
FROM   gv$session s
       JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
WHERE  s.type != 'BACKGROUND';


-- Kill Session
ALTER SYSTEM DISCONNECT SESSION 'sid,serial#' IMMEDIATE;


-- Cancel SQL
ALTER SYSTEM CANCEL SQL 'sid,serial#';


-- Kill Session
ALTER SYSTEM DISCONNECT SESSION '646,17859' IMMEDIATE;


-- Locks veroorzaakt door FP_API en lock langer open dan 5 minuten
select
   b.sid,
   b.serial#,
   NVL(b.username, '(oracle)') AS username,
   c.owner object_owner,
   c.object_name,
   c.object_type,
   b.status,
   b.osuser,
   b.machine,
   b.program,
   decode(a.locked_mode, 0, a.locked_mode || ' / ' || 'None',
                         1, a.locked_mode || ' / ' || 'Null (NULL)',
                         2, a.locked_mode || ' / ' || 'Row-S (SS)',
                         3, a.locked_mode || ' / ' || 'Row-X (SX)',
                         4, a.locked_mode || ' / ' || 'Share (S)',
                         5, a.locked_mode || ' / ' || 'S/Row-X (SSX)',
                         6, a.locked_mode || ' / ' || 'Exclusive (X)',
                         a.locked_mode) locked_mode,
   nvl2(b.sql_id, null, b.prev_sql_id) blocking_sql_id,
   b.sql_id  waiting_sql_id,
   nvl( b.sql_exec_start, b.prev_exec_start) blocking_lock_since,
   b.logon_time
from
   v$locked_object a
join
   v$session b on b.sid = a.session_id
join
   dba_objects c on c.object_id = a.object_id
where
   b.username  = 'FP_API'
and
   b.prev_exec_start + (1/24/60*5) < sysdate
order by
   1, 2, 3, 4, 5;
/


-- Locked objects (with or without session)
select
   c.owner object_owner,
   c.object_name,
   c.object_type,
   decode(a.locked_mode, 0, a.locked_mode || ' / ' || 'None',
                         1, a.locked_mode || ' / ' || 'Null (NULL)',
                         2, a.locked_mode || ' / ' || 'Row-S (SS)',
                         3, a.locked_mode || ' / ' || 'Row-X (SX)',
                         4, a.locked_mode || ' / ' || 'Share (S)',
                         5, a.locked_mode || ' / ' || 'S/Row-X (SSX)',
                         6, a.locked_mode || ' / ' || 'Exclusive (X)',
                         a.locked_mode) locked_mode
from
   v$locked_object a
join
   dba_objects c on c.object_id = a.object_id
/
