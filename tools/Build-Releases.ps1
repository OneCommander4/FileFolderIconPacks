[CmdletBinding()]
param(
    [string]$OutputDirectory
)

$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
if (-not $OutputDirectory) {
    $OutputDirectory = Join-Path $repositoryRoot 'release'
}
else {
    $OutputDirectory = [System.IO.Path]::GetFullPath($OutputDirectory)
}

$iconsDirectory = Join-Path $repositoryRoot 'Icons'
$filesDirectory = Join-Path $iconsDirectory 'Files'
$foldersDirectory = Join-Path $iconsDirectory 'Folders'
$noticesDirectory = Join-Path $repositoryRoot 'Notices'

foreach ($requiredPath in @($filesDirectory, $foldersDirectory, $noticesDirectory)) {
    if (-not (Test-Path -LiteralPath $requiredPath)) {
        throw "Required repository directory is missing: $requiredPath"
    }
}

$sevenZipCommand = Get-Command '7z.exe' -ErrorAction SilentlyContinue
$sevenZip = if ($sevenZipCommand) {
    $sevenZipCommand.Source
}
else {
    Join-Path $env:ProgramFiles '7-Zip\7z.exe'
}
if (-not (Test-Path -LiteralPath $sevenZip)) {
    throw '7-Zip is required to build release archives. Install 7-Zip and run this script again.'
}
New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null
Get-ChildItem -LiteralPath $OutputDirectory -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Extension -eq '.zip' -or $_.Name -eq 'SHA256SUMS.txt' } |
    Remove-Item

function New-ZipArchive {
    param(
        [Parameter(Mandatory)]
        [string]$FileName,

        [Parameter(Mandatory)]
        [string[]]$RelativePaths
    )

    $destination = Join-Path $OutputDirectory $FileName
    if (Test-Path -LiteralPath $destination) {
        Remove-Item -LiteralPath $destination
    }

    $arguments = @('a', '-tzip', '-mx=5', '-bd', '-y', $destination) + $RelativePaths
    & $sevenZip @arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Unable to create $FileName"
    }
}

Push-Location $repositoryRoot
try {
    New-ZipArchive -FileName 'OneCommander-FileFolderIconPacks-All.zip' -RelativePaths @(
        'Icons',
        'Notices',
        'README.md'
    )

    $styleNames = @(
        Get-ChildItem -LiteralPath $filesDirectory -Directory | Select-Object -ExpandProperty Name
        Get-ChildItem -LiteralPath $foldersDirectory -Directory | Select-Object -ExpandProperty Name
    ) | Sort-Object -Unique

    foreach ($styleName in $styleNames) {
        $archivePaths = @('README.md')
        $fileStyle = Join-Path $filesDirectory $styleName
        $folderStyle = Join-Path $foldersDirectory $styleName

        if (Test-Path -LiteralPath $fileStyle) {
            $archivePaths += "Icons/Files/$styleName"
        }
        if (Test-Path -LiteralPath $folderStyle) {
            $archivePaths += "Icons/Folders/$styleName"
        }

        $safeName = (($styleName -replace '[^A-Za-z0-9._-]+', '-') -replace '-{2,}', '-').Trim('-')
        New-ZipArchive -FileName "$safeName-OneCommander.zip" -RelativePaths $archivePaths
    }
}
finally {
    Pop-Location
}

$checksumPath = Join-Path $OutputDirectory 'SHA256SUMS.txt'
$checksumLines = Get-ChildItem -LiteralPath $OutputDirectory -File -Filter '*.zip' |
    Sort-Object Name |
    ForEach-Object {
        $hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        "$hash  $($_.Name)"
    }
[System.IO.File]::WriteAllLines($checksumPath, $checksumLines, [System.Text.UTF8Encoding]::new($false))

Write-Host "Created $($checksumLines.Count) ZIP archives in $OutputDirectory"
