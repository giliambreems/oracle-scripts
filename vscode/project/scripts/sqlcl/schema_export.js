/* ***************************************************************************
Name      : schema_export.js
  
Purpose   : Export a schema object and modify it according to our needs
  
Revision
Date        Name             Description 
13-12-2023  J. Engberts      Foreign keys and grants can be written in seperate files for use in a CICD pipeline.
03-11-2023  G.P. Breems      Make generic for usage in multiple Environments/Workspaces
03-10-2022  G.P. Breems      Add seperate version control for table exports
26-04-2022  G.P. Breems      Export tables and indexes with TABLESPACE clause
09-03-2022  G.P. Breems      Export privileges exclusively
05-01-2022  G.P. Breems      Change characterset from UTF-8 to WE8MSWIN1252
xx-12-2021  G.P. Breems      Initial creation
*************************************************************************** */

// TODO: Export object dependencies, PACKAGE/TYPE SPEC and BODY, VIEW and TRIGGER, etc.


// issue the SQL

debug_on = false;
// debug_on = true;   // Remove comment tags to set debug on

var objTypeArr = [
  { name : 'FUNCTION'     , alias : 'fnc'},
  //{ name : 'INDEX'        , alias : 'ind'},
  { name : 'DATABASE LINK', alias : 'dbl'},
  //{ name : 'JAVA CLASS' , alias : ''},
  //{ name : 'JAVA SOURCE', alias : ''},
  { name : 'PACKAGE'      , alias : 'pks'},
  { name : 'PACKAGE BODY' , alias : 'pkb'},
  { name : 'PROCEDURE'    , alias : 'prc'},
  //{ name : 'QUEUE', alias: 'aq'},
  //{ name : 'RULE SET', alias: ''},
  { name : 'SEQUENCE'     , alias : 'seq'},
  { name : 'SYNONYM'      , alias : 'syn'},
  { name : 'TABLE'        , alias : 'tab'},
  { name : 'TRIGGER'      , alias : 'trg'},
  { name : 'TYPE'         , alias : 'tps'},
  { name : 'TYPE BODY'    , alias : 'tpb'},
  { name : 'VIEW'         , alias : 'vw'},
];

var new_line = '\n';

var query = 'select obj.owner,' + new_line +
            '       obj.object_name,' + new_line +
            '       obj.object_type as object_type,' + new_line +
            '       \'db/\' || lower(:owner) as root_folder,' + new_line +
            '       lower(:alias) as object_type_extension' + new_line +
            'from   all_objects obj' + new_line +
            'where  obj.owner = :owner' + new_line +
            'and    obj.object_type = :type' + new_line +
            'and    obj.generated = \'N\'' + new_line +
            '%ADDITIONALWHERECLAUSE%' + new_line +
            'order by obj.object_type, obj.object_name' + new_line;

/* Actual script code is below */

var SQLPlusMaxInputLength = 2450; // Max line input length of SQL*Plus (2499/4999)

var CopyOption  = java.nio.file.StandardCopyOption;  // var CopyOption  = Java.type("java.nio.file.StandardCopyOption");
var FileSystems = java.nio.file.FileSystems;
//var Paths       = java.nio.file.Paths;
var Files       = java.nio.file.Files;
var StandardCharsets = java.nio.charset.StandardCharsets;
var databaseCharset = StandardCharsets.ISO_8859_1;  // Matches most with WE8MSWIN1252
var StandardOpenOption = java.nio.file.StandardOpenOption;

var fs = FileSystems.getDefault();

function print( input) {
  ctx.write(input + new_line);
  out.flush();
}

function debug( input) {
  if (debug_on) {
    print (input);
  }
}

function createFolder( folder) {
  path = fs.getPath( folder );
  pathExists = Files.exists( path);

  if (!pathExists) {
    debug('Folder \''+folder+'\' does not exists, created..');
    newDir = Files.createDirectories( path );  // Create complete folder structure
  } else {
    // Do nothing, folder path already exists
    debug('Folder \''+folder+'\' already exists..');
  }
}

