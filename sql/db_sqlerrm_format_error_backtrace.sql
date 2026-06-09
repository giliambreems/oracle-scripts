set serveroutput on
declare

  function custom_format_error_backtrace
  return varchar2
  is
  begin
    return sqlerrm || chr(13) || sys.dbms_utility.format_error_backtrace();
  end;
  
  procedure a
  is
  begin
    raise no_data_found;
  end;

  procedure b
  is
  begin
    a;
  end;
begin

  b();

exception
  when others then
    dbms_output.put_line ( '1. sqlerrm: ' || chr(13) || '--------------------------' || chr(13) || sqlerrm );
    dbms_output.put_line ( '' );
    dbms_output.put_line ( '2. format_error_backtrace(): '           || chr(13) || '--------------------------' || chr(13) || sys.dbms_utility.format_error_backtrace() );
    dbms_output.put_line ( '3. format_error_stack(): '               || chr(13) || '--------------------------' || chr(13) || sys.dbms_utility.format_error_stack()  );
    dbms_output.put_line ( '4. format_call_stack(): '                || chr(13) || '--------------------------' || chr(13) || sys.dbms_utility.format_call_stack()  );
    dbms_output.put_line ( '5. sqlerrm + format_error_backtrace(): ' || chr(13) || '--------------------------' || chr(13) || sqlerrm || chr(13) || sys.dbms_utility.format_error_backtrace()  );
    dbms_output.put_line ( '6. custom_format_error_backtrace(): '    || chr(13) || '--------------------------' || chr(13) || custom_format_error_backtrace() );
    
end;
/