-- https://stackoverflow.com/questions/29271224/how-to-handle-day-light-saving-in-oracle-database

--               Wintertijd  ->   Zomertijd       (Om 02:00am wordt de klok een uur vooruit gezet naar 03:00am)
----------------------------------------------
-- 00:55 UTC  =  01:55 +01:00  =
-- 00:59 UTC  =  01:59 +01:00  =
-- 01:00 UTC  =  02:00 +01:00  =  03:00 +02:00    -- overgang van wintertijd naar zomertijd (van +01:00 naar +02:00)
-- 01:01 UTC  =                =  03:01 +02:00
-- 01:05 UTC  =                =  03:05 +02:00


--               Wintertijd   <-  Zomertijd       (Om 03:00am wordt de klok een uur teruggezet naar 02:00am)
----------------------------------------------
-- 00:55 UTC  =                =  02:55 +02:00
-- 00:59 UTC  =                =  02:59 +02:00
-- 01:00 UTC  =  02:00 +01:00  =  03:00 +02:00    -- overgang van zomertijd naar wintertijd (van +02:00 naar +01:00)
-- 01:01 UTC  =  02:01 +01:00  =
-- 01:05 UTC  =  02:05 +01:00  =



--               Wintertijd  ->   Zomertijd       (Om 02:00am wordt de klok een uur vooruit gezet naar 03:00am)
----------------------------------------------
-- 00:55 UTC  =  01:55 +01:00  =  02:55 +02:00
-- 00:59 UTC  =  01:59 +01:00  =  02:59 +02:00
-- 01:00 UTC  =  02:00 +01:00  =  03:00 +02:00    -- overgang van wintertijd naar zomertijd (van +01:00 naar +02:00)
-- 01:01 UTC  =  02:01 +01:00  =  03:01 +02:00
-- 01:05 UTC  =  02:05 +01:00  =  03:05 +02:00

--               Wintertijd   <-  Zomertijd       (Om 03:00am wordt de klok een uur teruggezet naar 02:00am)
----------------------------------------------
-- 00:55 UTC  =  01:55 +01:00  =  02:55 +02:00
-- 00:59 UTC  =  01:59 +01:00  =  02:59 +02:00
-- 01:00 UTC  =  02:00 +01:00  =  03:00 +02:00    -- overgang van zomertijd naar wintertijd (van +02:00 naar +01:00)
-- 01:01 UTC  =  02:01 +01:00  =  03:01 +02:00
-- 01:05 UTC  =  02:05 +01:00  =  03:05 +02:00


-- TIME ZONE of Database Server's Operating System
-- Relevant for  relevant for result of SYSDATE and SYSTIMESTAMP
-- This can be modified by changing the timezone and/or daylight saving time in your Operating System (Windows Settings -> Time & Language)
SELECT TO_CHAR(SYSTIMESTAMP, 'tzr') OPERATING_SYSTEM_TIME_ZONE FROM dual
/

-- DBTIMEZONE The database time zone: DBTIMEZONE
-- This can be modified by ALTER DATABASE SET TIME_ZONE='...'; shutdown; startup;  Only successful when no columns and data exist with datatype "timestamp with local time zone"
select dbtimezone DATABASE_TIME_ZONE from dual
/

-- SESSIONTIMEZONE Your session time zone: SESSIONTIMEZONE
-- It is relevant for result of CURRENT_DATE and LOCALTIMESTAMP and CURRENT_TIMESTAMP
-- This can be changed by ALTER SESSION SET TIME_ZONE='...';
select sessiontimezone SESSION_TIME_ZONE from dual
/

-- Set session timezone to EUROPE/Amsterdam winter time (fixed offset +01:00)
alter session set time_zone = '+01:00'
/

-- Display diff between Session Timezone and OS Timezone
select sessiontimezone SESSION_TIME_ZONE,
       current_timestamp,
       TO_CHAR(SYSTIMESTAMP, 'tzr') OPERATING_SYSTEM_TIME_ZONE,
       systimestamp
