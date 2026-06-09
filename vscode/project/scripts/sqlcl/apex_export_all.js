
debug_on = false;
//debug_on = true;   // Remove comment tags to set debug on

function getWorkspaceId() { return "xxxx"; } // return workspaceId
function getWorkspace()   { return "xxxx"; } // return workspace

var new_line = '\n';

var pre_query = 'begin wwv_flow_api.set_security_group_id('+getWorkspaceId()+'); end;\n';
var query = 'with static_files as ('+ new_line +
            '  select workspace_file_id as id,'+ new_line +
            '         file_content as content,'+ new_line +
            '         \'apex/'+getWorkspace().toLowerCase()+'/static\' as root_folder,'+ new_line +
            '         \'workspace\' as app_folder,'+ new_line +
            '         substr(file_name, 1, instr(file_name, \'/\', -1) -1) as sub_folder,'+ new_line +
            '         substr(file_name, instr(file_name, \'/\', -1)+ 1)    as file_name'+ new_line +
            '  from   APEX_WORKSPACE_STATIC_FILES'+ new_line +
            '  union all'+ new_line +
            '  select application_file_id as id,'+ new_line +
            '         file_content as content,'+ new_line +
            '         \'apex/'+getWorkspace().toLowerCase()+'/static\' as root_folder,'+ new_line +
            '         \'f\' || application_id as app_folder,'+ new_line +
            '         substr(file_name, 1, instr(file_name, \'/\', -1) -1) as sub_folder,'+ new_line +
            '         substr(file_name, instr(file_name, \'/\', -1)+ 1)    as file_name'+ new_line +
            '  from   APEX_APPLICATION_STATIC_FILES'+ new_line +
            ')' + new_line +
            'select *' + new_line +
            'from   static_files' + new_line +
            'order by root_folder, app_folder, sub_folder, file_name' + new_line;

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

function executeQuery(query) {
  debug( query);

  var binds = {}
  var ret = util.executeReturnList( query, binds);
  if(!ret){
    throw util.getLastException(); 
  }

  debug(ret);

  return ret;
}

function getArgumentCount( args) {
  return (args.length - 1);
}

function mainCode( args) {
  // execute pre query to set apex session for correct result on static application files
  ret = executeQuery(pre_query);

  // execute query to list all static workspace and application files
  ret = executeQuery(query);

  // loop the results
  for (i = 0; i < ret.length; i++) {
    // Check if root folder exists
    rootPath = ret[i].ROOT_FOLDER;
    createFolder(rootPath);

    // Check if app folder exists
    appPath = rootPath + '/' + ret[i].APP_FOLDER;
    createFolder(appPath);
  
    // Check if sub folder exists
    completePath = (ret[i].SUB_FOLDER) ? appPath + '/' + ret[i].SUB_FOLDER : appPath;
    createFolder(completePath);
  
    // Show path + file name to export
    print( completePath  + "/" + ret[i].FILE_NAME);

    // GET the BLOB stream
    var blobStream =  ret[i].CONTENT.getBinaryStream(1);
  
    // GET the path/file handle TO WRITE TO
    var path = java.nio.file.FileSystems.getDefault().getPath( completePath + '/' + ret[i].FILE_NAME);
  
    // Dump the file stream TO the file
    java.nio.file.Files.copy( blobStream, path, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
  }

  print( new_line + ret.length +' static workspace/application files have been exported into ');
}


print('scriptName : ./' + args[0]);

mainCode(args);
