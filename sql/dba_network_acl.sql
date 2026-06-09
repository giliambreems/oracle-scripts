select * from DBA_HOST_ACLS;
select * from DBA_HOST_ACES;
select * from DBA_NETWORK_ACLS;
select * from DBA_NETWORK_ACL_PRIVILEGES;


SELECT  p.host, p.lower_port, p.upper_port, p.ace_order, p.start_date, p.end_date, p.grant_type, p.inverted_principal, p.principal, p.principal_type, listagg(p.privilege, ',') WITHIN GROUP (ORDER BY PRIVILEGE) privileges
FROM   dba_host_aces p
where   host = '127.0.0.1' or host = '192.168.202.50'
GROUP BY p.host, p.lower_port, p.upper_port, p.ace_order, p.start_date, p.end_date, p.grant_type, p.inverted_principal, p.principal, p.principal_type
order by host, lower_port;


SELECT  p.*
FROM   dba_host_acls p;


begin
  --  (Holodeck-B2B) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 109
  , upper_port => 109
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'GDX_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  commit;
end;
/


begin
  -- Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 103
  , upper_port => 103
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );
  -- Resolve zonder port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => null
  , upper_port => null
  , ace        => xs$ace_type( privilege_list => xs$name_list('resolve')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );
  commit;
end;
/

BEGIN
  DBMS_NETWORK_ACL_ADMIN.remove_host_ace (
    host             => '192.168.202.50',
    lower_port       => 109,
    upper_port       => 109,
    ace              => xs$ace_type(privilege_list => xs$name_list('connect', 'resolve'),
                                    principal_name => 'GDX_SERVICE',
                                    principal_type => xs_acl.ptype_db),
    remove_empty_acl => TRUE);
END;
/
commit
/


-- Test Acceptance Production
begin
  --  (Microsoft Login) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => 70
  , upper_port => 70
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  --  (EDSN) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => 85
  , upper_port => 85
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (Fyber) Connect met port nr 87
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => 87
  , upper_port => 87
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (Vertex OLD) Connect met port nr 89
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => 89
  , upper_port => 89
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (Vertex NEW) Connect met port nr 93
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => 93
  , upper_port => 93
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (Ability) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => 96
  , upper_port => 96
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  --  (Adobe Sign) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => 99
  , upper_port => 99
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'APEX_230100'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (CDP/Bloomreadge) Connect met port nr (oud) TAP
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => 100
  , upper_port => 100
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (CDP/Bloomreadge) Connect met port nr (nieuw) O
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => 103
  , upper_port => 103
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (Verse) Connect met port nr 105
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => 105
  , upper_port => 105
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (Holodeck-B2B) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => 109
  , upper_port => 109
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'GDX_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- Resolve zonder port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '127.0.0.1'
  , lower_port => null
  , upper_port => null
  , ace        => xs$ace_type( privilege_list => xs$name_list('resolve')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );
end;
/


-- Development
begin
  -- (Microsoft Login) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 70
  , upper_port => 70
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  --  (EDSN) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 85
  , upper_port => 85
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (Fyber) Connect met port nr 87
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 87
  , upper_port => 87
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (Vertex Energy Essentials) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 93
  , upper_port => 93
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (Ability) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 96
  , upper_port => 96
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  --  (Adobe Sign) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 99
  , upper_port => 99
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'APEX_230100'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (CDP/Bloomreadge) Connect met port nr (oud) TAP
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 100
  , upper_port => 100
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (CDP/Bloomreadge) Connect met port nr (nieuw) O
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 103
  , upper_port => 103
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

    -- (Verse) Connect met port nr 105
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 105
  , upper_port => 105
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- (Holodeck-B2B) Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 109
  , upper_port => 109
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'GDX_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );

  -- Resolve zonder port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => null
  , upper_port => null
  , ace        => xs$ace_type( privilege_list => xs$name_list('resolve')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );
end;
/

commit
/



begin
  -- Connect met port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => 105
  , upper_port => 105
  , ace        => xs$ace_type( privilege_list => xs$name_list('connect')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );
  -- Resolve zonder port nr
  dbms_network_acl_admin.append_host_ace
  ( host       => '192.168.202.50'
  , lower_port => null
  , upper_port => null
  , ace        => xs$ace_type( privilege_list => xs$name_list('resolve')
                             , principal_name => 'FG_SERVICE'
                             , principal_type => xs_acl.ptype_db
                             )
  );
  commit;
end;
/




-- Old but organized/named way for ACL

BEGIN
  begin
      DBMS_NETWORK_ACL_ADMIN.create_acl (
        acl          => 'verse_pdf_generator.xml',  --name for acl
        description  => 'Connect to service that generates PDF files based on a predefined template and corresponding JSON input',  --purpose
        principal    => 'FG_SERVICE',  --schema
        is_grant     => TRUE,
        privilege    => 'connect',
        start_date   => SYSTIMESTAMP,
        end_date     => NULL);
    exception
      when

  DBMS_NETWORK_ACL_ADMIN.assign_acl (
    acl         => 'verse_pdf_generator.xml',
    host        => '192.168.202.50',
    lower_port  => 105,
    upper_port  => 105);

  COMMIT;
END;
/