create or replace function dummy_rows(p_start int, p_stop int)
  return varchar2 sql_macro
is
begin
  return
      'select rownum-1+p_start r
       from ( select 1 from dual connect by level <= 1e4),
            ( select 1 from dual connect by level <= case when p_stop - p_start + 1 > 1e4 then 1e4 else 1 end),
            ( select 1 from dual connect by level <= case when p_stop - p_start + 1 > 1e8 then 1e4 else 1 end),
            ( select 1 from dual connect by level <= case when p_stop - p_start + 1 > 1e12 then 1e4 else 1 end)
       where rownum <= p_stop - p_start + 1';
end;
/

select * from dummy_rows(1,5)
/

select * from dummy_rows(10,50)
/
