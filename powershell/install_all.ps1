[System.Environment]::SetEnvironmentVariable('database-user','GILIAM.BREEMS')
[System.Environment]::SetEnvironmentVariable('database-password','Oracle_ww1')

# Delta install versions display output
Set-Location D:\projects\SideKick ;        ./build.ps1 ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxGeneriek ;    ./build.ps1 --clean-install-oracle ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxProducenten ; ./build.ps1 --clean-install-oracle --skip-apex-ui-tests; git checkout -- .\.nuke\build.schema.json ;

[System.Environment]::SetEnvironmentVariable('database-user','GILIAM.BREEMS')
[System.Environment]::SetEnvironmentVariable('database-password','Oracle_ww1')

# Delta install versions display output
Set-Location D:\projects\FluxProducenten ; ./build.ps1 --skip-apex-ui-tests; git checkout -- .\.nuke\build.schema.json ;

