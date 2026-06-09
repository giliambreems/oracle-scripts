set serveroutput on

create or replace package pkg_log_helper
is
  function object_owner( p_depth in pls_integer default 2)
  return varchar2;

  function program_unit( p_depth in pls_integer default 2)
  return varchar2;
end;
/

create or replace package body pkg_log_helper
is

  function object_owner( p_depth in pls_integer default 2)
  return varchar2
  is
  begin
    return utl_call_stack.owner( p_depth);
  end;

  function program_unit( p_depth in pls_integer default 2)
  return varchar2
  is
  begin
    return utl_call_stack.concatenate_subprogram( utl_call_stack.subprogram( p_depth));
  end;

end;
/

create or replace package pkg_a
is
  procedure test;
end;
/

create or replace package body pkg_a
is
  procedure test
  is
  begin
    dbms_output.put_line( pkg_log_helper.object_owner);
    dbms_output.put_line( pkg_log_helper.program_unit);
  end;

end;
/


begin
  pkg_a.test;
end;
/


---------

declare
  procedure test
  is
    
      procedure test_a
      is
        l_res utl_call_stack.unit_qualified_name ;
      begin
        dbms_output.put_line( UTL_CALL_STACK.CONCATENATE_SUBPROGRAM ( UTL_CALL_STACK.SUBPROGRAM (1)));
        
        l_res :=         UTL_CALL_STACK.SUBPROGRAM (2);
        
        for i in 1 .. l_res.count loop
          dbms_output.put_line( i || '. ' || l_res(i));
        end loop;
      end;
      
  begin
      dbms_output.put_line( UTL_CALL_STACK.OWNER(1));
    dbms_output.put_line( UTL_CALL_STACK.CONCATENATE_SUBPROGRAM ( UTL_CALL_STACK.SUBPROGRAM (1)));
    dbms_output.put_line( UTL_CALL_STACK.CONCATENATE_SUBPROGRAM ( UTL_CALL_STACK.SUBPROGRAM (2)));
    test_a;
  end;
begin
  declare
  begin
    declare
    begin
      dbms_output.put_line( UTL_CALL_STACK.OWNER(1));
      dbms_output.put_line( UTL_CALL_STACK.CONCATENATE_SUBPROGRAM ( UTL_CALL_STACK.SUBPROGRAM (1)));
      test();
    end;
  end;
end;
/