from   dual
/

-- Set timezone to EUROPE/Amsterdam summer time (fixed offset +02:00)
alter session set time_zone = '+02:00'
/

-- Display diff between Session Timezone and OS Timezone
select sessiontimezone SESSION_TIME_ZONE,
       current_timestamp,
       TO_CHAR(SYSTIMESTAMP, 'tzr') OPERATING_SYSTEM_TIME_ZONE,
       systimestamp
from   dual
/

-- Set session timezone to EUROPE/Amsterdam and let Oracle handle daylight saving time automatically
alter session set time_zone = 'Europe/Amsterdam'
/


-------------------
-- Test query pkg_utl_date functions
-------------------

with
  epoch_times as
  ( select 1761436800 as epoch from dual union all
    select 1761437700 from dual union all
    select 1761438600 from dual union all
    select 1761439500 from dual union all
    select 1761440400 from dual union all
    select 1761441300 from dual union all
    select 1761442200 from dual union all
    select 1761443100 from dual
    )
select e.epoch,
       timestamp '1970-01-01 00:00:00 UTC' +  NUMTODSINTERVAL( e.epoch, 'SECOND') as time_in_tstz,

       fg_service.pkg_utl_date.epoch_to_date( e.epoch ) as epoch_to_date,
       fg_service.pkg_utl_date.epoch_to_timestamp_tz( e.epoch ) as epoch_to_timestamp_tz,
       fg_service.pkg_utl_date.date_to_epoch( fg_service.pkg_utl_date.epoch_to_date( e.epoch ) ) as date_to_epoch,
       fg_service.pkg_utl_date.from_utc_to_local_time( fg_service.pkg_utl_date.epoch_to_date( e.epoch ) ) as from_utc_to_local_time,
       fg_service.pkg_utl_date.from_local_time_to_utc( fg_service.pkg_utl_date.epoch_to_date( e.epoch ) ) as from_local_time_to_utc,
       fg_service.pkg_utl_date.to_timezone( fg_service.pkg_utl_date.epoch_to_date( e.epoch ), 'UTC', 'Europe/Amsterdam') as to_timezone_ams,
       fg_service.pkg_utl_date.to_timezone( fg_service.pkg_utl_date.epoch_to_date( e.epoch ), 'UTC', 'America/New_York') as to_timezone_ny

from   epoch_times e
/

select cast( systimestamp as timestamp with local time zone) at time zone 'UTC',
       fg_service.pkg_utl_date.to_timezone( cast( systimestamp as timestamp with local time zone), 'UTC' ),
       fg_service.pkg_utl_date.to_timezone( systimestamp , 'UTC' ),
       cast( systimestamp as timestamp with local time zone)
from dual
/


-------------------
-- Start of script
-------------------

-- 1. Create table
create table abc
(
  id      number generated by default on null as identity,
  epoch   number,
  tsltz   timestamp(0) with local time zone
)
/

create unique index abc_idx on abc (tsltz)
/

-- 2. Query data before insert
with
  function epoch_to_timestamp_tz ( pi_epoch number )
    return timestamp with time zone
  is
  begin
    return timestamp '1970-01-01 00:00:00 UTC' +  NUMTODSINTERVAL( pi_epoch, 'SECOND');
  end epoch_to_timestamp_tz;
  --
  epoch_times as
  ( select 1761436800 as epoch from dual union all
    select 1761437700 from dual union all
    select 1761438600 from dual union all
    select 1761439500 from dual union all
    select 1761440400 from dual union all
    select 1761441300 from dual union all
    select 1761442200 from dual union all
    select 1761443100 from dual
  )
select e.epoch,
       epoch_to_timestamp_tz( e.epoch ) time_in_tstz
from   epoch_times e
/

-- 3. Insert data
insert into abc ( epoch, tsltz )
with
  epoch_times as
  ( select 1761436800 as epoch from dual union all
    select 1761437700 from dual union all
    select 1761438600 from dual union all
    select 1761439500 from dual union all
    select 1761440400 from dual union all
    select 1761441300 from dual union all
    select 1761442200 from dual union all
    select 1761443100 from dual
    )
