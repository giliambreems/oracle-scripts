-----------------------
--
-- TIMESTAMP WITH TIME ZONE
--
-----------------------

ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = 'DD-MM-YYYY HH24:MI:SSXFF TZR'
/

SELECT 'TIMESTAMP(0)' as datatype, TO_TIMESTAMP_TZ('2023-01-01 12:00:00 UTC', 'YYYY-MM-DD HH24:MI:SS TZR') as timestamp_value from dual union all
SELECT 'TIMESTAMP(1)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1 UTC', 'YYYY-MM-DD HH24:MI:SS.FF1 TZR') from dual union all
SELECT 'TIMESTAMP(2)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12 UTC', 'YYYY-MM-DD HH24:MI:SS.FF2 TZR') from dual union all
SELECT 'TIMESTAMP(3)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123 UTC', 'YYYY-MM-DD HH24:MI:SS.FF3 TZR') from dual union all
SELECT 'TIMESTAMP(4)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234 UTC', 'YYYY-MM-DD HH24:MI:SS.FF4 TZR') from dual union all
SELECT 'TIMESTAMP(5)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345 UTC', 'YYYY-MM-DD HH24:MI:SS.FF5 TZR') from dual union all
SELECT 'TIMESTAMP(6)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456 UTC', 'YYYY-MM-DD HH24:MI:SS.FF6 TZR ') from dual union all
SELECT 'TIMESTAMP(7)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234567 UTC', 'YYYY-MM-DD HH24:MI:SS.FF7 TZR') from dual union all
SELECT 'TIMESTAMP(8)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345678 UTC', 'YYYY-MM-DD HH24:MI:SS.FF8 TZR') from dual union all
SELECT 'TIMESTAMP(9)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456789 UTC', 'YYYY-MM-DD HH24:MI:SS.FF9 TZR') from dual
/

ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = 'DD-MM-YYYY HH24:MI:SSXFF3 TZR'
/

SELECT 'TIMESTAMP(0)' as datatype, TO_TIMESTAMP_TZ('2023-01-01 12:00:00 UTC', 'YYYY-MM-DD HH24:MI:SS TZR') as timestamp_value from dual union all
SELECT 'TIMESTAMP(1)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1 UTC', 'YYYY-MM-DD HH24:MI:SS.FF1 TZR') from dual union all
SELECT 'TIMESTAMP(2)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12 UTC', 'YYYY-MM-DD HH24:MI:SS.FF2 TZR') from dual union all
SELECT 'TIMESTAMP(3)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123 UTC', 'YYYY-MM-DD HH24:MI:SS.FF3 TZR') from dual union all
SELECT 'TIMESTAMP(4)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234 UTC', 'YYYY-MM-DD HH24:MI:SS.FF4 TZR') from dual union all
SELECT 'TIMESTAMP(5)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345 UTC', 'YYYY-MM-DD HH24:MI:SS.FF5 TZR') from dual union all
SELECT 'TIMESTAMP(6)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456 UTC', 'YYYY-MM-DD HH24:MI:SS.FF6 TZR ') from dual union all
SELECT 'TIMESTAMP(7)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234567 UTC', 'YYYY-MM-DD HH24:MI:SS.FF7 TZR') from dual union all
SELECT 'TIMESTAMP(8)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345678 UTC', 'YYYY-MM-DD HH24:MI:SS.FF8 TZR') from dual union all
SELECT 'TIMESTAMP(9)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456789 UTC', 'YYYY-MM-DD HH24:MI:SS.FF9 TZR') from dual
/

ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = 'DD-MM-YYYY HH24:MI:SSXFF6 TZR'
/

