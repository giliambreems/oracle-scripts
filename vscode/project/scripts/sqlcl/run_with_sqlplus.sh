#!/bin/bash

# Usage notes:
# - Go to your GIT Project Root folder, e.g. c:\GIT\<project_folder>
#
# - To open a SQLcl session, run as:
#     './scripts/sqlcl/run_with_sqlplus.sh "<file_name>"'
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
FILE_NAME="$1"
echo "Filename: ${FILE_NAME}"

# Get schema_owner from the database folder location and use it as connecting db user
SCHEMA_OWNER=$(awk -F\\ '{print $2}' <<< "${FILE_NAME}")  # The second part represents the schema_owner
echo "Connecting DB user: ${SCHEMA_OWNER}"

# Read configuration files into current shell
source ${CONFIG_DIR}/database/${DATABASE}.config  # set database/apex configuration variables using an external config file
source ${CONFIG_DIR}/env.config  # set environment variables for java_home, sqlcl and path

java -version ; echo ""  # Display the java version followed by an empty line

# Configure local variables
TEMPDIR=./temp
TEMPFILE="${TEMPDIR}/last_script.sql"

if [[ ! -d "${TEMPDIR}" ]]; then mkdir ${TEMPDIR}; fi  # Create subfolder if not exists

echo "set define off" > ${TEMPFILE}
echo -e "\n" >> ${TEMPFILE}  # add new line
cat ${FILE_NAME} >> ${TEMPFILE}  # output content of file into tempfile
echo -e "\n" >> ${TEMPFILE}  # add new line
echo "exit" >> ${TEMPFILE}  # exit sqlplus/sqlcl after running the script.

# Run the actual script in SQL*Plus
echo "Run SQL*Plus to execute script"
echo Connect to database using Oracle Wallet \"${CONNECTION_STRING}\"
sqlplus -l ${CONNECTION_STRING} @${TEMPFILE}

rm "${TEMPFILE}"