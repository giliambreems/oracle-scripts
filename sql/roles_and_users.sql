select *
from   dba_roles
where  role like 'ROLE%'
/

select *
from   dba_users usr
where  usr.username = :username
/

-- Roles granted roles to user
select usr.username, usr_rle.*
from   dba_users usr
  left join dba_role_privs usr_rle on usr_rle.grantee = usr.username
where usr.username = :username
/

-- Users granted to a role
select usr.username, usr_rle.*
from   dba_users usr
  left join dba_role_privs usr_rle on usr_rle.grantee = usr.username
where usr_rle.granted_role = :granted_role
/

-- System privileges granted to a user
select usr.username, uop.*
from   dba_users usr
  left join dba_sys_privs uop on uop.grantee = usr.username
where usr.username = :username
/

-- Object privileges granted to a role
select rle_tab.*
from   ROLE_TAB_PRIVS rle_tab
where  rle_tab.role = :role
order by 2, 3
/

-- Object privileges granted to a user
select prv.*
from   DBA_TAB_PRIVS prv
where  prv.grantee = :grantee
order by 2, 3
/

select * from dba_role_privs where grantee = nvl( :username, grantee) order by grantee, granted_role; -- Roles granted to users and roles
select * from dba_sys_privs where grantee = nvl( :username, grantee) order by grantee, privilege; -- System privileges granted to users and roles
select * from dba_tab_privs where grantee = nvl( :username, grantee) and owner = nvl( :owner, owner) order by owner, table_name; -- Object privileges granted to users and roles

select * from ROLE_ROLE_PRIVS where role = nvl( :role, role) order by role, granted_role; -- Roles which are granted to roles
select * from ROLE_SYS_PRIVS where role = nvl( :role, role) order by role, privilege; -- System privileges granted to roles
select * from ROLE_TAB_PRIVS where role = nvl( :role, role) order by owner, table_name; -- Object privileges granted to roles

select *
from   ROLE_TAB_PRIVS rle_tab
where  rle_tab.role = :role
/

select *
from   ROLE_SYS_PRIVS rle_tab
where  rle_tab.role = :role
/

select * from proxy_users
/

select * from dict where table_name like '%ROLE%' order by 1
/

create role ROLE_BA_ETC;
grant ROLE_BA_ETC to BA_ETC;
alter user BA_ETC default role all;

-- BI_EDW
alter user BI_EDW default role all;

select * from role_role_privs
/

select *
from   DBA_USERS
where  username in ('ARIS.VERBURGH','DAVID.BIJL','GILIAM.BREEMS','NICO.HEEMSKERK','NICO.VANROON','RIEN.DEWIT','OSCAR.SLEE')
order by 1
/

select usr.username, usr_rle.*
from   dba_users usr
  left join dba_role_privs usr_rle on usr_rle.grantee = usr.username
where usr.username in ('ARIS.VERBURGH','DAVID.BIJL','GILIAM.BREEMS','NICO.HEEMSKERK','NICO.VANROON','RIEN.DEWIT','OSCAR.SLEE')
/

select * from PROXY_USERS
where proxy in ('ARIS.VERBURGH','DAVID.BIJL','GILIAM.BREEMS','NICO.HEEMSKERK','NICO.VANROON','RIEN.DEWIT','OSCAR.SLEE')
/
