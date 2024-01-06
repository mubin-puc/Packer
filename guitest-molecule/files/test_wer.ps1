Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Start a new PowerShell process to crash
Start-Process -FilePath "powershell" -ArgumentList "-Command", "[System.Diagnostics.Debugger]::Break()"
Start-Sleep 5

# Find the WerFault process
$wer = Get-Process | Where-Object {  $_.MainWindowTitle -ieq "Windows PowerShell" -and $_.ProcessName -ieq "WerFault" }

if ($wer) {
    # Press ESC on the window to dismiss it. Simply killing the process just relaunches it.
    # This is not really needed for the test, but we're just being nice by cleaning up.
    $wshell = New-Object -ComObject WScript.Shell
    $wshell.AppActivate($wer.MainWindowTitle) | Out-Null
    $wshell.SendKeys("{ESC}")

    throw "Test failed: WER UI found"
}
else {
    Write-Output "Test succeeded: WER UI not found"
}
