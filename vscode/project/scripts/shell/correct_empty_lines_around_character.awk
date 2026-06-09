# AWK script file
# Provides:
#   - Remove trailing whitespaces on each line
#   - Clearing all empty lines in front of desired value (/)
#   - Maintain exactly 1 empty lines after a desired value (/)
# Usage: awk -v DESIRED_VAL="your_value" -f "awk_script_filename" input_filename
#
# Release notes
# 2021-12-10  Giliam Breems   Initial version
#
# -------------------------------------------

BEGIN { i=0; j=0 }
{ 
  gsub(/[ \t]+$/,"",$0);  # Remove trailing whitespaces

  # If line is empty and don't follow-up on a forward slash - save counts of empty strings
  if ( length($0) == 0 ) {
    if ( j == 0 ) { i++; }
  }

  # If line is not empty and is DESIRED_VAL, print it  
  if ( length ($0) != 0 && $0 == DESIRED_VAL )
  {
    print $0; i=0; j=1;
  }

  # If line is not empty and not DESIRED_VAL, print all empty str and current
  if ( length ($0) != 0 && $0 != DESIRED_VAL )
  {   
    for (m=0;m<i;m++) { print ""; }

    # If previous line is DESIRED_VALUE, print empty line and reset
    #if ( j == 1 ) {  if ( $0 != "SHOW ERROR" ) { print "SHOW ERROR"; print "";} j=0; }
    if ( j == 1 ) { print ""; j=0; }
  
    i=0; print $0;
  }
}

# If last lines is empty, print it
END { for (m=0;m<i;m++) { print ""; } }