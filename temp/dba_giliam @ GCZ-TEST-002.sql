select * from proxy_users
/

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
    EXECUTE IMMEDIATE 'alter user gdx_release grant connect through "' || pi_ontwikkelaar || '"';

  end proxy_rechten_uitdelen;
begin
  proxy_rechten_uitdelen( pi_ontwikkelaar => 'GILIAM.BREEMS' );
end;
/

commit
/
