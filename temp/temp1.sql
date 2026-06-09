
# Pipe output command to a log file with datetimestamp in the filename
echo "Create log file with actual datetimestamp in filename" > (-join( (Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log"))


./build.ps1 --database-user "GILIAM.BREEMS" --database-password "Oracle_ww1" > (-join( (Date).ToString("yyyyMMddHHmmss"), "_", ((Get-Item .).Name), "_", "release_rollout.log"))
