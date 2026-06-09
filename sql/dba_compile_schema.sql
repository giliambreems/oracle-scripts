select *
from   dba_objects
where  owner = '<SCHEMA_NAME>'
/


select *
from   all_objects
where  owner = '<SCHEMA_NAME>'
and    status <> 'VALID'
/


BEGIN
    DBMS_UTILITY.COMPILE_SCHEMA(schema => '<SCHEMA_NAME>', compile_all => FALSE);
END;
/

BEGIN
    DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FS_SIDEKICK', compile_all => FALSE);

    DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FG_DATA',     compile_all => FALSE);
    DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FG_SERVICE',  compile_all => FALSE);

    DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FP_DATA',     compile_all => FALSE);
    DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FP_SERVICE',  compile_all => FALSE);

    DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FP_API',      compile_all => FALSE);
END;
/

select *
from   all_objects
where  owner in ('FS_SIDEKICK','FG_DATA','FG_SERVICE','FP_DATA','FP_SERVICE','FP_API')
and    status <> 'VALID'
/
