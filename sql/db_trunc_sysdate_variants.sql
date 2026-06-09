select sysdate peildatum,
       trunc( sysdate, 'YEAR')  first_day_of_year,
       trunc( sysdate, 'yyyy')  first_day_of_year_2,
       trunc( sysdate, 'MONTH') first_day_of_month,
       trunc( sysdate, 'mm')    first_day_of_month_2,
       trunc( sysdate, 'DAY')   first_day_of_week,
       trunc( sysdate, 'iw')    first_day_of_week_2,
       trunc( sysdate)          trunc_on_day,
       trunc( sysdate, 'hh24')  trunc_on_hour,
       trunc( sysdate, 'mi')    trunc_on_minute
from dual
/