// Setup dbms_metadata 
function setDbmsMetadataTransformParam(name, value){

  var binds = {
    name : name, 
    value: value 
  }; 

  // fix bind parameter for PL/SQL boolean
  var valueParam = ':value'; 
  if (typeof value === "boolean")
  {
    if(value) valueParam = 'true'; 
    else valueParam = 'false'; 
  }

  var sql = "BEGIN dbms_metadata.set_transform_param(dbms_metadata.session_transform, :name, "+valueParam+"); END;"; 

// var res = executeStatement(sql, binds)
  var res = util.execute(sql, binds);
  if (!res) {
    throw util.getLastException(); 
  }
}

function executeQuery(query, binds, additionalWhereClause) {

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

function splitFileLine( path, filename, maxLength) {
  debug("Split line if neccessary, due to exceeding linesize");
  var fsPath = fs.getPath( path + '/' + filename );

  var lines = Files.readAllLines(fsPath, databaseCharset); // Read complete file

  var data = [];
  var exceedingLineLimitFound = false;

  lines.forEach( function splitLine(line, idx, arr, recursiveCall, charCount) {

                   charCount = typeof charCount !== 'undefined' ? charCount : 0;  // Set default value to 0 

                   if (line.length() > maxLength) {  // Check if line length exceeds maximum
                     if (!recursiveCall) {
                       debug("Warning: Line has > "+maxLength+" ("+line.length()+") characters. Split line into multiple lines.");
                     }
                     
                     var seperator = " ";  // Define seperator character
                     indexPos = line.lastIndexOf(  seperator, maxLength);  // Find last index of seperator character within maxLength

                     debug("Seperator character found at index " + (charCount + indexPos) + ", write "+ indexPos + " characters to new array index");
                     var lineCharacters      = line.substring(0, indexPos);  // Store characters that fit in current line
                     var remainingCharacters = line.substring(indexPos +1);  // Store remaining characters for further processing
                     
                     data.push( lineCharacters );  // Push line into array

                     if (remainingCharacters.length() <= maxLength) {
                       debug("Write (remaining) "+ remainingCharacters.length() + " characters to new array index");
                     }

                     splitLine( remainingCharacters, idx, arr, true, charCount + indexPos);  // Repeat process with remaining characters
                     exceedingLineLimitFound = true;

                   } else {
                     data.push(line);  // Push (remaining) line into array
                   }
                 });

  // Only overwrite existing file with new array, when one or more lines did exceed the max line length
  if (exceedingLineLimitFound) {
    debug("Delete existing file " + path + "/" + filename);
    Files.delete( fsPath );  // Remove file before writing new content
    
    debug("Write array to file " + path + "/" + filename);
    write2File( fsPath, data.join("\n") );
  }
}

/* ***************************************************************************
Name      : exportObject
  
Revision
Date        Name             Description 
13-12-2023  J. Engberts      Foreign keys and privileges can be written in a seperate file
03-10-2022  G.P. Breems      Add seperate version control for table exports
26-04-2022  G.P. Breems      Add TABLESPACE clause to the export
xx-12-2021  G.P. Breems      Initial creation
*************************************************************************** */
function exportObject( row, exportPath, FKPath, grantPath) {
  // Show path + file name to export
  print( "Exporting "  +  row.OBJECT_TYPE + ": " + row.OBJECT_NAME  );

  // get the ddl
  var binds = {};
      binds.type  =  row.OBJECT_TYPE;
      binds.name  =  row.OBJECT_NAME;
      binds.owner =  row.OWNER;
      binds.version = '11.2';  //Script needs to be compatible with Oracle Database and/or SQL*Plus version <XX.X>
      binds.db_version = '19';  //Script needs to be compatible with Oracle Database version <XX.X>

      switch(row.OBJECT_TYPE) {
        case 'PACKAGE': 
          binds.metatype = 'PACKAGE_SPEC';
          break; 
        case 'PACKAGE BODY':
          binds.metatype = 'PACKAGE_BODY'; 
          break;
        case 'TYPE':
          binds.metatype = 'TYPE_SPEC'; 
          break;
        case 'TYPE BODY':
          binds.metatype = 'TYPE_BODY'; 
          break;
        case 'DATABASE LINK':
          binds.metatype = 'DB_LINK'; 
          break;
        case 'QUEUE':
          binds.metatype = 'AQ_QUEUE'; 
          break;
        default: binds.metatype = row.OBJECT_TYPE;
      }
  debug(JSON.stringify(binds));
    
  var ddl_stmt = 'select to_clob(\'PROMPT Creating \'|| initcap( :type) || \' \'\'\' || :name || \'\'\'\'  || chr(10) ) ||' + new_line +
                '       ltrim( ltrim( replace(dbms_metadata.get_ddl(:metatype, :name, :owner, :version), \'","\', \'", "\'), chr(10))) || chr(10)' + new_line +
                '          as DDL' + new_line +
                'from dual';
  
  if (binds.metatype === "TABLE") {
    var ddl_stmt = 'select to_clob(\'PROMPT Creating \'|| initcap( :type) || \' \'\'\' || :name || \'\'\'\'  || chr(10) ) ||' + new_line +
                   '       regexp_replace( ' + new_line +
                   '           regexp_replace( ' + new_line +
                   '               regexp_replace( ' + new_line +
                   '                               ltrim( ltrim( replace(dbms_metadata.get_ddl(:metatype, :name, :owner, :db_version), \'","\', \'", "\'), chr(10))) || chr(10)' + new_line +
                   '                             , \'(SEGMENT CREATION(.*?))?PCTFREE(.*?)TABLESPACE\', \'TABLESPACE\', 1, 0, \'n\' )' + new_line +  // Remove everything from SEGMENT CREATION et, but keep TABLESPACE clause
                   '                         , \'(LOB(.*?)(TABLESPACE)(.*?))(ENABLE(.*?)( ?\\))+)\', \'\\1\\7\', 1, 0, \'n\' )' + new_line +
                   '                     , \';\', \';\'||chr(10), 1, 0, \'n\' )' + new_line + // Add extra linefeed characters to seperate additional statements
                   '          as DDL' + new_line +
                   'from dual';
  }                

  debug(ddl_stmt);

  
  var ddl = executeQuery(ddl_stmt, binds);

  // GET the BLOB stream
  var contentStream =  ddl[0].DDL.getAsciiStream();

  // GET the path/file handle TO WRITE TO
  var filename = row.OBJECT_NAME + '.' + row.OBJECT_TYPE_EXTENSION;
  var fsPath = fs.getPath( exportPath + '/' + filename );

  // Dump the file stream TO the file
  Files.copy( contentStream, fsPath, CopyOption.REPLACE_EXISTING );


  try {
    splitFileLine( exportPath, filename, SQLPlusMaxInputLength); //SQL*Plus Max input length
  }
  catch (e) {
    print( "ERROR: " + e)
  }

  switch(row.OBJECT_TYPE) {
    case 'TABLE': 
      //addConstraints();  // Embedded in the create table statement
      if (splitFKs == 'Y') {
        addRefConstraints( FKPath, row.OWNER, row.OBJECT_NAME);
      }
      else {
        addRefConstraints( fsPath, row.OWNER, row.OBJECT_NAME);
      }
      addIndexes( fsPath, row.OWNER, row.OBJECT_NAME);
      addComments( fsPath, row.OWNER, row.OBJECT_NAME);
      if (splitGrants == 'Y') {
        addObjectPrivileges( grantPath, row.OWNER, row.OBJECT_NAME);
      }
      else {
        addObjectPrivileges( fsPath, row.OWNER, row.OBJECT_NAME);
      }
      break; 
    case 'VIEW':
      addComments( fsPath, row.OWNER, row.OBJECT_NAME);
      if (splitGrants == 'Y') {
        addObjectPrivileges( grantPath, row.OWNER, row.OBJECT_NAME);
      }
      else {
        addObjectPrivileges( fsPath, row.OWNER, row.OBJECT_NAME);
      }
      break;
    case 'SEQUENCE': 
    case 'FUNCTION': 
    case 'PROCEDURE': 
    case 'PACKAGE': 
      if (splitGrants == 'Y') {
        addObjectPrivileges( grantPath, row.OWNER, row.OBJECT_NAME);
      }
      else {
        addObjectPrivileges( fsPath, row.OWNER, row.OBJECT_NAME);
      }
      addShowError(fsPath, row.OBJECT_TYPE, row.OBJECT_NAME);
      break;
    case 'PACKAGE BODY': 
    case 'TRIGGER': 
    case 'TYPE': 
    case 'TYPE BODY': 
      addShowError(fsPath, row.OBJECT_TYPE, row.OBJECT_NAME);
      break;
    default:
  }
}

function addNewLine( path) {
  write2File( path, new_line);
}

function addShowError( path, objectType, objectName) {
  write2File( path, new_line + "SHOW ERROR " + objectType + " " + objectName + new_line);
}

function addRefConstraints( path, refObjectOwner, refObjectName) {
  var query = { constraints  : "select ltrim( ltrim( ltrim( cast( dbms_metadata.get_ddl (\'REF_CONSTRAINT\', con.constraint_name, con.owner) as varchar2(4000))), chr(10))) as DDL" + new_line +
                               "from   all_constraints con" + new_line +
                               "where  con.owner = :owner" + new_line +
                               "and    con.table_name = :name" + new_line +
                               "and    con.constraint_type = \'R\'" + new_line +
                               "order by con.constraint_name" + new_line
              }

  var binds = {}
      binds.owner = refObjectOwner;
      binds.name = refObjectName;

  // Write Foreign Keys to file
  var resultSet = executeQuery( query.constraints, binds);
  if (splitFKs == 'Y') {
    var result = '';
    resultSet.forEach( function(row) { result = result + row.DDL + new_line });
  
    //Write foreign key constraints to file
    var filePath = fs.getPath(path + '/' + refObjectName + '.fk');
    Files.deleteIfExists(filePath);
    if (result.length !== 0) {
      Files.write(filePath,
                  result.getBytes(databaseCharset),
                  StandardOpenOption.CREATE,
                  StandardOpenOption.WRITE
      );
    }
  }
  else {
    // Add an empty line to start new section
    resultSet.forEach( function(row) { write2File( path, new_line + row.DDL + new_line) })
  }  
}

/* ***************************************************************************
Name      : addIndexes
  
Revision
Date        Name             Description 
26-04-2022  G.P. Breems      Export indexes with TABLESPACE clause
xx-12-2021  G.P. Breems      Initial creation
*************************************************************************** */
function addIndexes( path, refObjectOwner, refObjectName) {
  var query = { indexes  : "select regexp_replace( " + new_line +
                           "                       ltrim( ltrim( ltrim( cast( dbms_metadata.get_ddl (\'INDEX\', ind.index_name, ind.owner) as varchar2(4000))), chr(10)))" + new_line +
                           "                     , \'(SEGMENT CREATION(.*?))?PCTFREE(.*?)TABLESPACE\', \'TABLESPACE\', 1, 0, \'n\' )" + new_line +  // Remove everything from SEGMENT CREATION et, but keep TABLESPACE clause
                           "                      as DDL" + new_line +
                           "from   all_indexes ind" + new_line +
                           "where  ind.owner = :owner" + new_line +
                           "and    ind.table_name = :name" + new_line +
                           "and    not exists(" + new_line +
                           "   select 1" + new_line +
                           "   from   all_constraints u" + new_line +
                           "     join   all_indexes i on i.owner = u.owner" + new_line +
                           "                         and i.table_name = u.table_name" + new_line +
                           "                         and i.index_name = u.index_name" + new_line +
                           "   where  i.owner = ind.owner" + new_line +
                           "   and    i.table_name = ind.table_name" + new_line +
                           "   and    i.index_name = ind.index_name" + new_line +
                           ") order by ind.index_name" + new_line
              }

  var binds = {}
      binds.owner = refObjectOwner;
      binds.name = refObjectName;

  // Write table comments to file
  var resultSet = executeQuery( query.indexes, binds);
  resultSet.forEach( function(row) { write2File( path, new_line + row.DDL + new_line) })
}

/* ***************************************************************************
Name      : addObjectPrivileges
  
Revision
Date        Name             Description
13-12-2023  J. Engberts      Privileges can be added to current object file or written in a new file
06-11-2023  G.P. Breems      Control grantee privileges in database.config
09-03-2022  G.P. Breems      Export privileges exclusively
xx-12-2021  G.P. Breems      Initial creation
*************************************************************************** */
function addObjectPrivileges( path, refObjectOwner, refObjectName) {
  var query = { objectPrivileges  : "select 'GRANT ' || t.privilege || ' ' ||" + new_line +
                                    "       'ON ' || '\"' || t.table_name  ||'\"' || ' ' ||" + new_line +
                                    "       'TO ' || '\"' || t.grantee  ||'\"' ||" + new_line +
                                    "       decode( t.hierarchy, 'YES', ' ' || 'WITH HIERARCHY OPTION', null) ||" + new_line +
                                    "       decode( t.grantable, 'YES', ' ' || 'WITH GRANT OPTION', null) ||" + new_line +
                                    "       ';' as DDL" + new_line +
                                    "from   all_tab_privs t" + new_line +
                                    "where  table_schema = :owner" + new_line +
                                    "and    table_name = :name" + new_line +
                                    "and    t.grantee in ("+grantee+")" + new_line +
                                    "order by t.table_name," + new_line +
                                    "         t.grantee," + new_line +
                                    "         decode( t.privilege, 'SELECT', 1," + new_line +
                                    "                              'INSERT', 2," + new_line +
                                    "                              'UPDATE', 3," + new_line +
                                    "                              'DELETE', 4," + new_line +
                                    "                              5" + new_line +
                                    "               )," + new_line +
                                    "         t.privilege" + new_line
              }
  
  var binds = {}
      binds.owner = refObjectOwner;
      binds.name = refObjectName;

  // build the file content
  var resultSet = executeQuery( query.objectPrivileges, binds);
  if (splitGrants == 'Y') {
    var result = '';
    resultSet.forEach( function(row) { result = result + row.DDL + new_line });
    
    //Write grants to file    
    var filePath = fs.getPath(path + '/' + refObjectName + '.grant');
    Files.deleteIfExists(filePath);
    if (result.length !== 0) {
      Files.write(filePath,
                  result.getBytes(databaseCharset),
                  StandardOpenOption.CREATE,
                  StandardOpenOption.WRITE
    );
    }
  }
  else {
    // Add an empty line to start new section
    addNewLine(path);
    resultSet.forEach( function(row) { write2File( path, row.DDL + new_line) })
  }  
}

function addComments( path, refObjectOwner, refObjectName) {
  var query = { tableComments  : "select \'COMMENT ON TABLE \'||tc.table_name||\' IS \'\'\'||tc.comments||\'\'\';\' as ddl" + new_line +
                                 "from   all_tab_comments tc" + new_line +
                                 "where  tc.owner = :owner" + new_line +
                                 "and    tc.table_name = :name" + new_line +
                                 "and    tc.comments is not null" + new_line
              , columnComments : "select \'COMMENT ON COLUMN \'||cc.table_name||\'.\'|| cc.column_name ||\' IS \'\'\'||cc.comments||\'\'\';\' as ddl" + new_line +
                                 "from   all_col_comments cc" + new_line +
                                 "where  cc.owner = :owner" + new_line +
                                 "and    cc.table_name = :name" + new_line +
                                 "and    cc.comments is not null" + new_line +
                                 "order by cc.column_name" + new_line
              }

  var binds = {}
      binds.owner = refObjectOwner;
      binds.name = refObjectName;

  // Add an empty line to start new section
  addNewLine(path);

  // Write table comments to file
  var ddl = executeQuery( query.tableComments, binds);
  ddl.forEach( function(ddl) { write2File( path, ddl.DDL + new_line)  })

  // Add an empty line to start new section
  addNewLine(path);

  // Write column comments to file
  var ddl = executeQuery( query.columnComments, binds);
  ddl.forEach( function(ddl) { write2File( path, ddl.DDL + new_line) })
}

function write2File(path, content) {
  debug(path); debug(content);

  Files.write(path,
    content.getBytes(databaseCharset),
    StandardOpenOption.CREATE,
    StandardOpenOption.APPEND);
}

/* ***************************************************************************
Name      : exportObjects
  
Revision
Date        Name             Description 
12-08-2023  J. Engberts      Option for separate folders for FK's and Grants
26-04-2022  G.P. Breems      Add TABLESPACE clause to the export
xx-12-2021  G.P. Breems      Initial creation
*************************************************************************** */
function exportObjects( objects) {
  debug("function exportObjects");
  // loop the results
  for (i = 0; i < objects.length; i++) {
    if (i===0) {
      // Check if root and/or object type folder exists
      objectFolder = objects[i].ROOT_FOLDER + '/' + objects[i].OBJECT_TYPE_EXTENSION;
      FKFolder = objects[i].ROOT_FOLDER + '/fk';
      grantFolder = objects[i].ROOT_FOLDER + '/grant';
      createFolder(objectFolder);

      if (splitFKs == 'Y') {
        createFolder(FKFolder);
      }

      if (splitGrants == 'Y') {
        createFolder(grantFolder);
      }
    
      setDbmsMetadataTransformParam('EMIT_SCHEMA', false); 
      setDbmsMetadataTransformParam('PRETTY', true); 
      setDbmsMetadataTransformParam('SQLTERMINATOR', true); 

      setDbmsMetadataTransformParam('SEGMENT_ATTRIBUTES', true); 
      setDbmsMetadataTransformParam('STORAGE', true); 
      setDbmsMetadataTransformParam('TABLESPACE', true); 

      setDbmsMetadataTransformParam('CONSTRAINTS', true); 
      setDbmsMetadataTransformParam('REF_CONSTRAINTS', false); 
      setDbmsMetadataTransformParam('CONSTRAINTS_AS_ALTER', true); 
    }
    exportObject( objects[i], objectFolder, FKFolder, grantFolder);
  }
  print( new_line + objects.length + ' ' + objects[0].OBJECT_TYPE.toLowerCase() + 's have been exported');
}

function objectWhereClause( objectType, objectName) {
  var result;
  if (objectType.name == 'TABLE') {
    result = 'and   obj.object_name not like \'OMH\\_%\' escape \'\\\'' +  new_line +    // Exclude OMH_% objects, OMH is a diff project.
             'and   obj.object_name not like \'AQ$%\'' +  new_line ;    // Exclude AQ$% objects, AQ$ views are generated when creating an Advanced Queue.
  }
  if (objectType.name == 'VIEW') {
    result = 'and   obj.object_name not like \'OMI\\_C\\_%\' escape \'\\\'' + new_line +    // Exclude OMI_C_% objects, these are generated with scripts.
             'and   obj.object_name not like \'OMH\\_%\' escape \'\\\'' +  new_line +    // Exclude OMH_% objects, OMH is a diff project.
             'and   obj.object_name not like \'AQ$%\'' +  new_line ;    // Exclude AQ$% objects, AQ$ views are generated when creating an Advanced Queue.
  }
  if (objectName !== 'ALL') {
    debug("Object Name: "+objectName);
    result = 'and   obj.object_name = :name' + new_line ;
  }

  return result;
}

function executeQueryAndProcess( objectType, index, arr, objectOwner, objectName, splitFKs, splitGrants) {
  objectName = (typeof objectName === 'undefined') ? "ALL" : objectName; // Set default for objectName parameter, i.s.o. undefined
  var bind = { owner : objectOwner,
               type  : objectType.name,
               alias : objectType.alias,
               name  : objectName
              };
  var additionalWhereClause = objectWhereClause( objectType, objectName);

  // execute query to list all database objects
  var ret = executeQuery( query, bind, additionalWhereClause);

  if (ret.length !== 0) {
    exportObjects(ret, splitFKs, splitGrants);
  }
} 

function main( objectOwner, objectType, objectName, splitFKs, splitGrants) {
  debug("start");

  if (objectType === 'ALL') {
    debug( 'Export all objects: '+objectType );
    objTypeArr.forEach(function (element) { 
//      print(element.name)       
      executeQueryAndProcess( element, null, null, objectOwner, objectName, splitFKs, splitGrants);
    });
  }
  else {
    var element = objTypeArr.filter( function(element) { return element.name === objectType })[0];
    if (element) {
      if (objectName === 'ALL') {
        debug( 'Export all objects of type: ' +objectType );
      } else {
        debug( 'Export single object' );
      }
      executeQueryAndProcess( element, null, null, objectOwner, objectName, splitFKs, splitGrants);
    } else {
      print('WARNING: Object type '+objectType+' not found!');
    }
  }
}

var objectOwner = args[1].toUpperCase();
var objectType  = args[2].toUpperCase();
var objectName  = args[3].toUpperCase();
var grantee     = args[4].toUpperCase();
var splitFKs    = args[5].toUpperCase();
var splitGrants = args[6].toUpperCase();

debug( ">>incoming grantee argument: " + grantee)

grantee = "'" +  // add starting quote
          grantee.split(":")  // returns an array from csv string based on specified 'seperate' char
                 .filter( function(n) { if (n) { return true }})  // returns a new array, excluding the empty values
                 .join("','")  // create a csv string value from array with specified character(s) in between
          + "'"  // add ending quote again
debug( ">>translated grantee argument: " + grantee)

main( objectOwner, objectType, objectName, splitFKs, splitGrants);
