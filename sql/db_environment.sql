--create
declare
  subtype t_environment is varchar2(4);
  subtype t_host is varchar2(30);

  sc_env_local       constant  t_environment  default  'ONTW';
  sc_env_development constant  t_environment  default  'ONTW';
  sc_env_test        constant  t_environment  default  'TEST';
  sc_env_acceptance  constant  t_environment  default  'ACC';
  sc_env_production  constant  t_environment  default  'PROD';

  function is_environment( pi_environment in t_environment)
    return boolean
  is
    s_current_hostname  varchar2(30);
  begin
    s_current_hostname := sys_context ( 'USERENV', 'SERVER_HOST' );

    if upper(s_current_hostname) = upper(pi_environment) then
      return true;
    else
      return false;
    end if;
  end;

  function is_production_environment
    return boolean
  is
    c_production_hostname varchar2(12) default 'ETG-' || sc_env_production || '-001';
  begin
    return is_environment( pi_environment => c_production_hostname);
  end;

begin
  null;
end;
/