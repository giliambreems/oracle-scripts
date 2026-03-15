-----------------------
--
-- TIMESTAMP
--
-----------------------

ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD-MM-YYYY HH24:MI:SSXFF'
/

SELECT 'TIMESTAMP(0)' as datatype, TO_TIMESTAMP('2023-01-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS') as timestamp_value from dual union all
SELECT 'TIMESTAMP(1)', TO_TIMESTAMP('2023-01-01 12:00:00.1', 'YYYY-MM-DD HH24:MI:SS.FF1') from dual union all
SELECT 'TIMESTAMP(2)', TO_TIMESTAMP('2023-01-01 12:00:00.12', 'YYYY-MM-DD HH24:MI:SS.FF2') from dual union all
SELECT 'TIMESTAMP(3)', TO_TIMESTAMP('2023-01-01 12:00:00.123', 'YYYY-MM-DD HH24:MI:SS.FF3') from dual union all
SELECT 'TIMESTAMP(4)', TO_TIMESTAMP('2023-01-01 12:00:00.1234', 'YYYY-MM-DD HH24:MI:SS.FF4') from dual union all
SELECT 'TIMESTAMP(5)', TO_TIMESTAMP('2023-01-01 12:00:00.12345', 'YYYY-MM-DD HH24:MI:SS.FF5') from dual union all
SELECT 'TIMESTAMP(6)', TO_TIMESTAMP('2023-01-01 12:00:00.123456', 'YYYY-MM-DD HH24:MI:SS.FF6') from dual union all
SELECT 'TIMESTAMP(7)', TO_TIMESTAMP('2023-01-01 12:00:00.1234567', 'YYYY-MM-DD HH24:MI:SS.FF7') from dual union all
SELECT 'TIMESTAMP(8)', TO_TIMESTAMP('2023-01-01 12:00:00.12345678', 'YYYY-MM-DD HH24:MI:SS.FF8') from dual union all
SELECT 'TIMESTAMP(9)', TO_TIMESTAMP('2023-01-01 12:00:00.123456789', 'YYYY-MM-DD HH24:MI:SS.FF9') from dual
/

ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD-MM-YYYY HH24:MI:SSXFF3'
/

SELECT 'TIMESTAMP(0)' as datatype, TO_TIMESTAMP('2023-01-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS') as timestamp_value from dual union all
SELECT 'TIMESTAMP(1)', TO_TIMESTAMP('2023-01-01 12:00:00.1', 'YYYY-MM-DD HH24:MI:SS.FF1') from dual union all
SELECT 'TIMESTAMP(2)', TO_TIMESTAMP('2023-01-01 12:00:00.12', 'YYYY-MM-DD HH24:MI:SS.FF2') from dual union all
SELECT 'TIMESTAMP(3)', TO_TIMESTAMP('2023-01-01 12:00:00.123', 'YYYY-MM-DD HH24:MI:SS.FF3') from dual union all
SELECT 'TIMESTAMP(4)', TO_TIMESTAMP('2023-01-01 12:00:00.1234', 'YYYY-MM-DD HH24:MI:SS.FF4') from dual union all
SELECT 'TIMESTAMP(5)', TO_TIMESTAMP('2023-01-01 12:00:00.12345', 'YYYY-MM-DD HH24:MI:SS.FF5') from dual union all
SELECT 'TIMESTAMP(6)', TO_TIMESTAMP('2023-01-01 12:00:00.123456', 'YYYY-MM-DD HH24:MI:SS.FF6') from dual union all
SELECT 'TIMESTAMP(7)', TO_TIMESTAMP('2023-01-01 12:00:00.1234567', 'YYYY-MM-DD HH24:MI:SS.FF7') from dual union all
SELECT 'TIMESTAMP(8)', TO_TIMESTAMP('2023-01-01 12:00:00.12345678', 'YYYY-MM-DD HH24:MI:SS.FF8') from dual union all
SELECT 'TIMESTAMP(9)', TO_TIMESTAMP('2023-01-01 12:00:00.123456789', 'YYYY-MM-DD HH24:MI:SS.FF9') from dual
/

ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD-MM-YYYY HH24:MI:SSXFF6'
/

