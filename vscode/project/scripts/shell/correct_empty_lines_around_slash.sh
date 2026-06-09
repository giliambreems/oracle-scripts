#! /bin/bash

echo "List exported object files"
# git ls-files -o --exclude-standard     - List of all untracked files, excluding ignored files
# git diff --name-only                   - List of changed files
FILES=($(git ls-files -o --exclude-standard ./db && git diff --name-only ./db))   # Store exported object files in array (Untracked and Modified)

export LC_ALL=C  # Make the locale as C to use only ASCII character set with single byte encoding

for file in "${FILES[@]}"; do
  file_new=$file".new"
  #echo "cur $file"; echo "new $file_new"

  if [[ "${file}" == *.tps ]]
  then
    echo "${file}: We are dealing with a type specification, remove empty lines before \" )\""
    awk -v DESIRED_VAL=" )" -f "scripts/shell/correct_empty_lines_around_character.awk" $file > $file_new
    mv $file_new $file;  # Replace old with new file
  fi

  echo "${file}: Remove empty lines before /"
  awk -v DESIRED_VAL="/" -f "scripts/shell/correct_empty_lines_around_character.awk" $file > $file_new
  mv $file_new $file;  # Replace old with new file
done
