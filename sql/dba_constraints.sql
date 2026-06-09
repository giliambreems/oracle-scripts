-- Foreign Key Constraints (FK's from source table) (table <<x>> has references to ...)
select con.owner
     , con.constraint_name
     , con.constraint_type
     , con.table_name
     , listagg(col.column_name, ', ') as table_columns
     , con.r_owner
     , con.r_constraint_name
     , rcon.constraint_type as r_constraint_type
     , rcon.table_name as r_table_name
     , listagg(rcol.column_name, ', ') as r_table_columns
     , con.delete_rule
     , con.status
     , con.deferrable
     , con.deferred
     , con.validated
from   dba_constraints con
  left join dba_cons_columns col on col.owner = con.owner and col.constraint_name = con.constraint_name
  left join dba_constraints rcon on rcon.owner = con.r_owner and rcon.constraint_name = con.r_constraint_name
  left join dba_cons_columns rcol on rcol.owner = rcon.owner and rcol.constraint_name = rcon.constraint_name
where  con.constraint_type = 'R'
and    con.owner = :table_owner
and    con.table_name = :table_name
group by con.owner
     , con.constraint_name
     , con.constraint_type
     , con.table_name
     , con.r_owner
     , con.r_constraint_name
     , rcon.constraint_type
     , rcon.table_name
     , con.delete_rule
     , con.status
     , con.deferrable
     , con.deferred
     , con.validated
order by con.owner
       , con.table_name
       , con.constraint_name
/

-- Foreign Key Constraints (FK's to target table) (table <<x>> is being referred to by ...)
select con.owner
     , con.constraint_name
     , con.constraint_type
     , con.table_name
     , listagg(col.column_name, ', ') as table_columns
     , con.r_owner
     , con.r_constraint_name
     , rcon.constraint_type as r_constraint_type
     , rcon.table_name as r_table_name
     , listagg(rcol.column_name, ', ') as r_table_columns
     , con.delete_rule
     , con.status
     , con.deferrable
     , con.deferred
     , con.validated
from   dba_constraints con
  left join dba_cons_columns col on col.owner = con.owner and col.constraint_name = con.constraint_name
  left join dba_constraints rcon on rcon.owner = con.r_owner and rcon.constraint_name = con.r_constraint_name
  left join dba_cons_columns rcol on rcol.owner = rcon.owner and rcol.constraint_name = rcon.constraint_name
where  con.constraint_type = 'R'
and    con.r_owner = :table_owner
and    rcon.table_name = :table_name
group by con.owner
     , con.constraint_name
     , con.constraint_type
     , con.table_name
     , con.r_owner
     , con.r_constraint_name
     , rcon.constraint_type
     , rcon.table_name
     , con.delete_rule
     , con.status
     , con.deferrable
     , con.deferred
     , con.validated
order by con.r_owner
       , rcon.table_name
       , con.r_constraint_name
/
