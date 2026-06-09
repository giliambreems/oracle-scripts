with tab as
( select tab.owner as table_owner
       , tab.table_name
       , substr( tab.table_name, 1, instr( tab.table_name, '_') -1) table_alias
  from   dba_tables tab
  where  tab.owner in ('FP_DATA', 'FG_DATA')
)
, seq as
(  select seq.sequence_owner
       , seq.sequence_name
       , substr(seq.sequence_name, 5) sequence_alias
       , seq.min_value as sequence_min_value
       , seq.last_number as sequence_last_number
   from  dba_sequences seq
   where seq.sequence_owner in ('FP_DATA', 'FG_DATA')
)
select tab.*
     , seq.*
     , 'select max('||table_alias||'_ID)+1 as NEW_VALUE from '||tab.table_owner||'.'||tab.table_name   as select_max_table_value
     , 'alter sequence '||seq.sequence_owner||'.'||seq.sequence_name||' restart start with #NEW_VALUE#' as update_sequence_object
from   tab
  join  seq on seq.sequence_owner = tab.table_owner
            and seq.sequence_alias = tab.table_alias
/


-- Update sequences after datapump export/import
set serveroutput on

PROMPT UPDATE SEQUENCES WITH ACTUAL LAST VALUE
declare
  cursor c_schema is
    select u.username
    from   all_users u
    where  u.username in ('FG_DATA', 'FP_DATA', 'FS_SIDEKICK');

  cursor c_seq ( b_owner in varchar2 ) is
    with tab as
    ( select tab.owner as table_owner
           , tab.table_name
           , substr( tab.table_name, 1, instr( tab.table_name, '_') -1) table_alias
      from   dba_tables tab
      where  tab.owner = b_owner
    )
    , seq as
    (  select seq.sequence_owner
           , seq.sequence_name
           , substr(seq.sequence_name, 5) sequence_alias
       from  dba_sequences seq
       where seq.sequence_owner = b_owner
    )
    select tab.*
         , seq.*
         , 'select max('||table_alias||'_ID)+1 as NEW_VALUE from '||tab.table_owner||'.'||tab.table_name as select_max_table_value
         , 'alter sequence '||seq.sequence_owner||'.'||seq.sequence_name||' restart start with #NEW_VALUE#' as update_sequence_object
    from   tab
      join  seq on seq.sequence_owner = tab.table_owner
                and seq.sequence_alias = tab.table_alias
    order by tab.table_owner, tab.table_alias;

  l_new_value number;
  l_sql_stmt varchar2(2000);
begin
  for r_schema in c_schema
  loop
    for r_seq in c_seq ( b_owner => r_schema.username)
    loop
      execute immediate r_seq.select_max_table_value into l_new_value;

      if l_new_value is not null then
        -- Replace #NEW_VALUE# with actual value in SQL statement
        l_sql_stmt := replace( r_seq.update_sequence_object, '#NEW_VALUE#', l_new_value);
        -- Display and execute the SQL statment
        dbms_output.put_line( l_sql_stmt );
        execute immediate l_sql_stmt;
      end if;
    end loop;

    dbms_output.put_line(''); -- empty line in output
  end loop;
end;
/

