# Met deze 12 tests heb je eigenlijk alle relevante paden afgedekt:
#  - defaults;
#  - proxy schema;
#  - JDBC-prefix;
#  - custom host/port/service;
#  - host met en zonder //;
#  - complete descriptor;
#  - username met punt;
#  - validatie van drivercomponenten;
#  - validatie van de parameter sets.

# 1. Minimal connection string (defaults)
New-OracleConnectionString `
    -Username 'USERNAME' `
    -Password 'secret'

# Expected:
# "USERNAME"/secret@//localhost:1521/FREEPDB1


# 2. Minimal connection string with proxy schema
New-OracleConnectionString `
    -Username 'USERNAME' `
    -ProxySchema 'RELEASE' `
    -Password 'secret'

# Expected:
# "USERNAME"[RELEASE]/secret@//localhost:1521/FREEPDB1


# 3. Complete JDBC connection using defaults
New-OracleConnectionString `
    -Username 'USERNAME' `
    -Password 'secret' `
    -Protocol 'jdbc' `
    -Vendor 'oracle' `
    -DriverType 'thin'

# Expected:
# "USERNAME"/secret@jdbc:oracle:thin:@//localhost:1521/FREEPDB1


# 4. Complete JDBC connection with custom host/service
New-OracleConnectionString `
    -Username 'USERNAME' `
    -Password 'secret' `
    -Protocol 'jdbc' `
    -Vendor 'oracle' `
    -DriverType 'thin' `
    -HostName 'dbserver' `
    -Port 1522 `
    -ServiceName 'HMEDB001'

# Expected:
# "USERNAME"/secret@jdbc:oracle:thin:@//dbserver:1522/HMEDB001


# 5. Host already contains //
New-OracleConnectionString `
    -Username 'USERNAME' `
    -Password 'secret' `
    -HostName '//dbserver'

# Expected:
# "USERNAME"/secret@//dbserver:1521/FREEPDB1


# 6. Complete descriptor
New-OracleConnectionString `
    -Username 'USERNAME' `
    -Password 'secret' `
    -ConnectDescriptor 'jdbc:oracle:thin:@//dbserver:1522/HMEDB001'

# Expected:
# "USERNAME"/secret@jdbc:oracle:thin:@//dbserver:1522/HMEDB001


# 7. Complete descriptor with proxy schema
New-OracleConnectionString `
    -Username 'USERNAME' `
    -ProxySchema 'RELEASE' `
    -Password 'secret' `
    -ConnectDescriptor 'jdbc:oracle:thin:@//dbserver:1522/HMEDB001'

# Expected:
# "USERNAME"[RELEASE]/secret@jdbc:oracle:thin:@//dbserver:1522/HMEDB001


# 8. Username containing a dot
New-OracleConnectionString `
    -Username 'USER.NAME' `
    -Password 'secret'

# Expected:
# "USER.NAME"/secret@//localhost:1521/FREEPDB1


# 9. Username containing a dot with proxy schema
New-OracleConnectionString `
    -Username 'USER.NAME' `
    -ProxySchema 'RELEASE' `
    -Password 'secret'

# Expected:
# "USER.NAME"[RELEASE]/secret@//localhost:1521/FREEPDB1


# 10. Invalid: only Protocol specified
New-OracleConnectionString `
    -Username 'USERNAME' `
    -Password 'secret' `
    -Protocol 'jdbc'

# Expected:
# Protocol, Vendor and DriverType must either all be specified or all be omitted.


# 11. Invalid: Protocol + Vendor only
New-OracleConnectionString `
    -Username 'USERNAME' `
    -Password 'secret' `
    -Protocol 'jdbc' `
    -Vendor 'oracle'

# Expected:
# Protocol, Vendor and DriverType must either all be specified or all be omitted.


# 12. Invalid: ConnectDescriptor combined with HostName
New-OracleConnectionString `
    -Username 'USERNAME' `
    -Password 'secret' `
    -ConnectDescriptor 'jdbc:oracle:thin:@//localhost:1521/FREEPDB1' `
    -HostName 'dbserver'

# Expected:
# Parameter set cannot be resolved using the specified named parameters.