select e.epoch,
       timestamp '1970-01-01 00:00:00 UTC' +  NUMTODSINTERVAL( e.epoch, 'SECOND') as time_in_tstz
from   epoch_times e
/

-- 4a. Query data
select  id,
        epoch,
        tsltz,
        cast( tsltz as timestamp with time zone) as tstz,
        to_char( cast( tsltz as timestamp with time zone), 'TZD') as tz_dst,  -- time zone displacement (daylight saving time)
        to_char( cast( tsltz as timestamp with time zone), 'TZH:TZM') as tz_offset,  -- time zone offset in hours/minutes (24-hour format)
        tsltz at time zone 'UTC' as tstz_utc,
        sys_extract_utc(tsltz) as extract_utc  -- sys_extract_utc works fine on a timestamp with local time zone column
from    abc
/

-- 4b. Query data - solve sys_extract_utc issue with literal on timestamp with local time zone
select  sys_extract_utc(tsltz) as extract_utc,  -- sys_extract_utc works fine on a timestamp with local time zone column
        cast( timestamp '2025-10-26 00:00:00 UTC' AS timestamp with local time zone) as cast_literal_as_local_tz,  -- we can cast a literal to timestamp with local time zone
        -- sys_extract_utc( cast( timestamp '2025-10-26 00:00:00 UTC' AS timestamp with local time zone))  -- but sys_extract throws an error,  ORA-30175 in 19c (19.29), when used on a literal casted to timestamp with local time zone
        sys_extract_utc( cast( cast( timestamp '2025-10-26 00:00:00 UTC' AS timestamp with local time zone) AS timestamp with time zone)) as cast_literal_extract_utc  -- trick is to cast it explicitly to timestamp with time zone first
from    abc
/

-- 5. Query data filter on tsltz (play with different filters below to see various results)
select  id,
        epoch,
        tsltz,
        cast( tsltz as timestamp with time zone) as tstz,
        to_char( cast( tsltz as timestamp with time zone), 'TZD') as tz_dst,  -- time zone displacement (daylight saving time)
        to_char( cast( tsltz as timestamp with time zone), 'TZH:TZM') as tz_offset,  -- time zone offset in hours/minutes (24-hour format)
        tsltz at time zone 'UTC' as tstz_utc
from    abc
-- where   tsltz = cast( timestamp '2025-10-26 00:00:00 UTC' AS timestamp with local time zone)
-- where   tsltz = cast( timestamp '2025-10-26 01:00:00 UTC' AS timestamp with local time zone)
-- where   tsltz = cast( timestamp '2025-10-26 02:00:00 Europe/Berlin' AS timestamp with local time zone)
-- where   sys_extract_utc(tsltz) = sys_extract_utc( cast( timestamp '2025-10-26 00:00:00 UTC' AS timestamp with local time zone))  -- this should work but throws an ORA-30175 error in 19c (19.29)
where   sys_extract_utc(tsltz) = sys_extract_utc( cast( cast( timestamp '2025-10-26 01:00:00 UTC' AS timestamp with local time zone) AS timestamp with time zone))  -- this workaround works as expected
/

-- 6. Query data filter on tsltz range (from 06:00 to 06:00 next day in Europe/Amsterdam timezone)
select  id,
        epoch,
        tsltz,
        cast( tsltz as timestamp with time zone) as tstz,
        to_char( cast( tsltz as timestamp with time zone), 'TZD') as tz_dst,  -- time zone displacement (daylight saving time)
        to_char( cast( tsltz as timestamp with time zone), 'TZH:TZM') as tz_offset,  -- time zone offset in hours/minutes (24-hour format)
        tsltz at time zone 'UTC' as tstz_utc
from    abc
where   tsltz between cast( timestamp '2025-10-25 06:00:00 Europe/Amsterdam' AS timestamp with local time zone) and cast( timestamp '2025-10-26 06:00:00 Europe/Amsterdam' AS timestamp with local time zone)
/

