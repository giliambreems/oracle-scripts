# Pipe output command to a log file with datetimestamp in the filename
Write-Output("Create log file with actual datetimestamp in filename") > (-join( (Get-Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log"))


# Set environment variables
[System.Environment]::SetEnvironmentVariable('database-user','GILIAM.BREEMS')
[System.Environment]::SetEnvironmentVariable('database-password','Oracle_ww1')

# Delta install versions display output
Set-Location D:\projects\SideKick ;        ./build.ps1 ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxGeneriek ;    ./build.ps1 ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxProducenten ; ./build.ps1 --skip-apex-ui-tests ; git checkout -- .\.nuke\build.schema.json ;

# Delta install versions display output
Set-Location D:\projects\SideKick ;        ./build.ps1 ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxGeneriek ;    ./build.ps1 ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxProducenten ; ./build.ps1 ; git checkout -- .\.nuke\build.schema.json ;

# Delta install versions alternate database username/password
Set-Location D:\projects\SideKick ;        ./build.ps1 --database-user "GILIAM.BREEMS" --database-password "Oracle_ww1" ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxGeneriek ;    ./build.ps1 --database-user "GILIAM.BREEMS" --database-password "Oracle_ww1" ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxProducenten ; ./build.ps1 --database-user "GILIAM.BREEMS" --database-password "Oracle_ww1" ; git checkout -- .\.nuke\build.schema.json ;

# Delta install versions output to file only
Set-Location D:\projects\SideKick ;        ./build.ps1 > (-join( (Get-Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log")) ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxGeneriek ;    ./build.ps1 > (-join( (Get-Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log")) ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxProducenten ; ./build.ps1 > (-join( (Get-Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log")) ; git checkout -- .\.nuke\build.schema.json ;

# Clean install versions
Set-Location D:\projects\SideKick ;        ./build.ps1 --clean-install-oracle ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxGeneriek ;    ./build.ps1 --clean-install-oracle ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxProducenten ; ./build.ps1 --clean-install-oracle ; git checkout -- .\.nuke\build.schema.json ;




# My prefered installation command  --clean-install
Set-Location D:\projects\SideKick ;        ./build.ps1 --clean-install-oracle > (-join( (Get-Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log")) ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxGeneriek ;    ./build.ps1 --clean-install-oracle > (-join( (Get-Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log")) ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxProducenten ; ./build.ps1 --clean-install-oracle > (-join( (Get-Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log")) ; git checkout -- .\.nuke\build.schema.json ;

# My prefered installation command  --delta-install
Set-Location D:\projects\SideKick ;        ./build.ps1 > (-join( (Get-Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log")) ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxGeneriek ;    ./build.ps1 > (-join( (Get-Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log")) ; git checkout -- .\.nuke\build.schema.json ;
Set-Location D:\projects\FluxProducenten ; ./build.ps1 > (-join( (Get-Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log")) ; git checkout -- .\.nuke\build.schema.json ;

