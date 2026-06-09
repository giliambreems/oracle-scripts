// This script exports exports the current schema into files 
// based on https://gist.github.com/krisrice/de6f694b5241682059968bd5beadbcf7
//
// Usage:  SQL> script export_ddl 


(function(){
var verbose = false; 
var CopyOption  = Java.type("java.nio.file.StandardCopyOption");
var ddlPath = java.nio.file.FileSystems.getDefault().getPath('ddl'); 
var fs      = java.nio.file.FileSystems.getDefault();
var f       = java.nio.file.Files;


// setup dbms_metadata 
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

  var sql = "BEGIN  dbms_metadata.set_transform_param(dbms_metadata.session_transform, :name, "+valueParam+"); END;"; 
  var res = util.execute(sql, binds); 
  if(!res){
    throw util.getLastException(); 
  }
}

function exportObject(type, name, owner, fname)
{
  ctx.write( "Exporting " + type  + ":" + name );
  out.flush();

  setDbmsMetadataTransformParam('EMIT_SCHEMA', false); 
  setDbmsMetadataTransformParam('PRETTY', true); 
  setDbmsMetadataTransformParam('SQLTERMINATOR', true); 


  // get the ddl PACKAGE_SPEC
  var binds = {}; 
  switch(type) {
    case 'PACKAGE': 
      binds.type = 'PACKAGE_SPEC';
      break; 
    case 'PACKAGE BODY':
      binds.type = 'PACKAGE_BODY'; 
      break;
    case 'TYPE':
      binds.type = 'TYPE_SPEC'; 
      break;
    case 'TYPE BODY':
      binds.type = 'TYPE_BODY'; 
      break;
    default: binds.type = type;
  }
  binds.name  =  name;
  binds.owner =  owner;
  var rows = util.executeReturnList('SELECT dbms_metadata.get_ddl(:type,:name,:owner) as ddl FROM dual',binds);
  var blobStream =  rows[0].DDL.getAsciiStream();
  
  ctx.write("\t\t"+fname+"\n");

  if(verbose) 
    ctx.write(rows[0].DDL.stringValue()+"\n");  

  var path = fs.getPath(ddlPath+'/'+ fname);

  // dump the file stream to the file
  f.copy(blobStream,path,CopyOption.REPLACE_EXISTING);
}


if ( ! f.exists(ddlPath)) {
  f.createDirectory(ddlPath)
}



// Find objects to export 
var  objects = util.executeReturnList(
  "SELECT owner,object_type,object_name "+ 
  " FROM all_objects "+ 
  " WHERE object_name not like '%$%'"+ 
  "   AND object_name not like 'SYS_%'"+
  "   AND object_type not in ('LOB','JOB')"+
  "   AND owner = SYS_CONTEXT('USERENV', 'current_schema') "+
  " ORDER BY  1,2,3 ", null);   
 

// loop the results 
for (i = 0; i < objects.length; i++) 
{
    var name = objects[i].OBJECT_NAME; 
    var type = objects[i].OBJECT_TYPE;
    var owner = objects[i].OWNER;  
    // get the path/file handle to write to
    var fname = name;
    switch(type) {
      case 'PACKAGE':
      case 'TYPE': 
      case 'PROCEDURE':
        fname = fname + ".pls"; 
        break;
      case 'TYPE BODY':
      case 'PACKAGE BODY':
        fname = fname + ".plb";
        break;
      default:
        fname = fname + ".sql";
    }

    exportObject(type, name, owner , fname); 
}

})();