-- 7. Drop table
drop table abc
/


-------------------
-- End of script
-------------------




--
-- Manual: Set Daylight Saving Time in your OS to OFF (Winter time)
--

-- Display diff between Session Timezone and OS Timezone
select sessiontimezone SESSION_TIME_ZONE,
       current_timestamp,
       to_timestamp_tz(current_timestamp) at time zone 'UTC' current_timestamp_utc,
       TO_CHAR(SYSTIMESTAMP, 'tzr') OPERATING_SYSTEM_TIME_ZONE,
       systimestamp,
       to_timestamp_tz(systimestamp) at time zone 'UTC' systimestamp_utc
from   dual
where  to_timestamp_tz(current_timestamp) at time zone 'UTC' = to_timestamp_tz(systimestamp) at time zone 'UTC'
and    localtimestamp = to_timestamp_tz(systimestamp) at time zone 'Europe/Istanbul'
/

--
-- Manual: Set Daylight Saving Time in your OS to ON (Summer time)
--

-- Display diff between Session Timezone and OS Timezone
select sessiontimezone SESSION_TIME_ZONE,
       current_timestamp,
       TO_CHAR(SYSTIMESTAMP, 'tzr') OPERATING_SYSTEM_TIME_ZONE,
       systimestamp
from   dual
/


------


create table test_tijdzones
  ( col_timestamp           timestamp,
    col_timestamp_tmz       timestamp with time zone,
    col_timestamp_local_tmz timestamp with local time zone
  );

truncate table test_tijdzones
/

-- SESSION Timestamps
insert into test_tijdzones
values
( current_timestamp, current_timestamp, current_timestamp)
/

-- DATABASE Timestamps
insert into test_tijdzones
values
( systimestamp, systimestamp, systimestamp)
/

-- Display Timezone set on the OS
SELECT TO_CHAR(SYSTIMESTAMP, 'tzr') FROM dual
/

select col_timestamp_tmz,
       to_timestamp_tz( col_timestamp_tmz ) at time zone 'Europe/Amsterdam',
       col_timestamp_local_tmz,
       to_timestamp_tz( col_timestamp_local_tmz ) at time zone 'Europe/Amsterdam'
from test_tijdzones
/


select dbtimezone, sessiontimezone  from dual;

select systimestamp from dual;

alter session set time_zone = 'Europe/london'
/

-- DROPPEN van table
drop table test_tijdzones
/

-- Timezone file in use
SELECT * FROM v$timezone_file;

-- Most recent timezone file available
SELECT DBMS_DST.get_latest_timezone_version
FROM   dual
/

-- Available timezone regions in the database
select distinct tzname, tz_offset( tzname)
from   v$timezone_names
order by 1
/

-- Available timezone offsets in the database
select distinct tz_offset( tzname)
from   v$timezone_names
order by to_number( substr(tz_offset( tzname), 1, 3) || substr(tz_offset( tzname), 5, 2))
/

-- Which tables do have columns using timestamp datatype
select * from DBA_TSTZ_TABLES
/

drop table timezone
/

create table timezone ( tswltz  timestamp    with local time zone ,
                        ts0wltz timestamp(0) with local time zone ,
                        ts0wtz  timestamp(0) with time zone
 )
/

SELECT FROM_TZ(TO_TIMESTAMP('01-07-2025 12:00:00,000000', 'DD-MM-YYYY HH24:MI:SS,FF6'), 'UTC')
       AT TIME ZONE '-01:00'

SELECT TO_TIMESTAMP('01-07-2025 12:00:00,000000+01:00', 'DD-MM-YYYY HH24:MI:SS,FF6 TZH:TZM')
FROM dual;

SELECT TO_TIMESTAMP( '01-07-2025 12:00:00,000000 +01:00', 'DD-MM-YYYY HH24:MI:SS,FF6 TZH:TZM')
FROM dual;

