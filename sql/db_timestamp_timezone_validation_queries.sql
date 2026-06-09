--
-- 1a. Validates the hours in a day for a specific time zone (Including DST)
--
SELECT
    d.ggd_id,

    /* Gas-day start/end in NL time */
    d.ggd_begindatum_ltz AT TIME ZONE 'Europe/Amsterdam' AS gasdag_start_nl,
    d.ggd_einddatum_ltz  AT TIME ZONE 'Europe/Amsterdam' AS gasdag_eind_nl,

    COUNT(o.ggo_id) AS uur_aantal,

    EXTRACT   ( DAY  FROM FROM_TZ(CAST(d.ggd_einddatum_ltz AS TIMESTAMP), 'Europe/Amsterdam') - FROM_TZ(CAST(d.ggd_begindatum_ltz AS TIMESTAMP), 'Europe/Amsterdam')) * 24
    + EXTRACT ( HOUR FROM FROM_TZ(CAST(d.ggd_einddatum_ltz AS TIMESTAMP), 'Europe/Amsterdam') - FROM_TZ(CAST(d.ggd_begindatum_ltz AS TIMESTAMP), 'Europe/Amsterdam'))       as werkelijke_uren
FROM FP_DATA.ggd_gdx_gas_dag d
LEFT JOIN FP_DATA.ggo_gdx_gas_opname o
    ON o.ggo_ggd_id = d.ggd_id
GROUP BY
    d.ggd_id,
    d.ggd_begindatum_ltz,
    d.ggd_einddatum_ltz
ORDER BY gasdag_start_nl
/


--
-- 1b. Query to validate the hours in a day for a specific time zone (Including DST) (Potential issues and DST days only)
--
SELECT *
FROM (
    SELECT
        d.ggd_id,

        /* Gas-day start/end in NL time */
        d.ggd_begindatum_ltz AT TIME ZONE 'Europe/Amsterdam' AS gasdag_start_nl,
        d.ggd_einddatum_ltz  AT TIME ZONE 'Europe/Amsterdam' AS gasdag_eind_nl,

        COUNT(o.ggo_id) AS uur_aantal,

        EXTRACT   ( DAY  FROM FROM_TZ(CAST(d.ggd_einddatum_ltz AS TIMESTAMP), 'Europe/Amsterdam') - FROM_TZ(CAST(d.ggd_begindatum_ltz AS TIMESTAMP), 'Europe/Amsterdam')) * 24
        + EXTRACT ( HOUR FROM FROM_TZ(CAST(d.ggd_einddatum_ltz AS TIMESTAMP), 'Europe/Amsterdam') - FROM_TZ(CAST(d.ggd_begindatum_ltz AS TIMESTAMP), 'Europe/Amsterdam'))       as werkelijke_uren
    FROM FP_DATA.ggd_gdx_gas_dag d
    LEFT JOIN FP_DATA.ggo_gdx_gas_opname o
        ON o.ggo_ggd_id = d.ggd_id
    GROUP BY
        d.ggd_id,
        d.ggd_begindatum_ltz,
        d.ggd_einddatum_ltz
    )
WHERE uur_aantal <> werkelijke_uren
   OR werkelijke_uren <> 24
ORDER BY ggd_id
/


--
-- 2. Validates the amount of days for each month
--
SELECT
    m.ggm_id,
    m.ggm_jaar_maand,
    COUNT(d.ggd_id) AS gasdag_aantal,
    (
      CAST(
        (m.ggm_einddatum_ltz  AT TIME ZONE 'Europe/Amsterdam') - INTERVAL '6' HOUR
        AS DATE
      )
      -
      CAST(
        (m.ggm_begindatum_ltz AT TIME ZONE 'Europe/Amsterdam') - INTERVAL '6' HOUR
        AS DATE
      )
    ) AS werkelijke_gasdagen
FROM FP_DATA.ggm_gdx_gas_maand m
LEFT JOIN FP_DATA.ggd_gdx_gas_dag d
    ON d.ggd_ggm_id = m.ggm_id
