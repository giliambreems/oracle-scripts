Branch = feature/init_sqlcl_project




SQL> project verify -verbose
-------- Results Summary ----------
Errors:     1
Warnings:   0
Info:       8
---------------------------------

 ------- ------------ -------------------------- ----------------------------------------------------------------------------------
  Level   Group Name   Test Name                  Message
 ------- ------------ -------------------------- ----------------------------------------------------------------------------------
  INFO    settings     verifynonpublicsettings    No unsupported internal settings found

  INFO    init         verifyprojectname          The final project name will be "GasDataExchange"

  INFO    stage        stagechangelogfilesvalid   .dbtools/project.config.json generated format: liquibase
                                                  All included scripts are present, not cross-referencing and readable (3 checked)

  INFO    stage        stagesoftobjectisolation   SoftObjectIsolation: Change
                                                  OK: Code folder is absent.

  INFO    stage        stageduplicateentries      .dbtools/project.config.json generated format: liquibase
                                                  dist\releases\main.changelog.xml - There are no duplicate entries.
                                                  RELEASE CHANGELOGS - There are no duplicate entries.
                                                  TICKET CHANGELOGS - There are no duplicate entries.

  ERROR   stage        stagechangelogcomplete     stage.changelog file not found:
                                                  dist\releases\next\changes\feature\init_sqlcl_project\stage.changelog.xml

  INFO    stage        stagesourcediff            All modified files are represented in dist folder
                                                  All changes in dist folder are represented in src folder

  INFO    project      sqlclversion               SQLcl Version check passed

  INFO    snapshot     verifysnapshot             Snapshot validation found no issues.






Manually renamed dist\releases\next\changes\featureinit_sqlcl_project to dist\releases\next\changes\feature\init_sqlcl_project





SQL> project verify -verbose
-------- Results Summary ----------
Errors:     2
Warnings:   0
Info:       7
---------------------------------

 ------- ------------ -------------------------- ----------------------------------------------------------------------------------------------
  Level   Group Name   Test Name                  Message
 ------- ------------ -------------------------- ----------------------------------------------------------------------------------------------
  INFO    settings     verifynonpublicsettings    No unsupported internal settings found

  INFO    init         verifyprojectname          The final project name will be "GasDataExchange"

  ERROR   stage        stagechangelogfilesvalid   .dbtools/project.config.json generated format: liquibase
                                                  There is one missing file out of 2:
                                                  Included in dist\releases\next\release.changelog.xml:
                                                          dist\releases\next\changes\featureinit_sqlcl_project\stage.changelog.xml

  INFO    stage        stagesoftobjectisolation   SoftObjectIsolation: Change
                                                  OK: Code folder is absent.

  ERROR   stage        stageduplicateentries      .dbtools/project.config.json generated format: liquibase
                                                  dist\releases\main.changelog.xml - There are no duplicate entries.
                                                  RELEASE CHANGELOGS - There are no duplicate entries.
                                                  Issue reading file: dist\releases\next\changes\featureinit_sqlcl_project\stage.changelog.xml
                                                  TICKET CHANGELOGS - There are no duplicate entries.

  INFO    stage        stagechangelogcomplete     Stage Changelog validation found no issues.

  INFO    stage        stagesourcediff            All modified files are represented in dist folder
                                                  All changes in dist folder are represented in src folder

  INFO    project      sqlclversion               SQLcl Version check passed

  INFO    snapshot     verifysnapshot             Snapshot validation found no issues.