select to_timestamp( '01-07-2025 12:00:00 +01:00', 'DD-MM-RRRR HH24:MI:SS TZH:TZM')
from dual
/

insert into timezone ( tswltz, ts0wltz, ts0wtz )
values ( to_timestamp( '01-07-2025 12:00:00,000000', 'DD-MM-RRRR HH24:MI:SS,FF6'),
         to_timestamp( '01-07-2025 12:00:00,000000', 'DD-MM-RRRR HH24:MI:SS,FF6'),
         FROM_TZ(TO_TIMESTAMP('01-07-2025 12:00:00,000000', 'DD-MM-YYYY HH24:MI:SS,FF6'), 'UTC')  AT TIME ZONE '-01:00')
/

SELECT TZ_OFFSET(SESSIONTIMEZONE) FROM DUAL
/

select tswltz tst_tz_local
,      tswltz at time zone 'UTC' tst_tz_utc
,      tswltz at time zone 'Zulu' tst_tz_zulu
,      tswltz at time zone 'Europe/Amsterdam' tst_tz_ams
,      tswltz at time zone 'Africa/Cairo' tst_tz_egp
,      tswltz at time zone '+02:00' tst_tz_0200
,      tswltz at time zone '+03:00' tst_tz_0300
,      tswltz at time zone 'Asia/Kathmandu' tst_tz_Kathmandu
from   timezone
union all
select ts0wltz tst_tz_local
,      ts0wltz at time zone 'UTC' tst_tz_utc
,      ts0wltz at time zone 'Zulu' tst_tz_zulu
,      ts0wltz at time zone 'Europe/Amsterdam' tst_tz_ams
,      ts0wltz at time zone 'Africa/Cairo' tst_tz_egp
,      ts0wltz at time zone '+02:00' tst_tz_0200
,      ts0wltz at time zone '+03:00' tst_tz_0300
,      ts0wltz at time zone 'Asia/Kathmandu' tst_tz_Kathmandu
from   timezone
/

select ts0wltz tst_tz_local
,      ts0wltz at time zone 'UTC' tst_tz_utc
,      ts0wltz at time zone 'Zulu' tst_tz_zulu
,      ts0wltz at time zone 'Europe/Amsterdam' tst_tz_ams
,      ts0wltz at time zone 'Africa/Cairo' tst_tz_egp
,      ts0wltz at time zone '+02:00' tst_tz_0200
,      ts0wltz at time zone 'Asia/Kathmandu' tst_tz_Kathmandu
from   timezone
/

select ts0wtz tst_tz_original
,      ts0wtz at time zone 'UTC' tst_tz_utc
,      ts0wtz at time zone 'Zulu' tst_tz_zulu
,      ts0wtz at time zone 'Europe/Amsterdam' tst_tz_ams
,      ts0wtz at time zone 'Africa/Cairo' tst_tz_egp
,      ts0wtz at time zone '+02:00' tst_tz_0200
,      ts0wtz at time zone 'Asia/Kathmandu' tst_tz_Kathmandu
from   timezone
/

with t_tz_offset as
( select distinct tz_offset( tzname) offset
  from   v$timezone_names
  order by to_number( substr(tz_offset( tzname), 1, 3) || substr(tz_offset( tzname), 5, 2))
)
, t_timestamp_tz as
( select FROM_TZ( TO_TIMESTAMP('01-07-2025 12:00:00,000000', 'DD-MM-YYYY HH24:MI:SS,FF6'), 'UTC')  AT TIME ZONE t.offset as col
  from   t_tz_offset t
)
select t.col
,      t.col at time zone 'UTC' tst_tz_utc
,      t.col at time zone 'Europe/Amsterdam' tst_tz_ams
,      t.col at time zone 'Asia/Kathmandu' tst_tz_Kathmandu
from   t_timestamp_tz t
/




-- standard time -> daylight saving time
-- 30-03-2025

-- daylight saving time -> standard time
-- 26-10-2025

-- 00-04 ophalen

drop table table_abc;

