# https://superuser.com/questions/1069346/how-to-automate-setting-chrome-as-default-browser-in-windows-10
function Set-ChromeAsDefaultBrowser {
    Add-Type -AssemblyName 'System.Windows.Forms'
    Start-Process $env:windir\system32\control.exe -ArgumentList '/name Microsoft.DefaultPrograms /page pageDefaultProgram\pageAdvancedSettings?pszAppName=google%20chrome'
    Sleep 5
    [System.Windows.Forms.SendKeys]::SendWait("{TAB} {ENTER}{TAB} ")
}

$i = 1
while ($i -le 5) {
    try {
        Set-ChromeAsDefaultBrowser
        break
    }
    catch {
        if ($i -eq 5) {
            taskkill /IM gitlab-runner.exe /F
        }
        $i++
    }
}
