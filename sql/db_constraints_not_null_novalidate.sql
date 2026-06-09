-- Explains how a NOT NULL constraint implemented as NOVALIDATE, will enforce NOT NULL values for new/updated
-- values, but won't give the user the NOT NULL information on a DESCRIBE of the table columns. For that the
-- NOT NULL constraint needs to be validated, once validated Oracle knows the columns is a real NOT NULL column
-- and display it like that.

set linesize 500

-- table_abc columns
column x format 9999999999
column y format a30

-- all_constraint columns
column owner format a10
column table_name format a12
column constraint_name format a20
column constraint_type heading TYPE format a5
column search_condition_vc heading SEARCH_CONDITION format a25
column status format a10
column deferrable format a15
column deferred format a15
column validated format a15


drop table table_abc;

create table table_abc  ( x number(10), y varchar2(255));

insert into table_abc values ( null, 'test');

select * from table_abc;

alter table table_abc modify x constraint abc_id_not_null not null enable novalidate;

insert into table_abc values ( null, 'test');
insert into table_abc values ( 1, 'test');

select * from table_abc;

desc table_abc

select owner, table_name, constraint_name, constraint_type, search_condition_vc, status, deferrable, deferred, validated
from   all_constraints
where  table_name = 'TABLE_ABC';

update table_abc
set    x = 2
where  x is null
/

select * from table_abc;

alter table table_abc modify constraint abc_id_not_null enable validate;

select owner, table_name, constraint_name, constraint_type, search_condition_vc, status, deferrable, deferred, validated
from   all_constraints
where  table_name = 'TABLE_ABC';

desc table_abc

drop table table_abc;

