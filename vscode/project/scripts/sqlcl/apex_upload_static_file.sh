#!/bin/bash

# Usage notes:
# - Go to your GIT Project Root folder, e.g. c:\GIT\<project_folder>
#
# - For a static workspace/application file to upload, run as:
#     './scripts/sqlcl/apex_upload_static_file.sh "<FILE>"'
#

####
#
# Constants and variables
#
####

# Constants
CONFIG_DIR=./scripts/config  # local path to the configuration folder

STATIC_FILE_NAME=${1}

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

APEXUSERFILE=${CONFIG_DIR}/user.apex.env

java -version ; echo ""  # Display the java version followed by an empty line


####
#
# Script assertions and checks
#
####

# Check for APEX user configuration
OSUSER=`whoami`;  # OSUSER becomes local logged in OS user

if [ -f "${APEXUSERFILE}" ]
then
  echo "APEX User config file found" ;
  APEXUSER=`head -1 ${APEXUSERFILE}`  # Get APEX User by reading first line of config/env file
  
  if [[ "${APEXUSER}" != "" ]]
  then
    echo "APEX User has been configured to \"${APEXUSER}\"" ;
  else
    USELOCALUSER=true;
  fi
else
  USELOCALUSER=true;
fi

if [[ ${USELOCALUSER} == true ]]
then
  echo "No valid APEX User has been configured (correctly), the local OS user ${OSUSER^^} will be used.";
  APEXUSER="${OSUSER^^}";  # APEXUSER becomes local logged in OS user (in uppercase ^^)
fi

# Check for arguments
[ ! -z "${STATIC_FILE_NAME}" ] && { echo "Static file parameter set to ${STATIC_FILE_NAME}"; } || { echo "No argument has been given. Hint: Add static file as an argument and try again."; exit 0; }


####
#
# Actual script
#
####

# Run the actual script in SQLcl
echo Run SQLcl to upload static file $STATIC_FILE_NAME
echo Connect to database using Oracle Wallet \"${CONNECTION_STRING}\"
sql -l ${CONNECTION_STRING} @scripts/sqlcl/apex_upload_static_file.sql "${STATIC_FILE_NAME}" "${APEXUSER}" "${APEXWORKSPACE}"