SELECT 'TIMESTAMP(0)' as datatype, TO_TIMESTAMP('2023-01-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS') as timestamp_value from dual union all
SELECT 'TIMESTAMP(1)', TO_TIMESTAMP('2023-01-01 12:00:00.1', 'YYYY-MM-DD HH24:MI:SS.FF1') from dual union all
SELECT 'TIMESTAMP(2)', TO_TIMESTAMP('2023-01-01 12:00:00.12', 'YYYY-MM-DD HH24:MI:SS.FF2') from dual union all
SELECT 'TIMESTAMP(3)', TO_TIMESTAMP('2023-01-01 12:00:00.123', 'YYYY-MM-DD HH24:MI:SS.FF3') from dual union all
SELECT 'TIMESTAMP(4)', TO_TIMESTAMP('2023-01-01 12:00:00.1234', 'YYYY-MM-DD HH24:MI:SS.FF4') from dual union all
SELECT 'TIMESTAMP(5)', TO_TIMESTAMP('2023-01-01 12:00:00.12345', 'YYYY-MM-DD HH24:MI:SS.FF5') from dual union all
SELECT 'TIMESTAMP(6)', TO_TIMESTAMP('2023-01-01 12:00:00.123456', 'YYYY-MM-DD HH24:MI:SS.FF6') from dual union all
SELECT 'TIMESTAMP(7)', TO_TIMESTAMP('2023-01-01 12:00:00.1234567', 'YYYY-MM-DD HH24:MI:SS.FF7') from dual union all
SELECT 'TIMESTAMP(8)', TO_TIMESTAMP('2023-01-01 12:00:00.12345678', 'YYYY-MM-DD HH24:MI:SS.FF8') from dual union all
SELECT 'TIMESTAMP(9)', TO_TIMESTAMP('2023-01-01 12:00:00.123456789', 'YYYY-MM-DD HH24:MI:SS.FF9') from dual
/

ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD-MM-YYYY HH24:MI:SSXFF9'
/

SELECT 'TIMESTAMP(0)' as datatype, TO_TIMESTAMP('2023-01-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS') as timestamp_value from dual union all
SELECT 'TIMESTAMP(1)', TO_TIMESTAMP('2023-01-01 12:00:00.1', 'YYYY-MM-DD HH24:MI:SS.FF1') from dual union all
SELECT 'TIMESTAMP(2)', TO_TIMESTAMP('2023-01-01 12:00:00.12', 'YYYY-MM-DD HH24:MI:SS.FF2') from dual union all
SELECT 'TIMESTAMP(3)', TO_TIMESTAMP('2023-01-01 12:00:00.123', 'YYYY-MM-DD HH24:MI:SS.FF3') from dual union all
SELECT 'TIMESTAMP(4)', TO_TIMESTAMP('2023-01-01 12:00:00.1234', 'YYYY-MM-DD HH24:MI:SS.FF4') from dual union all
SELECT 'TIMESTAMP(5)', TO_TIMESTAMP('2023-01-01 12:00:00.12345', 'YYYY-MM-DD HH24:MI:SS.FF5') from dual union all
SELECT 'TIMESTAMP(6)', TO_TIMESTAMP('2023-01-01 12:00:00.123456', 'YYYY-MM-DD HH24:MI:SS.FF6') from dual union all
SELECT 'TIMESTAMP(7)', TO_TIMESTAMP('2023-01-01 12:00:00.1234567', 'YYYY-MM-DD HH24:MI:SS.FF7') from dual union all
SELECT 'TIMESTAMP(8)', TO_TIMESTAMP('2023-01-01 12:00:00.12345678', 'YYYY-MM-DD HH24:MI:SS.FF8') from dual union all
SELECT 'TIMESTAMP(9)', TO_TIMESTAMP('2023-01-01 12:00:00.123456789', 'YYYY-MM-DD HH24:MI:SS.FF9') from dual
/

drop table a
/

create table a (
  timestamp_0 timestamp(0),
  timestamp_1 timestamp(1),
  timestamp_2 timestamp(2),
  timestamp_3 timestamp(3),
  timestamp_4 timestamp(4),
  timestamp_5 timestamp(5),
  timestamp_6 timestamp(6),
  timestamp_7 timestamp(7),
  timestamp_8 timestamp(8),
  timestamp_9 timestamp(9)
)
/