create table table_abc( x timestamp(0) with local time zone, y varchar2(20));

insert into table_abc
with dates as (
  select from_tz( cast( date '2025-03-30' as timestamp(0)), 'UTC')  switch_date from   dual
--  union all
--  select from_tz( cast( date '2025-10-26' as timestamp(0)), 'UTC')  switch_date from   dual
)
, interval_hours as (
  select NUMTODSINTERVAL( level -3 , 'HOUR') interval from dual connect by level <= 6
)
select d.switch_date + i.interval time, 'UTC'
from   dates d
  cross join interval_hours i
order by 1
/

select * from table_abc
/

insert into table_abc
with dates as (
  select from_tz( cast( date '2025-03-30' as timestamp(0)), 'Europe/Amsterdam')  switch_date from   dual
--  union all
--  select from_tz( cast( date '2025-10-26' as timestamp(0)), 'Europe/Amsterdam')  switch_date from   dual
)
, interval_hours as (
  select NUMTODSINTERVAL( level - 1 , 'HOUR') interval from dual connect by level <= 6
)
select d.switch_date + i.interval time, 'Europe/Amsterdam'
from   dates d
  cross join interval_hours i
order by 1
/

insert into table_abc
with dates as (
  select from_tz( cast( date '2025-03-09' as timestamp(0)), 'America/New_York')  switch_date from   dual
--  union all
--  select from_tz( cast( date '2025-10-26' as timestamp(0)), 'Europe/Amsterdam')  switch_date from   dual
)
, interval_hours as (
  select NUMTODSINTERVAL( level - 1 , 'HOUR') interval from dual connect by level <= 6
)
select d.switch_date + i.interval time, 'America/New_York'
from   dates d
  cross join interval_hours i
order by 1
/


select y,
       x at time zone 'UTC' x_utc,
       x at time zone 'Europe/Amsterdam' x_ams,
       x,
       extract( TIMEZONE_REGION from x) as tz_region,
       extract( TIMEZONE_OFFSET from x) as tz_offset,
       --extract( TIMEZONE_ABBR from x) tz_abbr,
       extract( TIMEZONE_HOUR from x) tz_hour,
       extract( TIMEZONE_MINUTE from x) tz_minute
       --, to_char( x, 'HH24:MI:SS TZH') offset
       , to_char( cast( x as timestamp(0) with time zone), 'tzh:tzm') tzh_tzm
       , to_char( cast( x as timestamp(0) with time zone) at time zone 'America/New_York', 'tzh:tzm') tzh_tzm

from table_abc
order by y desc, x
/


select to_char( cast( tswltz as timestamp(0) with time zone), 'tzh:tzm')
from (
  select cast( sysdate as timestamp(0) with local time zone ) as tswltz
  from   dual
)
/

select ggd.ggd_begindatum_ltz,
       ggd.ggd_begindatum_ltz at time zone 'UTC' x_utc,
       ggd.ggd_begindatum_ltz at time zone 'Europe/Amsterdam' x_ams,
       extract( TIMEZONE_REGION from ggd.ggd_begindatum_ltz) as tz_region,
       extract( TIMEZONE_OFFSET from ggd.ggd_begindatum_ltz) as tz_offset,
       extract( TIMEZONE_ABBR from ggd.ggd_begindatum_ltz) tz_abbr,
       to_char( cast( ggd.ggd_begindatum_ltz as timestamp(0) with time zone), 'tzh:tzm') tzh_tzm,
       extract( TIMEZONE_HOUR from ggd.ggd_begindatum_ltz) tz_hour,
       extract( TIMEZONE_MINUTE from ggd.ggd_begindatum_ltz) tz_minute
from fp_data.ggd_gdx_gas_dag ggd
order by ggd.ggd_begindatum_ltz
/


-- Free SQL
select fg_service.pkg_utl_date.epoch_to_date(1743292800)
     , from_tz( cast( fg_service.pkg_utl_date.epoch_to_date(1743292800) as timestamp), 'UTC') tstz
from dual
/