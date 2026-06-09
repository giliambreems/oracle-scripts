select * from dba_tablespaces
/

select * from dba_data_files
/

select ts.tablespace_name
     , ts.status tablespace_status
     , dfs.file_name
     , dfs.status file_status
     , dfs.online_status file_online_status
from   dba_tablespaces ts
  left join  dba_data_files dfs on dfs.tablespace_name = ts.tablespace_name
order by ts.tablespace_name, dfs.file_name
/

