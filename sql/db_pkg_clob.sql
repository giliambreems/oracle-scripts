PROMPT Creating Package 'PKG_CLOB'
create or replace package pkg_clob
is

  procedure set_debug_on;
  procedure set_debug_off;
  
  procedure print_clob
  (
    p_clob in clob
  );

  function replace_clob
  (
    in_source  in clob,
    in_search  in varchar2,
    in_replace in clob
  )
  return clob;
  --
end pkg_clob;
/

PROMPT Creating Package Body 'PKG_CLOB'
create or replace package body pkg_clob
is

  gc_max_length_vc2 constant pls_integer default 32767;

  gc_debug boolean default false;

  procedure set_debug
  (
    p_debug_mode in boolean default false
  )
  is
  begin
    gc_debug := p_debug_mode;
  end;

  procedure set_debug_on
  is
  begin
    set_debug( p_debug_mode => true);
  end;

  procedure set_debug_off
  is
  begin
    set_debug( p_debug_mode => false);
  end;

  procedure print_clob
  (
    p_clob in clob
  )
  is
    l_lower_bound pls_integer;
    l_upper_bound pls_integer;
    
    l_offset    pls_integer;
    l_buffer    varchar2(gc_max_length_vc2);
  begin
    -- Loop from lower bound <0> to upper bound <x-1> instead of the usual lower bound <1> and upper bound <x>. This makes
    -- the formula (gc_max_length_vc2 * i) + 1 compatible with the first iteration, where the lower bound should be 1.
    l_lower_bound := 0;
    l_upper_bound := ceil( length(p_clob) / gc_max_length_vc2) -1;

    <<partial_clob>>
    for i in l_lower_bound .. l_upper_bound loop
      l_offset := (gc_max_length_vc2 * i) + 1;
      l_buffer := substr( p_clob, l_offset, gc_max_length_vc2);

      if gc_debug then
        sys.dbms_output.put_line( 'iteration: '||(i+1));    sys.dbms_output.put_line( 'offset: '||l_offset);    sys.dbms_output.put_line( 'length: '||length(l_buffer));
      end if;

      sys.dbms_output.put_line( l_buffer);

    end loop partial_clob;
  end print_clob;

  function replace_clob
  (
    in_source  in clob,
    in_search  in varchar2,
    in_replace in clob
  )
  return clob
  is
    l_pos pls_integer;
    l_result clob;
  begin
    l_pos := instr(in_source, in_search);

    if l_pos > 0 then
      l_result := substr( in_source, 1, l_pos-1)
                    || in_replace
                    || substr(in_source, l_pos+length(in_search));
    else
      l_result := in_source;
    end if;

    return l_result;
  end replace_clob;
  --
end pkg_clob;
/
show error

PROMPT Dropping Package 'PKG_CLOB'
drop package pkg_clob
/