set serveroutput on

declare
  cursor c_cur is
    SELECT LEVEL just_a_column
    FROM dual
    CONNECT BY LEVEL <= 365;
  r_cur c_cur%rowtype;
begin
    begin

      open c_cur;
      loop
        fetch c_cur into r_cur;
        exit when c_cur%notfound;
        
        raise no_data_found;
      end loop;
      
    exception
      when no_data_found then
        dbms_output.put_line('Exception error while in OPEN/LOOP/FETCH loop construction');
        if c_cur%isopen then
          dbms_output.put_line('  Cursor is still open, close manually!');
          close c_cur;
        else
          dbms_output.put_line('  Cursor is gesloten, closed automatically');
        end if;
    end;

    dbms_output.put_line('');

    begin
    
      for r_cur in c_cur
      loop
        raise no_data_found;
      end loop;

    exception
      when no_data_found then
        dbms_output.put_line('Exception error while in FOR loop construction');
        if c_cur%isopen then
          dbms_output.put_line('  Cursor is still open, close manually');
          close c_cur;
        else
          dbms_output.put_line('  Cursor is gesloten, closed automatically');
        end if;
    end;
end;
/

