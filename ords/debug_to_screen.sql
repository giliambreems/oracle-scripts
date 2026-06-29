-- Turn on ORDS debugging and tracing for the registered schema. This will print debug information to the screen when you run your ORDS REST services.
begin
    ords_admin.set_property(
    p_schema => '<ords_enabled_schema>',
    p_key    => 'debug.printDebugToScreen',
    p_value  => 'true'
    );
end;
/

commit
/

-- Turn off ORDS debugging and tracing for the registered schema. This will print debug information to the screen when you run your ORDS REST services.
begin
    ords_admin.set_property(
    p_schema => '<ords_enabled_schema>',
    p_key    => 'debug.printDebugToScreen',
    p_value  => 'false'
    );
end;
/

commit
/

alter user <ords_enabled_schema> revoke connect through "ORDS_PUBLIC_USER"
/

alter user <ords_enabled_schema> grant connect through "ORDS_PUBLIC_USER"
/

grant read on ORDS_METADATA.user_ords_modules    to <ords_enabled_schema>;
grant read on ORDS_METADATA.user_ords_templates  to <ords_enabled_schema>;
grant read on ORDS_METADATA.user_ords_handlers   to <ords_enabled_schema>;
grant read on ORDS_METADATA.user_ords_parameters to <ords_enabled_schema>;
