

$SourceDir = "./testfiles/"
$regex = "((.\d+-\d+)|(UNKNOWN))_\d{2}( \(\d\))*\.(pdf|tif)"
$files = Get-ChildItem "$sourceDir*.*" -Recurse
$i = 0

foreach ($file in $files) {
    Write-Verbose "Checking $($file.Name)"
    if(!($file.Name -match $regex)) {
        Write-Warning "Bad file name: $($file.FullName)"
        $i++
    }
}

Write-Output "$i bad file names"