SELECT 'TIMESTAMP(0)' as datatype, TO_TIMESTAMP_TZ('2023-01-01 12:00:00 UTC', 'YYYY-MM-DD HH24:MI:SS TZR') as timestamp_value from dual union all
SELECT 'TIMESTAMP(1)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1 UTC', 'YYYY-MM-DD HH24:MI:SS.FF1 TZR') from dual union all
SELECT 'TIMESTAMP(2)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12 UTC', 'YYYY-MM-DD HH24:MI:SS.FF2 TZR') from dual union all
SELECT 'TIMESTAMP(3)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123 UTC', 'YYYY-MM-DD HH24:MI:SS.FF3 TZR') from dual union all
SELECT 'TIMESTAMP(4)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234 UTC', 'YYYY-MM-DD HH24:MI:SS.FF4 TZR') from dual union all
SELECT 'TIMESTAMP(5)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345 UTC', 'YYYY-MM-DD HH24:MI:SS.FF5 TZR') from dual union all
SELECT 'TIMESTAMP(6)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456 UTC', 'YYYY-MM-DD HH24:MI:SS.FF6 TZR') from dual union all
SELECT 'TIMESTAMP(7)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234567 UTC', 'YYYY-MM-DD HH24:MI:SS.FF7 TZR') from dual union all
SELECT 'TIMESTAMP(8)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345678 UTC', 'YYYY-MM-DD HH24:MI:SS.FF8 TZR') from dual union all
SELECT 'TIMESTAMP(9)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456789 UTC', 'YYYY-MM-DD HH24:MI:SS.FF9 TZR') from dual
/

ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = 'DD-MM-YYYY HH24:MI:SSXFF9 TZR'
/

SELECT 'TIMESTAMP(0)' as datatype, TO_TIMESTAMP_TZ('2023-01-01 12:00:00 UTC', 'YYYY-MM-DD HH24:MI:SS TZR') as timestamp_value from dual union all
SELECT 'TIMESTAMP(1)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1 UTC', 'YYYY-MM-DD HH24:MI:SS.FF1 TZR') from dual union all
SELECT 'TIMESTAMP(2)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12 UTC', 'YYYY-MM-DD HH24:MI:SS.FF2 TZR') from dual union all
SELECT 'TIMESTAMP(3)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123 UTC', 'YYYY-MM-DD HH24:MI:SS.FF3 TZR') from dual union all
SELECT 'TIMESTAMP(4)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234 UTC', 'YYYY-MM-DD HH24:MI:SS.FF4 TZR') from dual union all
SELECT 'TIMESTAMP(5)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345 UTC', 'YYYY-MM-DD HH24:MI:SS.FF5 TZR') from dual union all
SELECT 'TIMESTAMP(6)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456 UTC', 'YYYY-MM-DD HH24:MI:SS.FF6 TZR') from dual union all
SELECT 'TIMESTAMP(7)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234567 UTC', 'YYYY-MM-DD HH24:MI:SS.FF7 TZR') from dual union all
SELECT 'TIMESTAMP(8)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345678 UTC', 'YYYY-MM-DD HH24:MI:SS.FF8 TZR') from dual union all
SELECT 'TIMESTAMP(9)', TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456789 UTC', 'YYYY-MM-DD HH24:MI:SS.FF9 TZR') from dual
/


-----------------------
--
-- TIMESTAMP
--
-- 1) Setup
--
-----------------------

ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = 'DD-MM-YYYY HH24:MI:SSXFF TZR'
/

drop table b
/

create table b (
  timestamp_0_tz timestamp(0) with time zone,
  timestamp_1_tz timestamp(1) with time zone,
  timestamp_2_tz timestamp(2) with time zone,
  timestamp_3_tz timestamp(3) with time zone,
  timestamp_4_tz timestamp(4) with time zone,
  timestamp_5_tz timestamp(5) with time zone,
  timestamp_6_tz timestamp(6) with time zone,
  timestamp_7_tz timestamp(7) with time zone,
  timestamp_8_tz timestamp(8) with time zone,
  timestamp_9_tz timestamp(9) with time zone
)
/

-----------------------
--
-- TIMESTAMP
--
-- 2a) Insert data
--
-----------------------

