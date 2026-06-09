// 12-04-2021	Erik de Jong
// Download patchrun patchfiles as zipfiles from database blob's
if (args.length < 3) {
print('\nSyntax : dbdownloadblob <patchrunname> <patchfiledir>');
print('Example : script dbdownloadblob testje /tmp/');
} else { 
  ctx.write('\nDatabase connection: ' + conn + "\n");
  ctx.write('Commandline parameters:\n');
  var ls_patchrunname = args[1];
  var ls_patchfiledir = args[2];
  ctx.write('Patchrunname: ' + ls_patchrunname + '\n');
  ctx.write('PatchFiledir: ' + ls_patchfiledir + '\n');
  // get patches from database and write to zip files
  function patchestodir(patchrun, filedir){
    ctx.write( '\nCopy patches for patchrun: ' + patchrun  + " from database to dir: " + filedir + "\n");
    var binds = {}
    binds.PRN = patchrun;
    //var retlist = util.executeReturnList('select patch_name,patch_content from omi_patches where patch_name = :PRN',binds);
    var retlist = util.executeReturnList('select pat.patch_name, pat.patch_content from omi_patchrun_patches prp, omi_patches pat where prp.patch_name = pat.patch_name and prp.run_name = :PRN order by pat.patch_name', binds);
    ctx.write( 'Database Patchrunname: ' + patchrun + ' contains ' + retlist.length + " patches\n");
    // loop the results
    for (i = 0; i < retlist.length; i++) {
      ctx.write( 'Get database patch: ' + retlist[i].PATCH_NAME  + "\n");
      var blobStream =  retlist[i].PATCH_CONTENT.getBinaryStream(1);
      //var path = java.nio.file.FileSystems.getDefault().getPath(retlist[i].PATCH_NAME + '.zip');
      var path = java.nio.file.FileSystems.getDefault().getPath(filedir + retlist[i].PATCH_NAME + '.zip');
      java.nio.file.Files.copy(blobStream,path,java.nio.file.StandardCopyOption.REPLACE_EXISTING);
      ctx.write( '--> Downloaded to : ' + path + "\n");
    }
  }
  // Call function
  var pathexist = java.nio.file.Files.exists(java.nio.file.FileSystems.getDefault().getPath(ls_patchfiledir));
  if ( pathexist ) {
    patchestodir(ls_patchrunname,ls_patchfiledir);
  } else {
    ctx.write('Dir path:' + ls_patchfiledir + ' niet gevonden\n');
  }
}
