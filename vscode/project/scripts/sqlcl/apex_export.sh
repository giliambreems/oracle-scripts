#!/bin/bash

# Usage notes:
# - Go to your GIT Project Root folder, e.g. c:\GIT\<project_folder>
#
# - For an application and its application static files, run as:
#     './scripts/sqlcl/apex_export.sh "<APP_ID>"'
#
# - For all workspace static files, run as:
#     './scripts/sqlcl/apex_export.sh "WSF"'
#

####
#
# Constants and variables
#
####

# Constants
CONFIG_DIR=./scripts/config  # local path to the configuration folder

APEX_APP_ID=${1}

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

java -version ; echo ""  # Display the java version followed by an empty line


####
#
# Script assertions and checks
#
####

# Check for arguments
[ ! -z "${APEX_APP_ID}" ] && { echo "Application parameter set to ${APEX_APP_ID}"; } || { echo "No argument has been given. Hint: Add \"<APP_ID>\" or \"WSF\" as an argument and try again."; exit 0; }


####
#
# Actual script
#
####

# Remove existing app and static file export for this app
APP_DIR="${APEX_APPLICATION_DIR}/f${APEX_APP_ID}"  # APEX Application Files
ASF_DIR="${APEX_STATIC_FILE_DIR}/f${APEX_APP_ID}"  # Application Static Files
WSF_DIR="${APEX_STATIC_FILE_DIR}/workspace"        # Workspace Static Files

if [ "${APEX_APP_ID}" -eq "${APEX_APP_ID}" ] 2>/dev/null; then
  echo Remove existing application ${APEX_APP_ID} export files
  [ -d "${APP_DIR}" ] && rm -r "${APP_DIR}"  # Remove folder if it exists
  [ -d "${ASF_DIR}" ] && rm -r "${ASF_DIR}"  # Remove folder if it exists

elif [ "${APEX_APP_ID^^}" == "WSF" ]; then
  echo Remove existing workspace static files
  [ -d "${WSF_DIR}" ] && rm -r "${WSF_DIR}"  # Remove folder if it exists
fi


# Run the export script in SQLcl
echo Run SQLcl to create APEX Application ${APEX_APP_ID} export files
echo Connect to database using Oracle Wallet \"${CONNECTION_STRING}\"
sql -l ${CONNECTION_STRING} @scripts/sqlcl/apex_export.sql ${APEX_APP_ID} ${APEXWORKSPACE}


# Ignore files with line ending changes only (LF/CRLF) by adding and resetting all files to and from staging area
echo Ignore files with LF/CRLF changes only
if [ "${APEX_APP_ID}" -eq "${APEX_APP_ID}" ] 2>/dev/null; then
  echo "..add files to GIT index"
  git add "${APP_DIR}" "${ASF_DIR}"  # Add all to staging area
  echo "..remove files from GIT index"
  git reset -q  "${APP_DIR}" "${ASF_DIR}"  # Reset all to working area

elif [ "${APEX_APP_ID^^}" == "WSF" ]; then
  echo "..add files to GIT index"
  git add "${WSF_DIR}"  # Add all to staging area
  echo "..remove files from GIT index"
  git reset -q "${WSF_DIR}"  # Reset all to working area
fi
