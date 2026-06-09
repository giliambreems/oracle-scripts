with src as
( select q'['s Hertogenbosch]' as name
  from   dual
  union all
  select q'['s Gravenhage]' as name
  from   dual
  union all
  select q'[Des 'Heeren]' as name
  from   dual
)
select src.name as original_name
     , apex_exec.enquote_literal( src.name ) as enquoted_name
     , substr(apex_exec.enquote_literal( src.name), 2, length(apex_exec.enquote_literal( src.name ))-2) as insertable_name
from   src
/
