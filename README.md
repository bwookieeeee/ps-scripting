# PowerShell Scripts

PowerShell scripts I designed to help my workload at Relay.

I would have greatly preferred to sctructure these files in a more readable
format with better practices, but you cannot run saved powershell scripts from
the terminal; so I have to manually write these out into the terminal for them
to work. Any "Why didn't you..." questions could be answered by such a
restraint.

## Generic/Confirm-FileNames

Takes an array from `Get-ChildInfo` and matches file names against a regex
string. Prints to the console if a file is a pass or fail.

Usage:

```powershell
Confirm-FileNames [-Files] <Object> [-RegexString] <string> [-FullWidthOutput] [<CommonParameters>]

OR

Get-ChildItem ... | Confirm-FileNames [-RegexString] <string> [-FullWidthOutput] [<CommonParameters>]
```

| Argument | Example | Description |
| -------- | ------- | ----------- |
| `-Files` | `-Files Get-ChildItem *.*` | Array of files to confirm names against |
| `-RegexString` | `-RegexString ".*"` | The regex string to challenge against the file names |
| `-FullWidthOutput` | `-FullWidthOutput` | Toggles pushing `[PASS]`/`[FAIL]` flags to the right edge of the terminal window |

![Confirm-FileNames output](./imgs/Confirm-FileNames%20output.png)

### Known Issues

1. [When piping an input into Confirm-FileNames, it does not iterate through  the entire array](https://github.com/bwookieeeee/PS-Scripts/issues/1)
