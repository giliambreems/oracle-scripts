# AWK script file
# Provides clearing all empty lines in front of desired value 
# Usage: awk -v DESIRED_VAL="your_value" -f "awk_script_filename" input_filename
#
# Release notes
# 2021-12-10  Giliam Breems   Initial version
#
# -------------------------------------------

BEGIN { i=0 }
{ 
  # If line is empty - save counts of empty strings
  if ( length($0) == 0 ) { i++; }

  # If line is not empty and is DESIRED_VAL, print it  
  if ( length ($0) != 0 && $0 == DESIRED_VAL )
  {
    print $0; i=0;
  }

  # If line is not empty and not DESIRED_VAL, print all empty str and current
  if ( length ($0) != 0 && $0 != DESIRED_VAL )
  {   
    for (m=0;m<i;m++) { print ""; } i=0; print $0;
  }
}

# If last lines is empty, print it
END { for (m=0;m<i;m++) { print ""; } }