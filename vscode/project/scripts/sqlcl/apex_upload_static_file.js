/**
* 
* NAME: apex_upload_static_file.js
*
* DESC: use script to upload a static file to APEX workspace
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
* 02-09-2022 G.P. Breems    Javascript Number type can only hold 16 digits, which isn't enough for the workspaceId
* 02-11-2023 G.P. Breems    Make generic for usage in multiple Environments/Workspaces
*
**/
debug_on = false;
// debug_on = true;   // Remove comment tags to set debug on

// Give positional input parameters logical names
var staticFileName = args[1].replace( /\\/g , "/"); // Replace all backslashes with a slash (regex) (Windows to POSIX format)
var currentUser    = args[2];
var workspace      = args[3];
var workspaceId    = args[4];

var new_line = '\n';

print( "Incoming file: " + staticFileName );

function getWorkspaceId() { return workspaceId; } // return workspaceId
function getWorkspace()   { return workspace; } // return workspace
function getBaseFolder()  { return "apex/"+ getWorkspace().toLowerCase() +"/static/"; } // return local base folder
function getCurrentUser() { return currentUser; } // return current user

var staticType = {
  workspace : "Static Workspace File",
  application : "Static Application File",
}

// mimetype extension mapping
var mimeType = {
  "css"  : "text/css",
  "eot"  : "application/octet-stream",
  "gif"  : "image/gif",
  "html" : "text/html",
  "ico"  : "image/x-icon",
  "jpg"  : "image/jpeg",
  "js"   : "text/javascript",
  "map"  : "application/json",
  "png"  : "image/png",
  "svg"  : "image/svg+xml",
  "ttf"  : "application/octet-stream",
  "txt"  : "text",
  "woff" : "application/font-woff"
}

var staticType = {
  workspace : "static workspace file",
  application : "static application file",
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

// getMimeType
// Determine the mime type based on the extension of the file.
// If APEX publishes their method of determination, use theirs.. But I didn't find it.
// Use this one until APEX makes it available.
function getMimeType( ext) {
  if (mimeType.hasOwnProperty(ext)) {
    return mimeType[ext];
  } else {
    return "application/octet-stream";
  }
}

/**
* 
* NAME: getFileInfo( file )
*
* DESC: use function to get all kinds of metadata from the incoming file
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
* 09-05-2022 G.P. Breems    Add charset utf-8 for APEX v21.2 compatibility (inline file editing native in APEX)
*
**/
function getFileInfo( file ) {

  print('Extract info from file input');

  var info = {}
  
  var tmp = file.replace(getBaseFolder(), '');
  
  info.workspaceAppFolder = tmp.substring( 0, tmp.indexOf('/'));
  info.localBaseFolder    = getBaseFolder();
  info.localPath  = info.localBaseFolder + info.workspaceAppFolder  + "/";
  info.fullname   = file;
  info.name       = info.fullname.replace( info.localPath, "");
  info.extension  = info.name.substring( info.name.lastIndexOf('.') + 1);
  info.mime       = getMimeType(info.extension);
  info.charset    = 'utf-8';
  
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
  print("..charset: "+info.charset)
  print("..workspaceAppFolder: "+info.workspaceAppFolder)
  if (info.hasOwnProperty('appId')) { print("..appId: "+info.appId) }
  print("..staticType: "+info.staticType)

  return info;
}

// Read incoming file and write to BLOB stream
function file2Blob(filename ) {

  print('..Convert file to blob');

  var blob   = conn.createBlob(); // Create new BLOB variable
  var stream = blob.setBinaryStream(0); // Open binary stream on BLOB variable (write mode)
  var path   = java.nio.file.FileSystems.getDefault().getPath(filename); // Open physical file

  java.nio.file.Files.copy(path, stream);  // Copy file into BLOB stream
  stream.flush();

  return blob; // Return BLOB content
}

/**
* 
* NAME: create_application_static_file( fileInfo )
*
* DESC: Upload static file to application location
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
* 09-05-2022 G.P. Breems    Add charset utf-8 for APEX v21.2 compatibility (inline file editing native in APEX)
* 10-05-2022 G.P. Breems    Set custom authentication to set audit column(s) created_by/last_updated_by
*
**/
function create_application_static_file(fileInfo) {

  print('Upload Static Application File');

  var blob = file2Blob( fileInfo.fullname); // Read physical file to BLOB
 
  print('..Setup bind variables');
  var binds = {
    workspace : getWorkspaceId(),
    user      : getCurrentUser(),
    flow_id   : fileInfo.appId,
    filename  : fileInfo.name,
    mime_type : fileInfo.mime,
    charset   : fileInfo.charset,
    data      : blob
  }
  
  print('..Uploading file(s)');
  // Show path + file name to upload
  print( "...."+ fileInfo.localPath + fileInfo.name);

  var ret = util.execute(
     'begin ' +
        'wwv_flow_api.set_security_group_id( p_security_group_id => :workspace); ' +
        'apex_custom_auth.set_user(:user); ' +  // Sets the user in the audit column(s) created_by/last_updated_by
        'wwv_flow_api.create_app_static_file(p_flow_id => :flow_id, p_file_name => :filename, p_mime_type => :mime_type, p_file_charset=> :charset, p_file_content => :data); ' +
        'commit; ' +
     'end;',
     binds
  );

  if (ret) {
    print("..Done");
  } else {
    print("Something unintended happened.");
  }
}

/**
* 
* NAME: create_workspace_static_file( fileInfo )
*
* DESC: Upload static file to workspace location
*
* Revision
* Date       Name           Description
* 02-04-2022 G.P. Breems    Initial release
* 09-05-2022 G.P. Breems    Add charset utf-8 for APEX v21.2 compatibility (inline file editing native in APEX)
* 10-05-2022 G.P. Breems    Set custom authentication to set audit column(s) created_by/last_updated_by
*
**/
function create_workspace_static_file(fileInfo) {
  
  print('Upload Static Workspace File');

  var blob = file2Blob( fileInfo.fullname); // Read physical file to BLOB
 
  print('..Setup bind variables');
  var binds = {
    workspace : getWorkspaceId(),
    user      : getCurrentUser(),
    flow_id   : fileInfo.appId,
    filename  : fileInfo.name,
    mime_type : fileInfo.mime,
    charset   : fileInfo.charset,
    data      : blob
  }

  print('..Uploading file(s)');
  // Show path + file name to upload
  print( "...."+ fileInfo.localPath + fileInfo.name);
  
  var ret = util.execute(
     'begin ' +
        'wwv_flow_api.set_security_group_id( p_security_group_id => :workspace); ' +
        'apex_custom_auth.set_user(:user); ' +  // Sets the user in the audit column(s) created_by/last_updated_by
        'wwv_flow_api.create_workspace_static_file(p_file_name => :filename, p_mime_type => :mime_type, p_file_charset=> :charset, p_file_content => :data); ' +
        'commit; ' +
     'end;',
     binds
  );

  if (ret) {
    print("..Done");
  } else {
    print("Something unintended happened.");
  }
}


// Check if basefolder matches expected static file basefolder
if (staticFileName.indexOf(getBaseFolder()) !== -1) {
  
  var fileInfo = getFileInfo(staticFileName); // Extract all metadata info from path/file

  if (fileInfo.staticType === staticType.workspace) {
    create_workspace_static_file( fileInfo );
  }
  if (fileInfo.staticType === staticType.application) {
    create_application_static_file( fileInfo );
  }
  
} else {
  print("Error: Base folder of the file doesn't match, upload not possible.")
  exit; // todo: doesn't seem to work...
}
