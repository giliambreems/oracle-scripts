#!/bin/bash
#
# Usage notes:
# - Go to your GIT Project Root folder, e.g. c:\GIT\<project_folder>
#
# - For a specific database object:
#     './scripts/sqlcl/schema_export.sh "<OBJECT_OWNER>" "<OBJECT_TYPE>" "<OBJECT_NAME>"'
#
# - For all objects of a specific database type:
#     './scripts/sqlcl/schema_export.sh "<OBJECT_OWNER>" "<OBJECT_TYPE>" "ALL"'
#
# - For all objects of all database types:
#     './scripts/sqlcl/schema_export.sh "<OBJECT_OWNER>" "ALL" "ALL"'
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


# Configure input parameters
SCHEMA_OWNER="$1"  # This also becomes the connecting db user
OBJECT_TYPE="$2"
OBJECT_NAME="$3"

echo "Object owner: ${SCHEMA_OWNER}"
echo "Object type: ${OBJECT_TYPE}"
echo "Object name: ${OBJECT_NAME}"


# Read configuration files into current shell
source ${CONFIG_DIR}/database/${DATABASE}.config  # set database/apex configuration variables using an external config file
source ${CONFIG_DIR}/env.config  # set environment variables for java_home, sqlcl and path

java -version ; echo ""  # Display the java version followed by an empty line

# Configure local variables
DIR="./db"

# Run the actual script in SQLcl
echo Run SQLcl to create export of Database Object "${SCHEMA_OWNER}"."${OBJECT_NAME}"
echo Connect to database using Oracle Wallet \"${CONNECTION_STRING}\"

if [[ "${SCHEMA_OWNER}" == "" ]]
then
  echo No OWNER parameter input found
  echo
  echo "    Usage: sql <CONNECTION_STRING> @scripts/sqlcl/schema_export.sql <SCHEMA_OWNER>"
  echo

  exit
elif [[ "${OBJECT_TYPE}" == "" ]]
then
  echo No OBJECT_TYPE parameter input found, default OBJECT_TYPE and OBJECT_NAME input becomes ALL
  echo
  echo "    Input parameter OBJECT_TYPE set to default (ALL)"
  echo "    Input parameter OBJECT_NAME set to default (ALL)"
  echo

  sql -l ${CONNECTION_STRING} @scripts/sqlcl/schema_export.sql "${SCHEMA_OWNER}" "ALL" "ALL" "${GRANTEE_OBJECT_PRIVS}" "${SPLITFKS}" "${SPLITGRANTS}"
elif [[ "${OBJECT_NAME}" == "" ]]
then
  echo No OBJECT_NAME parameter input found, default OBJECT_NAME input becomes ALL
  echo
  echo "    Input parameter OBJECT_NAME set to default (ALL)"
  echo

  sql -l ${CONNECTION_STRING} @scripts/sqlcl/schema_export.sql "${SCHEMA_OWNER}" "${OBJECT_TYPE}" "ALL" "${GRANTEE_OBJECT_PRIVS}" "${SPLITFKS}" "${SPLITGRANTS}"
else
  sql -l ${CONNECTION_STRING} @scripts/sqlcl/schema_export.sql "${SCHEMA_OWNER}" "${OBJECT_TYPE}" "${OBJECT_NAME}" "${GRANTEE_OBJECT_PRIVS}" "${SPLITFKS}" "${SPLITGRANTS}"
fi

echo "Alter scripts to be compliant with SQL*Plus 11.2"
./scripts/shell/correct_empty_lines_around_slash.sh  # Call an awk script that corrects all empty lines before a forward slash character

Echo "Copy file(s) to ./oplev folder"
if [[ "${OBJECT_TYPE}" != "ALL" ]] && [[ "${OBJECT_NAME}" != "ALL" ]]
then
  USERSTORY=`git rev-parse --abbrev-ref HEAD`
  DIR_RELEASE=./oplev
  DIR_BRANCH=${DIR_RELEASE}/${USERSTORY}/dbenarule
  if [[ "${USERSTORY}" == "main" ]]; then
    if [[ ! -d "${DIR_RELEASE}" ]]; then mkdir ${DIR_RELEASE}; fi  # Create subfolder if not exists
    find ./db -name "${OBJECT_NAME}.*" -exec cp {} ${DIR_RELEASE} \;  # Copy file(s) to ./oplev folder
  else
    if [[ ! -d "${DIR_BRANCH}" ]]; then mkdir -p ${DIR_BRANCH}; fi  # Create subfolder(s) if they do not exists
    find ./db -name "${OBJECT_NAME}.*" -exec cp {} ${DIR_BRANCH} \;  # Copy file(s) to ./oplev/<PROJ_ALIAS>-xxxxx/dbenarule folder
  fi
fi

# Ignore files with line ending changes only (LF/CRLF) by adding and resetting all files to and from staging area
echo "Remove files with CRLF <> LF changes only"
git add "${DIR}"  # Add all to staging area
git reset -q "${DIR}"  # Reset all to working area