GROUP BY
    m.ggm_id,
    m.ggm_jaar_maand,
    m.ggm_begindatum_ltz,
    m.ggm_einddatum_ltz
ORDER BY m.ggm_jaar_maand
/


--
-- 3. Query to check if the hour data refers to the corresponding day data
--
SELECT
    o.ggo_id,
    o.ggo_begindatum_ltz AT TIME ZONE 'Europe/Amsterdam' AS uur_start_nl,
    o.ggo_einddatum_ltz  AT TIME ZONE 'Europe/Amsterdam' AS uur_eind_nl,
    d.ggd_begindatum_ltz AT TIME ZONE 'Europe/Amsterdam' AS gasdag_start_nl,
    d.ggd_einddatum_ltz  AT TIME ZONE 'Europe/Amsterdam' AS gasdag_eind_nl
FROM FP_DATA.ggo_gdx_gas_opname o
JOIN FP_DATA.ggd_gdx_gas_dag d
    ON o.ggo_ggd_id = d.ggd_id
WHERE o.ggo_begindatum_ltz < d.ggd_begindatum_ltz
   OR o.ggo_einddatum_ltz  > d.ggd_einddatum_ltz;



-------

-- Canonical day -> Always calculate with the 6 hour clock-wall when using Wholesale Gas Data
select CAST(
  CAST( timestamp '2026-03-29 06:00:00 EUROPE/AMSTERDAM' AT TIME ZONE 'Europe/Amsterdam' AS DATE)
  - INTERVAL '6' HOUR
  AS DATE
)
from dual
/

-- Check with Oracle why!? 1) timestamp with time zone knows about DST and while 2) a pure timestamp doesn't know.
select       timestamp '2026-03-29 06:00:00 EUROPE/AMSTERDAM'                  - trunc(      timestamp '2026-03-29 06:00:00 EUROPE/AMSTERDAM'                 )  -- TSTZ knows about DST and the shift here, so the difference is 5 hours
,       cast(timestamp '2026-03-29 06:00:00 EUROPE/AMSTERDAM' as timestamp(0)) - trunc( cast(timestamp '2026-03-29 06:00:00 EUROPE/AMSTERDAM' as timestamp(0)))  -- TS doesn't know about DST and the shift here, so the difference is 6 hours
from dual
/


-- Strange/weird behaviour
declare

pi_begindatum_tz timestamp(0) with time zone default timestamp '2026-03-29 06:00:00.123 EUROPE/AMSTERDAM';
--pi_begindatum_tz timestamp(0) with time zone default timestamp '2026-10-25 06:00:00.123 EUROPE/AMSTERDAM';

a timestamp(0);
b timestamp(0);
c interval day(0) to second(0);
d interval day(0) to second(0);

i_nominal interval day(0) to second(0);
i_actual  interval day(0) to second(0);
i_diff    interval day(0) to second(0);

begin

a := cast( cast( pi_begindatum_tz as date) as timestamp);
b := trunc( cast( cast( pi_begindatum_tz as date) as timestamp ));
c := a - b;
d := (cast( cast( pi_begindatum_tz as date) as timestamp)) - (trunc( cast( cast( pi_begindatum_tz as date) as timestamp )));

dbms_output.put_line ( apex_string.format('a: %s', a));
dbms_output.put_line ( apex_string.format('b: %s', b));
dbms_output.put_line ( apex_string.format('a-b: %s', a-b));
dbms_output.put_line ( apex_string.format('c: %s', c));
dbms_output.put_line ( apex_string.format('d: %s', d));


i_nominal := a - b;
dbms_output.put_line ( apex_string.format('i_nominal: %s', i_nominal));

i_actual  := pi_begindatum_tz - trunc( pi_begindatum_tz);
dbms_output.put_line ( apex_string.format('i_actual: %s', i_actual));

i_diff    := i_actual - i_nominal ;
dbms_output.put_line ( apex_string.format('i_diff: %s', i_diff));

--return pi_begindatum_tz at time zone cs_gas_calculation_time_zone - trunc( pi_begindatum_tz at time zone cs_gas_calculation_time_zone);
end;
/
