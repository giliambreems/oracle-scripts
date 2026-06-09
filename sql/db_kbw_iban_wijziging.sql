-- Get the details with next query
select kbw.kbw_kla_id,
       kbw.kbw_tenaamstelling,
       kbw.kbw_bankrekeningnummer
from  FP_DATA.kbw_klant_betaalwijze kbw
where kbw.kbw_bankrekeningnummer = :p_iban_old
/

set serveroutput on

-- Change IBAN when correct details have been entered!
declare
  n_kla_id   fp_data.kbw_klant_betaalwijze.kbw_kla_id%type;
  s_tenaamstelling fp_data.kbw_klant_betaalwijze.kbw_tenaamstelling%type;
  s_iban_old fp_data.kbw_klant_betaalwijze.kbw_bankrekeningnummer%type;
  s_iban_new fp_data.kbw_klant_betaalwijze.kbw_bankrekeningnummer%type;
begin
  --
  -- Set correct details before running!!
  --
  n_kla_id         := :p_kla_id;             -- example: 100524
  s_tenaamstelling := :p_tenaamstellling;    -- example: 'Energie Coöperatie Zonneweide Glimmen U.A.';
  s_iban_old       := :p_iban_old;           -- example: 'NL10INGB0007685247'; 
  s_iban_new       := :p_iban_new;           -- example: 'NL59RABO0168245590';
  --
  --
  --
  declare
    cursor c_kbw (p_kla_id in number, p_iban in varchar2)
    is
      select kbw.kbw_kla_id,
             kbw.kbw_tenaamstelling,
             kbw.kbw_bankrekeningnummer
      from  fp_data.kbw_klant_betaalwijze kbw
      where kbw.kbw_kla_id = p_kla_id
      and   kbw.kbw_bankrekeningnummer = p_iban
      for update;

    r_kbw c_kbw%rowtype;

  begin
      
    -- Collect klant information
    open c_kbw( n_kla_id, s_iban_old);
    fetch c_kbw into r_kbw;
    
    -- If found AND tenaamstelling match entered information
    if c_kbw%found then
      dbms_output.put_line( apex_string.format( 'Betaalwijze met IBAN %s voor klant met kla_id %s gevonden', r_kbw.kbw_bankrekeningnummer, r_kbw.kbw_kla_id ) );
    
      if r_kbw.kbw_tenaamstelling = s_tenaamstelling then
        dbms_output.put_line( apex_string.format( 'De tenaamstelling "%s" komt overeen met opgegeven tenaamstelling "%s"', r_kbw.kbw_tenaamstelling, :p_tenaamstellling ) );

        if s_iban_new is not null then
            dbms_output.put_line( apex_string.format( 'Het nieuwe IBAN nummer "%s" is opgegeven', s_iban_new ) );
  
            -- Update happens in two parts
            -- 
            -- part 1.
            --   - update bankrekeningnummer
            --   - update modified tenaamstelling (to force a change detection between Flux <-> Ability, synchronization doesn't detect changes on IBAN)
            --   - synchronize changes with Ability
            --
            -- part 2.
            --   - restore original tenaamstelling
            --   - synchronize changes with Ability
            --
            -- Explicit rollbacks necessary, due to commit statement inside pkg_fiqas_v3.klant_aanmaken_wijzigen procedure
            --
            
            <<update_part_1>>
            begin
              dbms_output.put_line( apex_string.format( 'Oud IBAN "%s" aanpassen naar nieuw IBAN "%s"', r_kbw.kbw_bankrekeningnummer, :p_iban_new ) );
              
              update fp_data.kbw_klant_betaalwijze kbw
              set    kbw_bankrekeningnummer = s_iban_new
              ,      kbw.kbw_tenaamstelling = substr( r_kbw.kbw_tenaamstelling, 1, length(r_kbw.kbw_tenaamstelling) - 1 )
              where current of c_kbw;
            
              begin
                dbms_output.put_line( apex_string.format( 'IBAN wijziging doorgeven aan Fiqas Ability, met afwijkende tenaamstelling "%s"', substr( r_kbw.kbw_tenaamstelling, 1, length(r_kbw.kbw_tenaamstelling) - 1 ) ) );
    
                -- wijzig klant met afgekorte tenaamstelling om change te detecteren
                fp_service.pkg_fiqas_v3.klant_aanmaken_wijzigen( pi_kla_id => r_kbw.kbw_kla_id );
              exception
                when others then
                  -- terugdraaien wijziging ivm commit in rest api call
                  update fp_data.kbw_klant_betaalwijze kbw
                  set    kbw_bankrekeningnummer = s_iban_old
                  ,      kbw.kbw_tenaamstelling = r_kbw.kbw_tenaamstelling
                  where current of c_kbw;
                  commit;
                
                  raise;
              end;
              
              commit; --there is no rollback possible after the REST API call
            end update_part_1;
            
    
            <<update_part_2>>
            begin
              dbms_output.put_line( apex_string.format( 'Afwijkende tenaamstelling terugzetten naar origineel "%s"', r_kbw.kbw_tenaamstelling ) );
    
              update fp_data.kbw_klant_betaalwijze kbw
              set    kbw.kbw_tenaamstelling = r_kbw.kbw_tenaamstelling
              where current of c_kbw;        
    
              begin
                dbms_output.put_line( apex_string.format( 'Originele tenaamstelling "%s" doorgeven aan Fiqas Ability', r_kbw.kbw_tenaamstelling ) );
    
                -- wijzig klant met afgekorte tenaamstelling om change te detecteren
                fp_service.pkg_fiqas_v3.klant_aanmaken_wijzigen( pi_kla_id => r_kbw.kbw_kla_id );
              exception
                when others then
                  -- terugdraaien wijziging ivm commit in rest api call
                  update fp_data.kbw_klant_betaalwijze kbw
                  set    kbw.kbw_tenaamstelling = substr( r_kbw.kbw_tenaamstelling, 1, length(r_kbw.kbw_tenaamstelling) - 1 )
                  where current of c_kbw;
                  commit;
                
                  raise;
              end;
            
              commit; --there is no rollback possible after the REST API call
            end update_part_2;
            
          else
            dbms_output.put_line( apex_string.format( 'Het nieuwe IBAN nummer "%s" is niet correct', :p_iban_new ) );
            dbms_output.put_line( apex_string.format( 'IBAN wijziging afgebroken.' ) );
          end if;
      else
        dbms_output.put_line( apex_string.format( 'De tenaamstelling "%s" komt niet overeen met opgegeven tenaamstelling "%s"', r_kbw.kbw_tenaamstelling, :p_tenaamstellling ) );
        dbms_output.put_line( apex_string.format( 'IBAN wijziging afgebroken.' ) );
      end if;
    else
      dbms_output.put_line( apex_string.format( 'Betaalwijze met IBAN %s voor klant met kla_id %s is niet gevonden', :p_iban_old, :p_kla_id ) );
      dbms_output.put_line( apex_string.format( 'IBAN wijziging afgebroken.' ) );
    end if;
    
    close c_kbw;
  exception
    when others then
      rollback;
      if c_kbw%isopen then close c_kbw; end if;
      raise;
  end;
  
end;
/
