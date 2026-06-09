begin
  pkg_utl_log.starten
    ( pi_aanroep    => 'SCHEMA.PACKAGE.OBJECT'
    , pi_param_name_01   => 'test_1'
    , pi_param_value_01  => 'test_value_1'
    , pi_param_name_03   => 'test_3'
    , pi_param_value_03  => 'test_value_3'
    );

end;
/

begin
  pkg_utl_log.starten
    ( pi_aanroep    => 'SCHEMA.PACKAGE.OBJECT'
    , pi_param_name_01   => null
    , pi_param_value_01  => null
    , pi_param_name_03   => null
    , pi_param_value_03  => null
    );

end;
/

begin
  pkg_utl_log.starten
    ( pi_aanroep    => 'SCHEMA.PACKAGE.OBJECT'
    , pi_param_name_01   => 'TEST'
    , pi_param_value_01  => null
    , pi_param_name_03   => null
    , pi_param_value_03  => null
    );

end;
/

begin
  pkg_utl_log.starten
    ( --pi_aanroep    => 'SCHEMA.PACKAGE.OBJECT'
     pi_param_name_01   => 'TEST'
    , pi_param_value_01  => null
    , pi_param_name_03   => null
    , pi_param_value_03  => null
    );
end;
/

begin
  pkg_utl_log.starten;
end;
/

begin
  pkg_utl_log.starten
    ( pi_aanroep    => 'SCHEMA.PACKAGE.OBJECT'
    );
end;
/

begin
  pkg_utl_log.starten
    ( pi_aanroep    => 'SCHEMA.PACKAGE.OBJECT'
    , pi_parameters => 'test => a'
    );
end;
/

select *
from fg_Data.log_logging
order by 1 desc

