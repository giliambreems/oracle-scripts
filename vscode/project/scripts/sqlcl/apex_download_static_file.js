/**
* 
* NAME: apex_download_static_file.js
*
* DESC: use script to download a static file from APEX workspace
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
* 22-08-2022 T. vd Heuvel   ALIS installation
* 02-09-2022 G.P. Breems    Javascript Number type can only hold 16 digits, which isn't enough for the workspaceId
* 02-11-2023 G.P. Breems    Make generic for usage in multiple Environments/Workspaces
*
**/

debug_on = false;
//debug_on = true;   // Remove comment tags to set debug on

// Give positional input parameters logical names
var staticFileName = args[1];
var workspace      = args[2];
var workspaceId    = args[3];

function getWorkspaceId() { return workspaceId; } // return workspaceId
function getWorkspace()   { return workspace; } // return workspace
function getBaseFolder()  { return "apex/"+ getWorkspace().toLowerCase() +"/static/"; } // return local base folder

var staticType = {
  workspace : "Static Workspace File",
  application : "Static Application File",
}

var new_line = '\n';

var dml = {}
    dml.createSession = 'begin wwv_flow_api.set_security_group_id('+getWorkspaceId()+'); end;\n';

var query = {}
    query.saf = 'select application_file_id as id,'+ new_line +
                '       file_content as content,'+ new_line +
                '       \'' + getBaseFolder() + '\' as root_folder,'+ new_line +
                '       \'f\' || application_id as app_folder,'+ new_line +
                '       substr(file_name, 1, instr(file_name, \'/\', -1) -1) as sub_folder,'+ new_line +
                '       substr(file_name, instr(file_name, \'/\', -1)+ 1)    as file_name,'+ new_line +
                '       file_name as apex_file_name,'+ new_line +
                '       application_id as application_id'+ new_line +
                'from   APEX_APPLICATION_STATIC_FILES'+ new_line +
                'where  1 = 1'+ new_line +
                '%ADDITIONALWHERECLAUSE%'+ new_line +
                'order by root_folder, app_folder, sub_folder, file_name' + new_line;
    query.swf = 'select workspace_file_id as id,'+ new_line +
                '       file_content as content,'+ new_line +
                '       \'' + getBaseFolder() + '\' as root_folder,'+ new_line +
                '       \'workspace\' as app_folder,'+ new_line +
                '       substr(file_name, 1, instr(file_name, \'/\', -1) -1) as sub_folder,'+ new_line +
                '       substr(file_name, instr(file_name, \'/\', -1)+ 1)    as file_name,'+ new_line +
                '       file_name as apex_file_name'+ new_line +
                'from   APEX_WORKSPACE_STATIC_FILES'+ new_line +
                'where  1 = 1'+ new_line +
                '%ADDITIONALWHERECLAUSE%'+ new_line +
                'order by root_folder, app_folder, sub_folder, file_name' + new_line;


/**
* 
* NAME: getFileInfo( file )
*
* DESC: use function to get all kinds of metadata from the incoming file
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
*
**/
function getFileInfo( file ) {

  print('Extract info from current open file');

  var info = {}
  
  var tmp = file.replace(getBaseFolder(), '');
  
  info.workspaceAppFolder = tmp.substring( 0, tmp.indexOf('/'));
  info.localBaseFolder    = getBaseFolder();
  info.localPath  = info.localBaseFolder + info.workspaceAppFolder  + "/";
  info.fullname   = file;
  info.name       = info.fullname.replace( info.localPath, "");
  info.extension  = info.name.substring( info.name.lastIndexOf('.') + 1);
  
  info.staticType = (info.workspaceAppFolder === "workspace") ? staticType.workspace   :
                    (info.workspaceAppFolder.startsWith("f")) ? staticType.application : "Unknown" ;

  if (info.staticType === staticType.application) {
    info.appId =  info.workspaceAppFolder.replace('f',"");
  }
  
  print("..fullname: "+info.fullname)
  print("..baseFolder: "+info.localBaseFolder);
  print("..localPath: "+info.localPath)
  print("..name: "+info.name)
  print("..extension: "+info.extension)
  print("..mime: "+info.mime)
  print("..workspaceAppFolder: "+info.workspaceAppFolder)
  if (info.hasOwnProperty('appId')) { print("..appId: "+info.appId) }
  print("..staticType: "+info.staticType)

  return info;
}

