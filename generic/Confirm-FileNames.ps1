<#
.SYNOPSIS
    Confirms a list of file names matches against a regex string.

.DESCRIPTION
    Takes an array of FileInfo objects and compares the name against a user-
    provided regex string. 

.PARAMETER Files
    Array of FileInfo objects to confirm file names against.

.PARAMETER RegexString
    Regex string to compare with $Files

.INPUTS
    FileInfo[]

.OUTPUTS
    FileInfo[] of all files failing the regex challenge

.EXAMPLE
    ./generic/Confirm-FileNames.ps1 -Files (Get-ChildItem -Path "./testfiles/*.*" -Recurse) -RegexString "((.\d+-\d+)|(UNKNOWN))_\d{2}( \(\d\))*\.(pdf|tif)"

.EXAMPLE
    Get-ChildItem -Path "./testfiles/*.*" -Recurse | ./generic/Confirm-FileNames.ps1 -RegexString "((.\d+-\d+)|(UNKNOWN))_\d{2}( \(\d\))*\.(pdf|tif)"
#>

$SourceDir = "./testfiles/"
$regex = "((.\d+-\d+)|(UNKNOWN))_\d{2}( \(\d\))*\.(pdf|tif)"
$files = Get-ChildItem "$sourceDir*.*" -Recurse
$i = 0

foreach ($file in $files) {
    Write-Verbose "Checking $($file.Name)"
    if (!($file.Name -match $regex)) {
        Write-Warning "Bad file name: $($file.FullName)"
        $i++
    }
}

Write-Output "$i bad file names"