-- SQLcl uses the SQLCL engine for formatted sql changelog not the JDBC engine
-- By default, a project will not use substitution variables and allows blank
-- lines in sql statements.

@@utils/drop-all-schema-objects.sql
@@install.sql &1 &2
