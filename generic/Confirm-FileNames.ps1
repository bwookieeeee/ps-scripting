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


$BadFiles = @()

function Confirm-FileNames {

    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $Files,
        [Parameter(Mandatory = $true)]
        [string]
        $RegexString,
        [switch]
        $FullWidthOutput
    )

    foreach ($File in $Files) {

        # I like full width output spacing because I can just scan my eyes down
        # the terminal to quickly see what passes and fails. It's a switch 
        # because I do not like this on extremely wide terminals.
        $str = $File.Name + " "
        if ($FullWidthOutput) {
            $len = $str.Length
            for ($i = 0; $i -lt $Host.UI.RawUI.WindowSize.Width - $len - 8; $i++) {
                $str += "."
            }
        }
        Write-Host -NoNewline $str
        Write-Host -NoNewline -ForegroundColor DarkMagenta " ["
        if ($file.Name -match $RegexString) {
            Write-Host -NoNewline -ForegroundColor DarkGreen "PASS"
        }
        else {
            Write-Host -NoNewline -ForegroundColor Red "FAIL"
            $badFiles += $File.Name
        }
        Write-Host -ForegroundColor DarkMagenta "]"
    }
}