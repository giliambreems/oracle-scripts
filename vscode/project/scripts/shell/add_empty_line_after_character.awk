# AWK script file
# Provides adding an empty line after a desired value
# Usage: awk -v DESIRED_VAL="your_value" -f "awk_script_filename" input_filename
#
# Release notes
# 2021-12-10  Giliam Breems   Initial version
#
# -------------------------------------------

BEGIN { j=0 }
{
  # If line is empty, print and reset
  if ( length ($0) == 0 ) { print $0; j=0; }

  # If line is not empty and is DESIRED_VAL, print and remember
  if ( length ($0) != 0 && $0 == DESIRED_VAL  ) { print $0; j=1; }

  # If line is not empty and is not DESIRED_VAL and j = 1
  if ( length ($0) != 0 && $0 != DESIRED_VAL ) {
    
    # If previous line is DESIRED_VALUE, print empty line and reset
    if ( j == 1 ) { print ""; j=0; }
    
    print $0;
  }
}

# If last lines is empty, print it
END { print ""; }
