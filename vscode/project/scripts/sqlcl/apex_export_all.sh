#!/bin/bash

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

java -version ; echo ""  # Display the java version followed by an empty line


####
#
# Actual script
#
####

# Remove existing app and static file export for this app
echo Remove existing application export files
DIR="./apex/${APEXWORKSPACE}/" && [ -d "$DIR" ] && rm -r "$DIR"  # Assign folder to variable and remove folder if it exists
mkdir "$DIR" &&  mkdir "$DIR/apps"  # recreate apps folder because APEX export returns an error for a nonexisting folder

# Run the actual script in SQLcl
echo Run SQLcl to create all APEX Applications export files
echo Connect to database using Oracle Wallet \"${CONNECTION_STRING}\"
sql -l ${CONNECTION_STRING} @scripts/sqlcl/apex_export_all.sql

# Ignore files with line ending changes only (LF/CRLF) by adding and resetting all files to and from staging area
git add "${DIR}"  # Add all to staging area
git reset -q "${DIR}"  # Reset all to working area
