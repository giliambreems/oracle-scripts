/**
* 
* NAME: apex_export.js
*
* DESC: use script to export/download an APEX application with its static files from APEX workspace
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
* 12-10-2023 G.P. Breems    Support SQLcl 23.x
* 02-11-2023 G.P. Breems    Make generic for usage in multiple Environments/Workspaces
*
**/

debug_on = false;
// debug_on = true;   // Remove comment tags to set debug on

// Give positional input parameters logical names
var appId       = args[1];
var workspace   = args[2];
var workspaceId = args[3];

function getApplicationId() { return appId; } // return applicationId
function getWorkspaceId() { return workspaceId; } // return workspaceId
function getWorkspace()   { return workspace; } // return workspace
function getBaseFolder()  { return "apex/"+ getWorkspace().toLowerCase(); } // return local base folder
function getBaseFolderApp()    { return getBaseFolder() + "/apps"; } // return local app base folder
function getBaseFolderStatic() { return getBaseFolder() + "/static"; } // return local static files base folder

var new_line = '\n';

var dml = {}
    dml.createSession = 'begin wwv_flow_api.set_security_group_id('+getWorkspaceId()+'); end;\n';

var query = {}
    query.app = 'select application_id' + new_line +
                'from   APEX_APPLICATIONS app' + new_line +
                'where  workspace_id = '+ getWorkspaceId() + new_line +
                'order by application_id' + new_line;
    query.saf = 'select application_file_id as id,'+ new_line +
                '       file_content as content,'+ new_line +
                '       \'' + getBaseFolderStatic() + '\' as root_folder,'+ new_line +
                '       \'f\' || application_id as app_folder,'+ new_line +
                '       substr(file_name, 1, instr(file_name, \'/\', -1) -1) as sub_folder,'+ new_line +
                '       substr(file_name, instr(file_name, \'/\', -1)+ 1)    as file_name'+ new_line +
                'from   APEX_APPLICATION_STATIC_FILES'+ new_line +
                'where  1 = 1'+ new_line +
                '%ADDITIONALWHERECLAUSE%'+ new_line +
                'order by root_folder, app_folder, sub_folder, file_name' + new_line;
    query.swf = 'select workspace_file_id as id,'+ new_line +
                '       file_content as content,'+ new_line +
                '       \'' + getBaseFolderStatic() + '\' as root_folder,'+ new_line +
                '       \'workspace\' as app_folder,'+ new_line +
                '       substr(file_name, 1, instr(file_name, \'/\', -1) -1) as sub_folder,'+ new_line +
                '       substr(file_name, instr(file_name, \'/\', -1)+ 1)    as file_name'+ new_line +
                'from   APEX_WORKSPACE_STATIC_FILES'+ new_line +
                'order by root_folder, app_folder, sub_folder, file_name' + new_line;



/*
// Example code to walk through a fileTree
// Source:  https://gist.github.com/botic/8505584

importPackage(java.nio.file);

var createVisitor = function(files, positive, path) {
   return new JavaAdapter(java.nio.file.SimpleFileVisitor, {
      preVisitDirectory: function (dir, attrs) {
         // Directories with "_positive_" in their names are positive instances,
         // with "_negative_" are negative instances.
         if (path.equals(dir) || dir.toString().toLowerCase().indexOf(positive ? "_positive_" : "_negative_") >= 0) {
            return FileVisitResult.CONTINUE;
         } else {
            // Skip directory if name is neither a positive nor a negative instance
            return FileVisitResult.SKIP_SUBTREE;
         }
      },
      visitFile: function (file, attrs) {
         files.push(file.toString());
         return FileVisitResult.CONTINUE;
      }
   });
};

exports.walkTree = function (path) {
   java.nio.file.Files.walkFileTree(
      FileSystems.getDefault().getPath(path), 
      createVisitor(this.positiveInstances, true, FileSystems.getDefault().getPath(path))
   );
   
   java.nio.file.Files.walkFileTree(
      FileSystems.getDefault().getPath(path), 
      createVisitor(this.positiveInstances, false, FileSystems.getDefault().getPath(path))
   );
};
*/

function print( input) {
  ctx.write(input + new_line);
}

