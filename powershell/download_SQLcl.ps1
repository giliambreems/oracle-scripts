param (
    [string]$version,
    [string]$outputFolder = "."
)

# Determine URL
if ([string]::IsNullOrWhiteSpace($version)) {
    Write-Host "No version specified -> using latest"
    $url = "https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip"
    $fileName = "sqlcl-latest.zip"
}
else {
    Write-Host "Using version: $version"

    if ($version -notmatch '^\d+\.\d+\.\d+\.\d+\.\d+$') {
        Write-Host "##vso[task.logissue type=error]Invalid version format: $version"
        exit 1
    }

    $url = "https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-$version.zip"
    $fileName = "sqlcl-$version.zip"
}

# Always ensure folder exists (cache or no cache)
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null
}

$outputPath = Join-Path $outputFolder $fileName

Write-Host "Downloading from: $url"
Write-Host "Saving to: $outputPath"

try {
    Invoke-WebRequest -Uri $url -OutFile $outputPath -UseBasicParsing
}
catch {
    Write-Host "##vso[task.logissue type=error]Download failed"
    throw
}

# extract the downloaded archive
$extractPath = Join-Path $outputFolder "."
Expand-Archive -Path $outputPath -DestinationPath $extractPath -Force

Write-Host "Download completed successfully"
Write-Host "##vso[task.setvariable variable=SQLCL_PATH]$outputPath"
Write-Host "##vso[task.setvariable variable=SQLCL_HOME]$extractPath"
