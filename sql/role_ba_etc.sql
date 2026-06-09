PROMPT -------
PROMPT Uitvoer script tbv toekennen rechten BI/BA
PROMPT -------

-- Aanmaken rol indien deze nog niet bestaat.
create role ROLE_BA_ETC;
grant ROLE_BA_ETC to BA_ETC;

-- Aanmaken rol indien deze nog niet bestaat.
create role ROLE_BI_EDW;
grant ROLE_BI_EDW to BI_EDW;

-- Script tbv het toekennen van SELECT rechten op alle tabellen van FluxProducenten aan rol ROLE_BA_ETC tbv BI/BA
set serveroutput on
declare
    l_additional_privilege varchar2(100);
    l_target_role          varchar2(30)   default  'ROLE_BA_ETC';
begin
    for r in (select 'GRANT SELECT on ' || tb.owner || '.' || tb.table_name || ' to ' || l_target_role as dml
              from   all_tables tb
              where  tb.owner = 'FP_DATA'
                  or tb.owner = 'FG_DATA'
              order by tb.owner, tb.table_name)
    loop
        dbms_output.put_line( r.dml || ';');
        execute immediate r.dml;
    end loop;
    
    -- Expliciet verwijderen zolang niet is aangegeven dat dit nodig is.
    l_additional_privilege := 'REVOKE SELECT on FG_DATA.INS_INSTELLING from ' || l_target_role;
    dbms_output.put_line( l_additional_privilege || ';');
    execute immediate l_additional_privilege;
end;
/