/**
* 
* NAME: print( input )
*
* DESC: use function to print input string on screen
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
*
**/
function print( input) {
  ctx.write(input + new_line);
}

/**
* 
* NAME: debug( input )
*
* DESC: use function to print input string on screen when in debug modus
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
*
**/
function debug( input) {
  if (debug_on) {
    print (input);
  }
}

/**
* 
* NAME: createFolder( folder )
*
* DESC: use function to create complete folder structure
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
*
**/
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

/**
* 
* NAME: blob2File( content, fileName, folder )
*
* DESC: use function to write blob content to a folder/file
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
*
**/
function blob2File (content, fileName, folder) {
  var File = java.nio.file;

  // Check if folder exists
  createFolder(folder);

  // Show path + file name to export
  print( "...."+folder  + "/" + fileName);

  // GET the BLOB stream
  var blobStream = content.getBinaryStream(1);

  // GET the path/file handle TO WRITE TO
  var path = File.FileSystems.getDefault().getPath( folder + '/' + fileName);

  // Dump the file stream TO the file
  File.Files.copy( blobStream, path, File.StandardCopyOption.REPLACE_EXISTING);
}

/**
* 
* NAME: executeQuery( query, binds, additionalWhereClause )
*
* DESC: use function to execute incoming query with binds (and additional where clause)
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
*
**/
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

/**
* 
* NAME: download_static_file( file )
*
* DESC: use function to download a specific static workspace/application file
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
*
**/
function download_static_file(file) {

  var fileInfo = getFileInfo(file); // Extract all metadata info from path/file
  
  print('Download '+ fileInfo.staticType);
  print('..Setup bind variables');
  var binds = {
    workspace : getWorkspaceId(),
    flow_id   : fileInfo.appId,
    filename  : fileInfo.name,
  }

  print('..Downloading file(s)');
  // execute pre query to set apex session for correct result on static application files
  ret = executeQuery(dml.createSession);

  // setup query and additional where clause (static workspace vs application file)
  if (fileInfo.staticType === staticType.workspace) {
    var sql_stmt = query.swf; // Assign query for static workspace files
    var additionalWhereClause = 'and file_name = :filename'; // Download one specific file
  }
  if (fileInfo.staticType === staticType.application) {
    var sql_stmt = query.saf;  // Assign query for static application files
    var additionalWhereClause = 'and file_name = :filename' + new_line + // Download one specific file
                                'and application_id = :flow_id'; // Add where clause to retrieve file from corresponding application id
  }
  
  // execute query to list static workspace file(s)
  ret = executeQuery(sql_stmt, binds, additionalWhereClause);

  // loop the results
  for (i = 0; i < ret.length; i++) {
    var folder   = ret[i].ROOT_FOLDER + '/' + ret[i].APP_FOLDER + ((ret[i].SUB_FOLDER) ? '/' + ret[i].SUB_FOLDER : '');
    var filename = ret[i].FILE_NAME;
    var content  = ret[i].CONTENT;

    debug(folder);
    blob2File( content, filename, folder);
  }

  if (ret) {
    print("..Done");
  } else {
    print("Something unintended happened.");
  }

  print( new_line + ret.length +' '+ fileInfo.staticType + '(s) has been downloaded' + new_line);
}

/**
* 
* NAME: main
*
* DESC: 
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
* 02-09-2022 G.P. Breems    Debug incoming arguments
* 02-10-2023 G.P. Breems    Rename argument variable name
*
**/
var file = staticFileName.replace( /\\/g , "/"); // Replace all backslashes with a slash (regex) (Windows to POSIX format)

debug("staticFileName = " + staticFileName)
debug("file = " + file)

// Check if basefolder matches expected static file basefolder
if (file.indexOf(getBaseFolder()) !== -1) {
  download_static_file( file );
} else {
  print("Error: Base folder of the file doesn't match, download not possible.\n")
  exit; // todo: doesn't seem to work...
}
