truncate table geb_gebruiker
/

truncate table ggk_gebruiker_groep_koppeling
/


-- Add you ass a user to the application
declare
  l_geb_id fg_data.geb_gebruiker.geb_id%type;
begin
  fg_service.pkg_gebruiker_autorisatie.gebruiker_toevoegen
    ( po_geb_id          => l_geb_id
    , pi_geb_voornaam    => 'Giliam'
    , pi_geb_achternaam  => 'Breems'
    , pi_geb_email       => 'Giliam.Breems@greenchoice.nl'
    , pi_geb_inlognaam   => 'GILIAM.BREEMS'
    );
end;
/

-- Synchronize LDAP users
call fg_service.pkg_gebruiker_autorisatie.ldap_accounts_synchroniseren();
/


--Authorize user as FLUX ADMIN
declare
  l_geb_id fg_data.geb_gebruiker.geb_id%type;
  l_geg_id fg_data.geg_gebruiker_groep.geg_id%type;
begin
  select geb_id into l_geb_id from fg_data.geb_gebruiker where geb_inlognaam = 'GILIAM.BREEMS';
  select geg_id into l_geg_id from fg_data.geg_gebruiker_groep where geg_code = 'FLUXPROD_APPLBEHEER';

  fg_service.pkg_gebruiker_autorisatie.groep_koppeling_maken
    ( pi_geg_id => l_geg_id
    , pi_geb_id => l_geb_id
    , pi_ger_id => null
    );
end;
/


--Authorize user as FLUX USER
declare
  l_geb_id fg_data.geb_gebruiker.geb_id%type;
  l_geg_id fg_data.geg_gebruiker_groep.geg_id%type;
begin
  select geb_id into l_geb_id from fg_data.geb_gebruiker where geb_inlognaam = 'GILIAM.BREEMS';
  select geg_id into l_geg_id from fg_data.geg_gebruiker_groep where geg_code = 'FLUXPROD_GEBRUIKER';

  fg_service.pkg_gebruiker_autorisatie.groep_koppeling_maken
    ( pi_geg_id => l_geg_id
    , pi_geb_id => l_geb_id
    , pi_ger_id => null
    );
end;
/


--Authorize user as FLUX READER
declare
  l_geb_id fg_data.geb_gebruiker.geb_id%type;
  l_geg_id fg_data.geg_gebruiker_groep.geg_id%type;
begin
  select geb_id into l_geb_id from fg_data.geb_gebruiker where geb_inlognaam = 'GILIAM.BREEMS';
  select geg_id into l_geg_id from fg_data.geg_gebruiker_groep where geg_code = 'FLUXPROD_LEZER';

  fg_service.pkg_gebruiker_autorisatie.groep_koppeling_maken
    ( pi_geg_id => l_geg_id
    , pi_geb_id => l_geb_id
    , pi_ger_id => null
    );
end;
/

select *
from  ggk_gebruiker_groep_koppeling ggk
  join geb_gebruiker geb on geb.geb_id = ggk.ggk_geb_id
  left join geg_gebruiker_groep geg on geg.geg_id = ggk.ggk_geg_id