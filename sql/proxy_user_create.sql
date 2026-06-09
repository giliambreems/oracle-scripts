select * from dba_users where username = 'OSCAR.SLEE'
/

alter user "OSCAR.SLEE" account unlock
/

create user "OSCAR.SLEE" identified by "Welkom01!" password expire;
alter user "OSCAR.SLEE" identified by "Welkom01!" password expire;
grant create session to "OSCAR.SLEE";


-- Rechten om te verbinden als proxy:
set serveroutput on
--clear screen
declare
  procedure proxy_rechten_uitdelen( pi_ontwikkelaar  in  varchar2 )
  is
  begin

    --EXECUTE IMMEDIATE 'alter user fg_api grant connect through "'      || pi_ontwikkelaar || '"';
    EXECUTE IMMEDIATE 'alter user fg_data grant connect through "'     || pi_ontwikkelaar || '"';
    EXECUTE IMMEDIATE 'alter user fg_service grant connect through "'  || pi_ontwikkelaar || '"';

    EXECUTE IMMEDIATE 'alter user fp_api grant connect through "'     || pi_ontwikkelaar || '"';
    EXECUTE IMMEDIATE 'alter user fp_data grant connect through "'     || pi_ontwikkelaar || '"';
    EXECUTE IMMEDIATE 'alter user fp_service grant connect through "'  || pi_ontwikkelaar || '"';

    EXECUTE IMMEDIATE 'alter user fs_sidekick grant connect through "' || pi_ontwikkelaar || '"';

    EXECUTE IMMEDIATE 'alter user gdx_data grant connect through "'     || pi_ontwikkelaar || '"';
    EXECUTE IMMEDIATE 'alter user gdx_service grant connect through "'  || pi_ontwikkelaar || '"';
    EXECUTE IMMEDIATE 'alter user gdx_api grant connect through "' || pi_ontwikkelaar || '"';
    -- EXECUTE IMMEDIATE 'alter user gdx_release grant connect through "' || pi_ontwikkelaar || '"';

  end proxy_rechten_uitdelen;
begin
  proxy_rechten_uitdelen( pi_ontwikkelaar => 'GILIAM.BREEMS' );
end;
/

commit
/


-- Message to send back to user
Je kunt nu inloggen met "OSCAR.SLEE" en als wachtwoord "Welkom01!"

Voordat je kunt inloggen dien je eerst je wachtwoord aan te passen.
  - Maak hiervoor een eerst connectie in SQL Developer aan
  - Klik daarna met de rechtermuisknop op de connectie en kies voor "Reset password"



-- Rechten uitdelen/intrekken als proxy:
set serveroutput on
--clear screen
declare

  auth_type_grant  varchar2(6) default 'GRANT';
  auth_type_revoke varchar2(6) default 'REVOKE';

  function proxy_statement( p_auth_type in varchar2, p_user in varchar2, p_proxy in varchar2 )
  return varchar2
  is
    e_unknown_auth_type exception;
  begin
    if p_auth_type not in ( auth_type_grant, auth_type_revoke ) then
      raise e_unknown_auth_type;
    end if;

    return apex_string.format('alter user "%s" %s connect through "%s"', p_user, p_auth_type, p_proxy );
  exception
    when e_unknown_auth_type then
      raise_application_error( -20000, 'Unknown authorization type detected');
  end proxy_statement;

  procedure proxy_rechten_uitdelen( pi_ontwikkelaar  in  varchar2, pi_schema in varchar2 )
  is
    s_statement varchar2(2000);
  begin
    s_statement := proxy_statement( auth_type_grant, pi_schema, pi_ontwikkelaar );
    dbms_output.put_line( chr(13) || s_statement );

    null; --execute immediate s_statement;
  end proxy_rechten_uitdelen;

  procedure proxy_rechten_uitdelen( pi_ontwikkelaar  in  varchar2 )
  is
  begin
    proxy_rechten_uitdelen( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FS_SIDEKICK' );

    proxy_rechten_uitdelen( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FG_DATA' );
    proxy_rechten_uitdelen( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FG_SERVICE' );

    proxy_rechten_uitdelen( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FP_DATA' );
    proxy_rechten_uitdelen( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FP_SERVICE' );
  end;

  procedure proxy_rechten_intrekken( pi_ontwikkelaar  in  varchar2, pi_schema in varchar2 )
  is
    s_statement varchar2(2000);
  begin

    for r in (select s.proxy, s.client from proxy_users  s where s.proxy = pi_ontwikkelaar and s.client = nvl( pi_schema, s.client) )
    loop
      s_statement := proxy_statement( auth_type_revoke, r.client, r.proxy );
      dbms_output.put_line( chr(13) || s_statement );    -- apex_string.format('alter user "%s" revoke connect through "%s" ', r.client, r.proxy));

      declare
        e_not_granted exception;
        PRAGMA EXCEPTION_INIT(e_not_granted, -38470);
      begin null;
        null; --execute immediate s_statement;
      exception
        when e_not_granted then dbms_output.put_line(sqlerrm);
      end;

    end loop;

  end proxy_rechten_intrekken;

  procedure proxy_rechten_intrekken( pi_ontwikkelaar  in  varchar2)
  is
  begin
    proxy_rechten_intrekken( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FS_SIDEKICK' );

    proxy_rechten_intrekken( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FG_DATA' );
    proxy_rechten_intrekken( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FG_SERVICE' );
    proxy_rechten_intrekken( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FG_API' );

    proxy_rechten_intrekken( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FP_DATA' );
    proxy_rechten_intrekken( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FP_SERVICE' );
    proxy_rechten_intrekken( pi_ontwikkelaar => pi_ontwikkelaar, pi_schema => 'FP_API' );
  end;

begin
  proxy_rechten_intrekken( pi_ontwikkelaar => 'RIEN.DEWIT' );
  proxy_rechten_uitdelen( pi_ontwikkelaar => 'TOM.BAKKER' );
end;
/

commit
/



select * from proxy_users order by proxy, client
/


select du.username, du.account_status, du.lock_date, du.expiry_date, nvl2( pu.proxy, 'YES', 'NO') proxy_user_exists, listagg(pu.client,', ') proxy_clients
from   dba_users du
  left join proxy_users pu on pu.proxy = du.username
where  du.username in ('COLLIN.ERDHUIZEN','DENNIS.DOOMEN','WIM.VANDUIJNHOVEN','ZANA.FUAD')
group by du.username, du.account_status, du.lock_date, du.expiry_date, pu.proxy
order by du.username
/

alter user "COLLIN.ERDHUIZEN" account lock;

alter user "DENNIS.DOOMEN" account lock;

alter user "WIM.VANDUIJNHOVEN" account lock;

alter user "ZANA.FUAD" account lock;




alter user "FS_SIDEKICK" revoke connect through "RIEN.DEWIT"
alter user "FP_DATA" revoke connect through "RIEN.DEWIT"
alter user "FP_SERVICE" revoke connect through "RIEN.DEWIT"
alter user "FG_DATA" revoke connect through "RIEN.DEWIT"
alter user "FG_SERVICE" revoke connect through "RIEN.DEWIT"
alter user "FG_API" revoke connect through "RIEN.DEWIT"

alter user "FS_SIDEKICK" revoke connect through "TOM.BAKKER"
alter user "FP_DATA" revoke connect through "TOM.BAKKER"
alter user "FP_SERVICE" revoke connect through "TOM.BAKKER"
alter user "FG_DATA" revoke connect through "TOM.BAKKER"
alter user "FG_SERVICE" revoke connect through "TOM.BAKKER"
alter user "FG_API" revoke connect through "TOM.BAKKER"
