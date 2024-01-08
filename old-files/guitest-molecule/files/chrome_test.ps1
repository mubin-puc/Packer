param (
    [string]$token,
    [string]$apikey
)

$ErrorActionPreference = "Stop"
Set-Location -Path C:\
mkdir chrome_test
Set-Location -Path chrome_test
git config --system core.longpaths true
git clone https://gitlab-ci-token:$token@git.alteryx.com/ayx-core/ayx-core.git
Set-Location -Path ayx-core
Set-Item -Path Env:CI_COMMIT_REF_NAME -Value 'molecule-local'
Set-Item -Path Env:CI_PROJECT_DIR -Value 'C:\chrome_test\ayx-core'

#Gui
mkdir ./logs
$env:JFROG_CLI_OFFER_CONFIG = "False"
./.gitlab-ci/scripts/mount_s.ps1

$artifact = "main-8757f2e1-Debug.7z"
$dest_path = "S:\"
$artifact_repo = "Runner_resources/guitest/main-8757f2e1-Debug.7z"
jfrog rt dl $artifact_repo $artifact --url=https://artifactory.alteryx.com/artifactory --apikey=$apikey

C:\"Program Files"\7-Zip\7z.exe x "S:/guitest/main-8757f2e1-Debug.7z" "-o${dest_path}" -y

$log = "./logs/chrome_test.log"

S:\3rdParty\testtools\NUnit.2.6.4\NUnit-2.6.4\bin\nunit-console.exe "S:\Alteryx\bin_x64\Debug\AlteryxGuiToolkit.Tests.dll" /labels /run:"AlteryxGuiToolkit.Tests.FunctionalTests.White.SimpleTests.It_can_run_a_simple_workflow,AlteryxGuiToolkit.Tests.FunctionalTests.AutoConnectTests.It_can_auto_connect_two_standard_tools_on_create_in_horizontal_layout" | Tee-Object -FilePath "$log"

./.gitlab-ci/scripts/check_log.ps1 -LogPath $log
