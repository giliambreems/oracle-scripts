set timing on

declare
   l_temp varchar2(100);
   
  function uuid_genereren return varchar2
  is
    s_guid varchar2(100);
--    s_uuid varchar2(100);
    
    s_search_regexp  varchar2(100);
    s_replace_regexp varchar2(100);
  begin
    -- selecteer standaard guid:
    -- Zoek naar alfanumerieke characters en maak 5 groepen (groep 1: 8 characters, groep 2-4: 4 characters, groep 5: 12 characters)
    -- Plaats dash (-) tekens tussen deze groepen
    -- Voorbeeld:
    -- GUID = 15C07CBD591236EEE06322CAA8C0BC0F
    -- Output = 15C07CBD-5912-36EE-E063-22CAA8C0BC0F
    s_search_regexp  := '([[:alnum:]]{8})([[:alnum:]]{4})([[:alnum:]]{4})([[:alnum:]]{4})([[:alnum:]]{12})';
    s_replace_regexp := '\1-\2-\3-\4-\5';
    
    select regexp_replace( sys_guid(), s_search_regexp, s_replace_regexp) into s_guid from dual;
    
--    select sys_guid() into s_guid from dual ;
--    -- opmaken:
--    s_uuid := substr( s_guid,  0,  8 ) || '-' ||
--              substr( s_guid,  9,  4 ) || '-' ||
--              substr( s_guid, 13,  4 ) || '-' ||
--              substr( s_guid, 17,  4 ) || '-' ||
--              substr( s_guid, 21, 12 );
    return s_guid ;
  end uuid_genereren;
  
begin
  for i in 1 .. 1000000 loop
    l_temp := uuid_genereren;
  end loop;
end;
/
