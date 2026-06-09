#!/bin/bash

# Usage notes:
# - Go to your GIT Project Root folder, e.g. c:\GIT\<project_folder>
#
# - To test your Java and SQLcl, run as:
#     './scripts/sqlcl/sqlcl_test.sh'
#


####
#
# Constants and variables
#
####

# Constants
CONFIG_DIR=./scripts/config  # local path to the configuration folder


#
# Choose the database you want to connect to
#
# The name of the database to connect to is stored in a config file to make the database configurable in these scripts.
# 
#   e.g. the value "test" in database.config refers to database/test.config for the database settings
#
DATABASE_FILE=${CONFIG_DIR}/database.config
DATABASE=`cat ${DATABASE_FILE} 2>/dev/null`  # Read database to use from configuration file

# Check for local database file
if [ -f "${DATABASE_FILE}" ] ; then
  echo "Database file found";
else
  echo "ERROR: File ${DATABASE_FILE} cannot be found, no database has been configured to use.";
  echo ""
  echo "  The file must only contain the name of the database file, without extension, that configures the correct database environment.";
  echo "  Database configuration files available: $(find ${CONFIG_DIR}/database/*.config -printf '%f ')"
  echo ""
  echo "  Add the correct database manually and try again, f.e. \"echo omio > ${DATABASE_FILE}\"";
  echo ""
  exit 0;
fi

[ -f "${CONFIG_DIR}/database/${DATABASE}.config" ] && { echo "Database config file found"; } || { echo "File ${CONFIG_DIR}/database/${DATABASE}.config cannot be found, no database settings available. Hint: add database configuration file and try again."; exit 0; }
[ -f "${CONFIG_DIR}/env.config" ] && { echo "Environment config file found"; } || { echo "File ${CONFIG_DIR}/env.config cannot be found, no environment settings available. Hint: an example of env.config can be found in config/examples folder "; exit 0; }


# Read configuration files into current shell
source ${CONFIG_DIR}/database/${DATABASE}.config  # set database/apex configuration variables using an external config file
source ${CONFIG_DIR}/env.config  # set environment variables for java_home, sqlcl and path

# PASSWD_FILE=${CONFIG_DIR}/${DBSERVICE}.${DBUSER}.pwd  # define password filename

java -version ; echo ""  # Display the java version followed by an empty line


####
#
# Assertions and checks
#
####

# Check for arguments
# [ ! -z "${1}" ] && { echo "Application parameter set to ${1}"; } || { echo "No argument has been given. Hint: Add <APP_ID> or \"WSF\" as an argument and try again."; exit 0; }

# Check for local password file
# [ -f "${PASSWD_FILE}" ] && { echo "Password file found"; PASSWD=`cat ${PASSWD_FILE}`; } || { echo "File ${PASSWD_FILE} cannot be found, no password available. Hint: add password file manually and try again."; exit 0; }


####
#
# The actual script
#
####

# Remove existing app and static file export for this app
#echo Remove existing application ${1} export files
# [ -d "${APEX_APPLICATION_DIR/f${1}" ] && rm -r "${APEX_APPLICATION_DIR}/f${1}"  # Remove folder if it exists
# [ -d "${APEX_STATIC_FILE_DIR}/f${1}" ] && rm -r "${APEX_STATIC_FILE_DIR}/f${1}"  # Remove folder if it exists

# Run the actual script in SQLcl
echo Run SQLcl to create APEX Application ${1} export files
echo Connect to ${DBUSER=}@${DBCONN}
sql //nolog

# \Ignore files with line ending changes only (LF/CRLF) by adding and resetting all files to and from staging area
# echo Ignore files with LF/CRLF changes only
# git add ${APEX_APPLICATION_DIR}/f${1} ${APEX_STATIC_FILE_DIR}/f${1}  # Add all to staging area
# git reset -q  ${APEX_APPLICATION_DIR}/f${1} ${APEX_STATIC_FILE_DIR}/f${1}  # Reset all to working area