INSERT INTO a (
  timestamp_0,
  timestamp_1,
  timestamp_2,
  timestamp_3,
  timestamp_4,
  timestamp_5,
  timestamp_6,
  timestamp_7,
  timestamp_8,
  timestamp_9
) VALUES (
  TO_TIMESTAMP('2023-01-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'),
  TO_TIMESTAMP('2023-01-01 12:00:00.1', 'YYYY-MM-DD HH24:MI:SS.FF1'),
  TO_TIMESTAMP('2023-01-01 12:00:00.12', 'YYYY-MM-DD HH24:MI:SS.FF2'),
  TO_TIMESTAMP('2023-01-01 12:00:00.123', 'YYYY-MM-DD HH24:MI:SS.FF3'),
  TO_TIMESTAMP('2023-01-01 12:00:00.1234', 'YYYY-MM-DD HH24:MI:SS.FF4'),
  TO_TIMESTAMP('2023-01-01 12:00:00.12345', 'YYYY-MM-DD HH24:MI:SS.FF5'),
  TO_TIMESTAMP('2023-01-01 12:00:00.123456', 'YYYY-MM-DD HH24:MI:SS.FF6'),
  TO_TIMESTAMP('2023-01-01 12:00:00.1234567', 'YYYY-MM-DD HH24:MI:SS.FF7'),
  TO_TIMESTAMP('2023-01-01 12:00:00.12345678', 'YYYY-MM-DD HH24:MI:SS.FF8'),
  TO_TIMESTAMP('2023-01-01 12:00:00.123456789', 'YYYY-MM-DD HH24:MI:SS.FF9')
)
/

ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD-MM-YYYY HH24:MI:SSXFF'
/

-- THIS ONE GOES WRONG AS OF TIMESTAMP(4) !!!
INSERT INTO a (
  timestamp_0,
  timestamp_1,
  timestamp_2,
  timestamp_3,
  timestamp_4,
  timestamp_5,
  timestamp_6,
  timestamp_7,
  timestamp_8,
  timestamp_9
) VALUES (
  TIMESTAMP '2023-01-01 12:00:00',
  TIMESTAMP '2023-01-01 12:00:00.123',
  TIMESTAMP '2023-01-01 12:00:00.123',
  TIMESTAMP '2023-01-01 12:00:00.123',
  TIMESTAMP '2023-01-01 12:00:00.123456',
  TIMESTAMP '2023-01-01 12:00:00.123456',
  TIMESTAMP '2023-01-01 12:00:00.123456',
  TIMESTAMP '2023-01-01 12:00:00.123456789',
  TIMESTAMP '2023-01-01 12:00:00.123456789',
  TIMESTAMP '2023-01-01 12:00:00.123456789'
)
/


INSERT INTO a (
  timestamp_0,
  timestamp_1,
  timestamp_2,
  timestamp_3,
  timestamp_4,
  timestamp_5,
  timestamp_6,
  timestamp_7,
  timestamp_8,
  timestamp_9
)
select 
  TIMESTAMP '2023-01-01 12:00:00',
  TIMESTAMP '2023-01-01 12:00:00.1',
  TIMESTAMP '2023-01-01 12:00:00.12',
  TIMESTAMP '2023-01-01 12:00:00.123',
  TIMESTAMP '2023-01-01 12:00:00.1234',
  TIMESTAMP '2023-01-01 12:00:00.12345',
  TIMESTAMP '2023-01-01 12:00:00.123456',
  TIMESTAMP '2023-01-01 12:00:00.1234567',
  TIMESTAMP '2023-01-01 12:00:00.12345678',
  TIMESTAMP '2023-01-01 12:00:00.123456789'
from dual
/
  
select timestamp_0,
       timestamp_1,
       timestamp_2,
       timestamp_3,
       timestamp_4,
       timestamp_5,
       timestamp_6,
       timestamp_7,
       timestamp_8,
       timestamp_9
from   a
/

select to_char(a.timestamp_0, 'YYYY-MM-DD HH24:MI:SS')     as timestamp_0,
       to_char(a.timestamp_1, 'YYYY-MM-DD HH24:MI:SS.FF3') as timestamp_1,
       to_char(a.timestamp_2, 'YYYY-MM-DD HH24:MI:SS.FF3') as timestamp_2,
       to_char(a.timestamp_3, 'YYYY-MM-DD HH24:MI:SS.FF3') as timestamp_3,
       to_char(a.timestamp_4, 'YYYY-MM-DD HH24:MI:SS.FF6') as timestamp_4,
       to_char(a.timestamp_5, 'YYYY-MM-DD HH24:MI:SS.FF6') as timestamp_5,
       to_char(a.timestamp_6, 'YYYY-MM-DD HH24:MI:SS.FF6') as timestamp_6,
       to_char(a.timestamp_7, 'YYYY-MM-DD HH24:MI:SS.FF9') as timestamp_7,
       to_char(a.timestamp_8, 'YYYY-MM-DD HH24:MI:SS.FF9') as timestamp_8,
       to_char(a.timestamp_9, 'YYYY-MM-DD HH24:MI:SS.FF9') as timestamp_9
from   a
/

commit
/
