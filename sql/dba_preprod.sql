set serveroutput on

PROMPT >> Add LDAP server to ACL configuration for FG_SERVICE (port 389)
begin
  dbms_network_acl_admin.append_host_ace
  ( host       => 'svr-dc-001.greenchoice.rotterdam' -- host voor de LDAP connectie
  , lower_port => null
  , upper_port => null
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect', 'resolve')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );
end;
/

commit
/

PROMPT >> Alter table INS_INSTELLING drop check constraint
alter table fg_data.ins_instelling
  drop constraint INS_CHK02
/

PROMPT >> Alter table INS_INSTELLING add PREP as valid environment
alter table fg_data.ins_instelling
  add constraint INS_CHK02
  check ( ins_omgeving in ('ONTW','TST','ACC','PREP','PRD') )
/

PROMPT >> Duplicate all ACC instelling to PREP in INS_INSTELLING
insert into fg_data.ins_instelling ( ins_omgeving, ins_code, ins_type, ins_waarde)
select 'PREP', ins.ins_code, ins.ins_type, ins.ins_waarde
from   fg_data.ins_instelling ins
where  ins.ins_omgeving = 'ACC'
and not exists ( select 1
                 from   fg_data.ins_instelling ins_prep
                 where  ins_prep.ins_omgeving = 'PREP'
                 and    ins_prep.ins_code = ins.ins_code
                 )
/

PROMPT >> Authenticate login users against LDAP Production Users
update fg_data.ins_instelling
set    ins_waarde   = 'DG-FLUX-DGS-PROD'
where  ins_omgeving = 'PREP'
and    ins_code     = 'LDAP_USER_GROUP'
/

PROMPT >> Revoke existing proxy users from Flux Producenten database schemas
declare
  l_stmt varchar2(2000);
begin
  for rec in ( select s.proxy, s.client from proxy_users s where s.client in ('FG_DATA', 'FG_SERVICE', 'FP_DATA', 'FP_SERVICE', 'FS_SIDEKICK', 'FG_API', 'FP_API') )
  loop
    l_stmt := 'alter user "'||rec.client||'" revoke connect through  "'||rec.proxy||'"';
    dbms_output.put_line(l_stmt);
    execute immediate l_stmt;
  end loop;
end;
/

PROMPT >> Remove all Flux users that do not have an existing authorisation role
delete from fg_data.geb_gebruiker geb
where not exists ( select 1
                   from   fg_data.ggk_gebruiker_groep_koppeling ggk
                   where  ggk.ggk_geb_id = geb.geb_id )
/

commit
/

PROMPT >> Disable all scheduled jobs in FP_SERVICE
BEGIN
  for sched in ( select sched.owner
                 ,      sched.job_name
                 ,      apex_exec.enquote_name( sched.owner) ||'.'|| apex_exec.enquote_name( sched.job_name) owner_object_name
                 from   dba_scheduler_jobs sched
                 where  owner like 'FP_SERVICE' ) loop
    DBMS_SCHEDULER.disable( name => sched.owner_object_name);
  end loop;
END;
/

commit
/


PROMPT >> Add PREP to PKG_UTL_INSTELLING package
create or replace package body FG_SERVICE.PKG_UTL_INSTELLING AS
  g_omgeving         varchar2(10);
  g_key              varchar2(11) := 'key12345678';

  function omgeving return varchar2 deterministic as
  begin
    return g_omgeving;
  end omgeving;

  function password_engine
    ( pi_pwd    in  varchar2
    , pi_actie  in  varchar2
    ) return varchar2
  is
   s_pad_chr     varchar2(1)    := chr(10);
   s_tekst       varchar2(4096) := pi_pwd;
   s_encrypted   varchar2(4096);
   s_decrypted   varchar2(4096);
   s_result      varchar2(4096);
   n_units       number;
  begin
    if pi_actie = 'E' then
      -- Length of data submitted for encryption or decryption must be a multiple of 8 bytes.
      if s_tekst is null then
        s_encrypted :=  '';
      else
        if mod( length( s_tekst), 8) > 0 then
          n_units := trunc( length( s_tekst) / 8) + 1;
          s_tekst := rpad(s_tekst, n_units * 8, s_pad_chr);
        end if;

        dbms_obfuscation_toolkit.desencrypt(input_string     => s_tekst,
                                            key_string       => pkg_utl_instelling.g_key,
                                            encrypted_string => s_encrypted);
        s_encrypted := rawtohex( utl_raw.cast_to_raw( s_encrypted));
      end if;

      s_result := s_encrypted;

    elsif pi_actie = 'D' then
      if s_tekst is not null then
        s_tekst := utl_raw.cast_to_varchar2( hextoraw( s_tekst));
        dbms_obfuscation_toolkit.desdecrypt(input_string     => s_tekst,
                                            key_string       => pkg_utl_instelling.g_key,
                                            decrypted_string => s_decrypted);
      else
        s_decrypted := '';
      end if;

      s_result := rtrim( s_decrypted, s_pad_chr);
    end if;

    return s_result;
  end password_engine;

  function instelling
    ( pi_code      in  fg_data.ins_instelling.ins_code%type
    , pi_omgeving  in  fg_data.ins_instelling.ins_omgeving%type default null
    ) return varchar2
  as
    cursor cur_ins
      ( p_code      fg_data.ins_instelling.ins_code%type
      , p_omgeving  fg_data.ins_instelling.ins_omgeving%type
      )
    is
      select case
               when ins_type='W'
               then fg_service.pkg_utl_instelling.password_engine( ins_waarde, 'D' )
               else ins_waarde
             end as ins_waarde
      from   fg_data.ins_instelling
      where  ins_omgeving = p_omgeving
        and  ins_code = p_code
      ;
    s_waarde fg_data.ins_instelling.ins_waarde%type;
  begin
    open cur_ins
      ( p_code     => pi_code
      , p_omgeving => nvl( pi_omgeving, g_omgeving )
      );
    fetch cur_ins into s_waarde;
    close cur_ins;
    --
    return s_waarde;
    --
  end instelling;

  begin
    select
      case upper(SYS_CONTEXT('USERENV', 'SERVER_HOST'))
          when 'HMESVU01'     then pkg_utl_globals.g_omgeving_prd
          when 'ETG-PROD-001' then pkg_utl_globals.g_omgeving_prd  -- Rotterdam
          when 'HMESVU03'     then pkg_utl_globals.g_omgeving_ontw
          when 'ETG-ONTW-001' then pkg_utl_globals.g_omgeving_ontw -- Rotterdam
          when 'HMESVU07'     then pkg_utl_globals.g_omgeving_tst
          when 'ETG-TEST-001' then pkg_utl_globals.g_omgeving_tst  -- Rotterdam
          when 'HMESVU05'     then pkg_utl_globals.g_omgeving_acc
          when 'ETG-ACC-001'  then pkg_utl_globals.g_omgeving_acc  -- Rotterdam
          when 'GCZ-TEST-002' then 'PREP'  -- pre-production environment
          else pkg_utl_globals.g_omgeving_ontw
      end
      into g_omgeving
    from dual;
end pkg_utl_instelling;
/

PROMPT >> Compile all database schemas again
BEGIN
  DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FG_DATA', compile_all => FALSE);
  DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FG_SERVICE', compile_all => FALSE);
  DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FP_API', compile_all => FALSE);
  DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FP_DATA', compile_all => FALSE);
  DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FP_SERVICE', compile_all => FALSE);
  DBMS_UTILITY.COMPILE_SCHEMA(schema => 'FS_SIDEKICK', compile_all => FALSE);
END;
/

--@f400.sql
--@f900.sql
--@f950.sql
--@f999.sql