INSERT INTO b (
  timestamp_0_tz,
  timestamp_1_tz,
  timestamp_2_tz,
  timestamp_3_tz,
  timestamp_4_tz,
  timestamp_5_tz,
  timestamp_6_tz,
  timestamp_7_tz,
  timestamp_8_tz,
  timestamp_9_tz
) VALUES (
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00 Europe/Oslo', 'YYYY-MM-DD HH24:MI:SS TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1 Europe/Oslo', 'YYYY-MM-DD HH24:MI:SS.FF1 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12 Europe/Oslo', 'YYYY-MM-DD HH24:MI:SS.FF2 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123 Europe/Oslo', 'YYYY-MM-DD HH24:MI:SS.FF3 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234 Europe/Oslo', 'YYYY-MM-DD HH24:MI:SS.FF4 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345 Europe/Oslo', 'YYYY-MM-DD HH24:MI:SS.FF5 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456 Europe/Oslo', 'YYYY-MM-DD HH24:MI:SS.FF6 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234567 Europe/Oslo', 'YYYY-MM-DD HH24:MI:SS.FF7 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345678 Europe/Oslo', 'YYYY-MM-DD HH24:MI:SS.FF8 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456789 Europe/Oslo', 'YYYY-MM-DD HH24:MI:SS.FF9 TZR')
)
/

----------------------
--
-- TIMESTAMP
--
-- 2b) Insert data
--
-----------------------

INSERT INTO b (
  timestamp_0_tz,
  timestamp_1_tz,
  timestamp_2_tz,
  timestamp_3_tz,
  timestamp_4_tz,
  timestamp_5_tz,
  timestamp_6_tz,
  timestamp_7_tz,
  timestamp_8_tz,
  timestamp_9_tz
) VALUES (
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00 America/New_York', 'YYYY-MM-DD HH24:MI:SS TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1 America/New_York', 'YYYY-MM-DD HH24:MI:SS.FF1 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12 America/New_York', 'YYYY-MM-DD HH24:MI:SS.FF2 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123 America/New_York', 'YYYY-MM-DD HH24:MI:SS.FF3 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234 America/New_York', 'YYYY-MM-DD HH24:MI:SS.FF4 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345 America/New_York', 'YYYY-MM-DD HH24:MI:SS.FF5 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456 America/New_York', 'YYYY-MM-DD HH24:MI:SS.FF6 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.1234567 America/New_York', 'YYYY-MM-DD HH24:MI:SS.FF7 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.12345678 America/New_York', 'YYYY-MM-DD HH24:MI:SS.FF8 TZR'),
  TO_TIMESTAMP_TZ('2023-01-01 12:00:00.123456789 America/New_York', 'YYYY-MM-DD HH24:MI:SS.FF9 TZR')
)
/

-----------------------
--
-- TIMESTAMP
--
-- 2c) Insert data
--
-----------------------

INSERT INTO b (
  timestamp_0_tz,
  timestamp_1_tz,
  timestamp_2_tz,
  timestamp_3_tz,
  timestamp_4_tz,
  timestamp_5_tz,
  timestamp_6_tz,
  timestamp_7_tz,
  timestamp_8_tz,
  timestamp_9_tz
)
select 
  TIMESTAMP '2023-01-01 12:00:00 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.1 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.12 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.1234 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.12345 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123456 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.1234567 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.12345678 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123456789 Europe/Oslo'
from dual
/

------------------------
--
-- TIMESTAMP
--
-- 2d) Insert data
--
-----------------------

-
-- THIS ONE GOES WRONG AS OF TIMESTAMP(4) !!!
--
INSERT INTO b (
  timestamp_0_tz,
  timestamp_1_tz,
  timestamp_2_tz,
  timestamp_3_tz,
  timestamp_4_tz,
  timestamp_5_tz,
  timestamp_6_tz,
  timestamp_7_tz,
  timestamp_8_tz,
  timestamp_9_tz
) VALUES (
  TIMESTAMP '2023-01-01 12:00:00 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123456 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123456 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123456 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123456789 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123456789 Europe/Oslo',
  TIMESTAMP '2023-01-01 12:00:00.123456789 Europe/Oslo'
)
/



