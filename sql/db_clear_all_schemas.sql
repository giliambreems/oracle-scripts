conn -name "FS_SIDEKICK.DEV"
set serveroutput on
lb drop-all -schemas FS_SIDEKICK -force true
begin
  for obj in (select * from user_objects where object_type in ('PACKAGE BODY','PACKAGE') order by decode(object_type,'PACKAGE BODY',1,2 ))
  loop
    dbms_output.put_line(apex_string.format('drop %s %s.%s', obj.object_type, user, obj.object_name ));
    execute immediate apex_string.format('drop %s %s.%s', obj.object_type, user, obj.object_name );
  end loop;

end;
/

conn -name "FG_DATA.DEV"
set serveroutput on
lb drop-all -schemas FG_DATA -force true
begin
  for obj in (select * from user_objects where object_type in ('PACKAGE BODY','PACKAGE') order by decode(object_type,'PACKAGE BODY',1,2 ))
  loop
    dbms_output.put_line(apex_string.format('drop %s %s.%s', obj.object_type, user, obj.object_name ));
    execute immediate apex_string.format('drop %s %s.%s', obj.object_type, user, obj.object_name );
  end loop;

end;
/

conn -name "FG_SERVICE.DEV"
set serveroutput on
lb drop-all -schemas FG_SERVICE -force true
begin
  for obj in (select * from user_objects where object_type in ('PACKAGE BODY','PACKAGE') order by decode(object_type,'PACKAGE BODY',1,2 ))
  loop
    dbms_output.put_line(apex_string.format('drop %s %s.%s', obj.object_type, user, obj.object_name ));
    execute immediate apex_string.format('drop %s %s.%s', obj.object_type, user, obj.object_name );
  end loop;

end;
/

conn -name "FP_DATA.DEV"
set serveroutput on
lb drop-all -schemas FP_DATA -force true
begin
  for obj in (select * from user_objects where object_type in ('PACKAGE BODY','PACKAGE') order by decode(object_type,'PACKAGE BODY',1,2 ))
  loop
    dbms_output.put_line(apex_string.format('drop %s %s.%s', obj.object_type, user, obj.object_name ));
    execute immediate apex_string.format('drop %s %s.%s', obj.object_type, user, obj.object_name );
  end loop;

end;
/

conn -name "FP_SERVICE.DEV"
set serveroutput on
lb drop-all -schemas FP_SERVICE -force true
begin
  for obj in (select * from user_objects where object_type in ('PACKAGE BODY','PACKAGE') order by decode(object_type,'PACKAGE BODY',1,2 ))
  loop
    dbms_output.put_line(apex_string.format('drop %s %s.%s', obj.object_type, user, obj.object_name ));
    execute immediate apex_string.format('drop %s %s.%s', obj.object_type, user, obj.object_name );
  end loop;

end;
/
