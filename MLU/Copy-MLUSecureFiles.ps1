<#
.SYNOPSIS
    Copy files in a directory and produces a hash to verify that they have copied correctly. 
    Logic is configured to match folder structure for MultCo Land Use contract.

.PARAMETER Targets
    Optional array of "box numbers" to copy

.PARAMETER InvertTargets
    When flag is set, changes Targets from a whitelist to a blacklist.

.PARAMETER Path
    Parent directory of target folders

.PARAMETER OutputDir
    Output target for copy

.PARAMETER Classic
    Shows classic Write-Progress output instead of default minimal.
#>

function Copy-MLUSecureFiles {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        $Targets,
        [switch]
        $InvertTargets,
        $Path,
        $OutputDir,
        [switch]
        $Classic
    )

    $startTime = Get-Date
    $i = 1
    $TerminalWidthModifier = 131

    if ($Classic) {
        $PSStyle.Progress.View = "Classic"
    }

    $files = @()

    if ($Targets.Count -gt 0) {
        $files = Get-ChildItem -Path $Path -Recurse | Where-Object { 
            ($InvertTargets) ? !($Targets -contains $_.FullName.Substring($Path.Length, 5)) 
            : $Targets -contains $_.FullName.Substring($Path.Length, 5) }
    }

    foreach ($file in $files) {
        $elapsed = ((Get-Date) - $startTime).TotalSeconds
        $remains = $files.Count - $i
        $avgTime = $elapsed / $i
        $tgt = $file.FullName.Substring($Path.Length)
        Write-Progress -Activity "Copy Secure Files" -Status "$i of $($files.Count)" -PercentComplete (($i / $files.Count) * 100) -SecondsRemaining ($remains * $avgTime) -CurrentOperation $tgt
        $str = "$tgt | "
        $isTooWide = $Host.UI.RawUI.WindowSize.Width -lt ($str.Length + $TerminalWidthModifier)
        Write-Host -NoNewline $str
        $PreHash = Get-FileHash $file.FullName
        $PreHashStr = ($isTooWide) ? $PreHash.Hash.Substring($PreHash.Hash.Length - 5) : $PreHash.Hash
        Write-Host -NoNewline "$PreHashStr | "
        $postHash = $null
        if ($PSCmdlet.ShouldProcess($tgt, "Copy-Item")) {
            New-Item -ItemType File -Path "$OutputDir$tgt" -Force | Out-Null # This line makes the all the required subfolders for the target file.
            Copy-Item -Path $file.FullName -Destination "$OutputDir$tgt" -Force
            $postHash = Get-FileHash "$OutputDir$tgt"
        }
        else {
            $postHash = $PreHash
        }
        $PostHashStr = ($isTooWide) ? $PostHash.Hash.Substring($PostHash.Hash.Length - 5) : $PostHash.Hash
        if ($preHash.Hash -eq $postHash.Hash) {
            Write-Host -ForegroundColor DarkGreen $PostHashStr
        }
        else {
            Write-Host -ForeGroundColor Red $PostHashStr
        }
    }
}