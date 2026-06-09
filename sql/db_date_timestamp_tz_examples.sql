select to_date(         '2025-01-01'                    default null on conversion error, 'YYYY-MM-DD')
,      to_date(         '2025-01-01T13:12:11'           default null on conversion error, 'YYYY-MM-DD"T"HH24:MI:SS')
,      to_timestamp(    '2025-01-01T13:12:11'           default null on conversion error, 'YYYY-MM-DD"T"HH24:MI:SS')
,      to_timestamp(    '2025-01-01T13:12:11.123'       default null on conversion error, 'YYYY-MM-DD"T"HH24:MI:SS.FF3')
,      to_timestamp(    '2025-01-01T13:12:11.123456'    default null on conversion error, 'YYYY-MM-DD"T"HH24:MI:SS.FF6')
,      to_timestamp(    '2025-01-01T13:12:11.123456789' default null on conversion error, 'YYYY-MM-DD"T"HH24:MI:SS.FF9')
,      to_timestamp_tz( '2025-01-01T13:12:11'           default null on conversion error, 'YYYY-MM-DD"T"HH24:MI:SS') -- adds server/local? timezone
,      to_timestamp_tz( '2025-01-01T13:12:11+01:00'     default null on conversion error, 'YYYY-MM-DD"T"HH24:MI:SS TZH:TZM')
,      to_timestamp_tz( '2025-01-01T13:12:11.123+01:00' default null on conversion error, 'YYYY-MM-DD"T"HH24:MI:SS.FF3 TZH:TZM')
from dual
/