function debug( input) {
  if (debug_on) {
    print (input);
  }
}

function createFolder( folder) {
  path = java.nio.file.FileSystems.getDefault().getPath( folder );
  pathExists = java.nio.file.Files.exists( path);

  if (!pathExists) {
    debug('Folder \''+folder+'\' does not exists, created..');
    newDir = java.nio.file.Files.createDirectories( path );  // Create complete folder structure
  } else {
    // Do nothing, folder path already exists
    debug('Folder \''+folder+'\' already exists..');
  }
}

function executeQuery(query, binds, additionalWhereClause) {

  binds = (typeof binds === 'undefined') ? {} : binds; // Default empty binds object, i.s.o. undefined
  additionalWhereClause = (typeof additionalWhereClause === 'undefined') ? '' : additionalWhereClause; // Default empty additional where clause, i.s.o. undefined

  debug('query before:');debug( query); debug('binds :'); debug( JSON.stringify(binds)); debug( 'additionalWhereClause : ' + additionalWhereClause);

  query = query.replace( '%ADDITIONALWHERECLAUSE%', additionalWhereClause);
  debug('query after:');debug( query);

  var ret = util.executeReturnList( query, binds);
  if(!ret){
    throw util.getLastException(); 
  }

  debug(ret);

  return ret;
}

// function displays an error message on screen
function errorMsg (message) {
  writeLine ("");
  writeLine ("##################################################");
  writeLine ("== ERROR == ");
  writeLine (message);
  writeLine ("");
  writeLine ("Call this script with parameter 'help' for usage");
  writeLine ("##################################################");
  writeLine ("");
}
 
function displayHelp (scriptName) {
  writeLine (''                                                                           );
  writeLine ('===========================================================================');
  writeLine ('Usage of script ' + scriptName                                              );
  writeLine ('~~~~~~~~~~~~~~~~~~~~~~~~~'                                                  );
  writeLine (scriptName + ' help'                                                         );
  writeLine ('  => Display this help text'                                                );
  writeLine (''                                                                           );
  writeLine (scriptName + ' app_id [app_id] app_id]'                                      );
  writeLine ('  => Exports the given application id(\'s)'                                 );
  writeLine (''                                                                           );
  writeLine ('     Only the first parameter (pathname) is mandatory'                      );
  writeLine (''                                                                           );
  writeLine ('     Parameter'                                                             );
  writeLine ('     app_id        : application id(\'s) that needs to be exported'         );
  writeLine ('                     e.g. 100'                                              );
  writeLine (''                                                                           );
  writeLine ('===========================================================================');
  writeLine (''                                                                           );
}
 
// Function will make SQLcl run the statement that is passed in the parameter
function runStmnt (stmnt) {
  debug(stmnt);
  sqlcl.setStmt(stmnt);
  sqlcl.run();
}

function exportFile (content, fileName, folder) {
  var File = java.nio.file;

  // Check if folder exists
  createFolder(folder);

  // Show path + file name to export
  print( folder  + "/" + fileName);

  // GET the BLOB stream
  var blobStream = content.getBinaryStream(1);

  // GET the path/file handle TO WRITE TO
  var path = File.FileSystems.getDefault().getPath( folder + '/' + fileName);

  // Dump the file stream TO the file
  File.Files.copy( blobStream, path, File.StandardCopyOption.REPLACE_EXISTING);
}

function exportApplication ( appId, exportFolder, indSplit) {
  //
  // Check if folder exists
  createFolder(exportFolder);

  var stmt = 'apex export -applicationid %APPLICATIONID% -dir %EXPORTFOLDER% -skipExportDate %SPLIT%';
  
  stmt = stmt.replace( '%APPLICATIONID%', appId);
  stmt = stmt.replace( '%EXPORTFOLDER%', exportFolder);
  stmt = stmt.replace( '%SPLIT%', ((indSplit === 'Y') ? '-split' : ''));
  
  runStmnt( stmt);
}

