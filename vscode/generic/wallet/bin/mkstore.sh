#!/bin/bash
# set classpath for mkstore - align this to your local SQLcl installation
PROJECT=$(pwd)
TOOLS=${PROJECT}/../generic
SQLCL=${TOOLS}/sqlcl/lib
JAVA=${TOOLS}/graalvm
CLASSPATH=${SQLCL}/oraclepki.jar
CLASSPATH=${CLASSPATH}:${SQLCL}/osdt_core.jar
CLASSPATH=${CLASSPATH}:${SQLCL}/osdt_cert.jar

# SQLCL=${dirname ${which sql))/../lib  # This command requires sql location in PATH variable
CLASSPATH=${SQLCL}/oraclepki.jar:${SQLCL}/osdt_core.jar:${SQLCL}/osdt_cert.jar
# simulate mkstore command
${JAVA}/bin/java -classpath ${CLASSPATH} oracle.security.pki.OracleSecretStoreTextUI "$@"