commit
/


-----------------------
--
-- TIMESTAMP
--
-- 3) Query the data
--
-----------------------
select timestamp_0_tz,
       timestamp_1_tz at time zone 'Europe/London',
       timestamp_2_tz,
       timestamp_3_tz,
       timestamp_4_tz,
       timestamp_5_tz,
       timestamp_6_tz,
       timestamp_7_tz,
       timestamp_8_tz,
       timestamp_9_tz
from   b
/

select to_char(b.timestamp_0_tz, 'YYYY-MM-DD HH24:MI:SS TZR')     as timestamp_0_tz,
       to_char(b.timestamp_1_tz, 'YYYY-MM-DD HH24:MI:SS.FF3 TZR') as timestamp_1_tz,
       to_char(b.timestamp_2_tz, 'YYYY-MM-DD HH24:MI:SS.FF3 TZR') as timestamp_2_tz,
       to_char(b.timestamp_3_tz, 'YYYY-MM-DD HH24:MI:SS.FF3 TZR') as timestamp_3_tz,
       to_char(b.timestamp_4_tz, 'YYYY-MM-DD HH24:MI:SS.FF6 TZR') as timestamp_4_tz,
       to_char(b.timestamp_5_tz, 'YYYY-MM-DD HH24:MI:SS.FF6 TZR') as timestamp_5_tz,
       to_char(b.timestamp_6_tz, 'YYYY-MM-DD HH24:MI:SS.FF6 TZR') as timestamp_6_tz,
       to_char(b.timestamp_7_tz, 'YYYY-MM-DD HH24:MI:SS.FF9 TZR') as timestamp_7_tz,
       to_char(b.timestamp_8_tz, 'YYYY-MM-DD HH24:MI:SS.FF9 TZR') as timestamp_8_tz,
       to_char(b.timestamp_9_tz, 'YYYY-MM-DD HH24:MI:SS.FF9 TZR') as timestamp_9_tz
from   b
/

SELECT column_name, formatted_value
FROM (
  SELECT TO_CHAR(b.timestamp_0_tz, 'YYYY-MM-DD HH24:MI:SS TZR')     AS timestamp_0_tz,
         TO_CHAR(b.timestamp_1_tz, 'YYYY-MM-DD HH24:MI:SS.FF1 TZR') AS timestamp_1_tz,
         TO_CHAR(b.timestamp_2_tz, 'YYYY-MM-DD HH24:MI:SS.FF2 TZR') AS timestamp_2_tz,
         TO_CHAR(b.timestamp_3_tz, 'YYYY-MM-DD HH24:MI:SS.FF3 TZR') AS timestamp_3_tz,
         TO_CHAR(b.timestamp_4_tz, 'YYYY-MM-DD HH24:MI:SS.FF4 TZR') AS timestamp_4_tz,
         TO_CHAR(b.timestamp_5_tz, 'YYYY-MM-DD HH24:MI:SS.FF5 TZR') AS timestamp_5_tz,
         TO_CHAR(b.timestamp_6_tz, 'YYYY-MM-DD HH24:MI:SS.FF6 TZR') AS timestamp_6_tz,
         TO_CHAR(b.timestamp_7_tz, 'YYYY-MM-DD HH24:MI:SS.FF7 TZR') AS timestamp_7_tz,
         TO_CHAR(b.timestamp_8_tz, 'YYYY-MM-DD HH24:MI:SS.FF8 TZR') AS timestamp_8_tz,
         TO_CHAR(b.timestamp_9_tz, 'YYYY-MM-DD HH24:MI:SS.FF9 TZR') AS timestamp_9_tz
  FROM   b
)
UNPIVOT (
  formatted_value FOR column_name IN (timestamp_0_tz, timestamp_1_tz, timestamp_2_tz, timestamp_3_tz, timestamp_4_tz, timestamp_5_tz, timestamp_6_tz, timestamp_7_tz, timestamp_8_tz, timestamp_9_tz)
)
/