function exportStaticApplicationFiles (appId) {

  // execute pre query to set apex session for correct result on static application files
  ret = executeQuery(dml.createSession);

  // execute query to list all static workspace and application files
  var binds = {}
  var additionalWhereClause = 'and application_id = ' + appId;
  ret = executeQuery(query.saf, binds, additionalWhereClause);

  // loop the results
  for (i = 0; i < ret.length; i++) {
    var folder  = ret[i].ROOT_FOLDER + '/' + ret[i].APP_FOLDER + ((ret[i].SUB_FOLDER) ? '/' + ret[i].SUB_FOLDER : '');
    var file    = ret[i].FILE_NAME;
    var content = ret[i].CONTENT;

    debug(folder);
    exportFile( content, file, folder);
  }

  print( new_line + ret.length +' static application files have been exported');
}

function exportStaticWorkspaceFiles (workspaceId, exportFolder, source) {

  source = ((source === 'Y') ? true : false);
  if (!source) {
    //
    var stmt = 'apex export -workspaceid %WORKSPACEID% -dir %EXPORTFOLDER% -expFiles -skipExportDate';
    stmt = stmt.replace( '%WORKSPACEID%', workspaceId);
    stmt = stmt.replace( '%EXPORTFOLDER%', exportFolder);
    runStmnt( stmt);
  }
  else {
  
    // execute pre query to set apex session for correct result on static application files
    ret = executeQuery(dml.createSession);

    // execute query to list all static workspace and application files
    ret = executeQuery(query.swf);

    // loop the results
    for (i = 0; i < ret.length; i++) {
      var folder  = ret[i].ROOT_FOLDER + '/' + ret[i].APP_FOLDER + ((ret[i].SUB_FOLDER) ? '/' + ret[i].SUB_FOLDER : '');
      var file    = ret[i].FILE_NAME;
      var content = ret[i].CONTENT;

      debug(folder);
      exportFile( content, file, folder);
    }

    print( new_line + ret.length +' static workspace files have been exported');
  }
}

function mainCode (scriptArgs) {
  var argCount  = scriptArgs.length - 1;
  var exportFolder = {}
      exportFolder.application = "./" + getBaseFolderApp();
      exportFolder.staticFiles = "./" + getBaseFolderStatic();
      exportFolder.release     = "./oplev";

  debug(">> scriptArgs.length: " + scriptArgs.length);
  for (i = 0; i < scriptArgs.length; i++) {
    debug( ">> scriptArgs["+i+"]: "+ scriptArgs[i] );
  }
  debug(">> argCount: " + argCount);

  if (argCount > 3) {
    errorMsg ("Too many parameters (" + argCount + ")");
  
  }
  else if ((argCount === 0) ||
             ((argCount === 1) && (scriptArgs[1].toLowerCase() === "help"))
            ) {
    displayHelp (scriptArgs[0]);
  }
  else if ((scriptArgs[1].toLowerCase() === "wsf")) {
    runStmnt( 'PROMPT Exporting \'Static Workspace Files\' (GIT source files)');
    exportStaticWorkspaceFiles( getWorkspaceId(), exportFolder.staticFiles, 'Y' );  // export as individual component files

    runStmnt( 'PROMPT Exporting \'Static Workspace Files\' (APEX release file)');
    exportStaticWorkspaceFiles( getWorkspaceId(), exportFolder.release, 'N' );  // export as all-in-one release file 
  }
  else if ((argCount === 1) && (scriptArgs[1].toLowerCase() === "all")) {
    print('This function is not working yet, work in progress!\n');
    ret2 = executeQuery(query.app);
    for (i = 0; i < ret2.length; i++) {
      //print(ret2[i].APPLICATION_ID);
      //mainCode([args[0], ret2[i].APPLICATION_ID.toString()]);
    }
    //mainCode([args[0], 'wsf']);
  }
  else {
    runStmnt( 'PROMPT Export \'APEX application\' (GIT source files)');
    exportApplication( getApplicationId(), exportFolder.application, 'Y' );  // export as individual component files

    runStmnt( 'PROMPT Exporting \'Static Application Files\' (GIT source files)');
    exportStaticApplicationFiles( getApplicationId());  // export static application files

    runStmnt( 'PROMPT Export \'APEX application\' (APEX release file)');
    exportApplication( getApplicationId(), exportFolder.release, 'N' );  // export as all-in-one release file
  }
}

mainCode(args);
