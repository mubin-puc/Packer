"""Example test. Update tests to your standard"""
import os

# pylint: disable=W0611
import pytest
import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ["MOLECULE_INVENTORY_FILE"]
).get_hosts("all")

# https://www.tutorialspoint.com/compare-version-numbers-in-python
def compareVersion(version1, version2):
    versions1 = [int(v) for v in version1.split(".")]
    versions2 = [int(v) for v in version2.split(".")]
    for i in range(max(len(versions1),len(versions2))):
        v1 = versions1[i] if i < len(versions1) else 0
        v2 = versions2[i] if i < len(versions2) else 0
        if v1 >= v2:
            return 1
        elif v1 < v2:
            return -1
    return 0

def test_connection(host):
    """Example tests that runs an example command on windows"""
    # Executes the command `echo "Hello World"` and checks the output
    # Tests that the server is up and running and is reachable
    # This is an example test and can be safely removed
    ver = host.ansible("win_shell", "echo \"Hello World\"", check=False,)["stdout"]
    assert ver.strip() == "Hello World"

def test_choco_sources(host):
    results = host.ansible("win_chocolatey_facts")
    choco_source = results.get('ansible_facts').get('ansible_chocolatey').get('sources')
    # choco_source is an array of dictionaries each containing the choco source.
    choco_names = [x['name'] for x in choco_source]

    assert 'alteryx-nuget-mirror' in choco_names
    assert 'alteryx-nuget-development' in choco_names
    assert 'alteryx' in choco_names
    assert 'alteryx-cache' in choco_names
    assert 'chocolatey' not in choco_names

def test_jfrog(host):
    ver = host.ansible("win_shell", "jfrog --version", check=False,)["stdout"]
    assert compareVersion(ver.strip("jfrog version "), "1.48.1") == 1

def test_NET_35(host):
    ver = host.ansible("win_shell", "(Get-WindowsFeature -Name Net-Framework-Core).InstallState", check=False,)["stdout"]
    assert ver.strip() == "Installed"

def test_7zip(host):
    ver = host.ansible("win_shell", "choco list --exact 7zip --local-only --limit-output | Select-String -quiet '19.0.0'", check=False,)["stdout"]
    assert ver.strip() == "True"

def test_tightvnc_exists(host):
    stat = host.ansible(
        "win_stat",
        "path=\"C:/Program Files/TightVNC/tvnserver.exe\"",
        check=False,
    )["stat"]
    assert stat['exists'] is True

def test_dfmiragec_exists(host):
    stat = host.ansible(
        "win_stat",
        "path=\"C:/Program Files/DemoForge/Mirage Driver for TightVNC/unins000.exe\"",
        check=False,
    )["stat"]
    assert stat['exists'] is True

def test_AutoAdminLogon_registry(host):
    stat = host.ansible(
        "win_reg_stat",
        "path=\"HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\"",
        check=False,
    )["properties"]
    assert stat["AutoAdminLogon"]["value"] == "1"

def test_DefaultUserName_registry(host):
    admin_user = "CurrentBld_svc"
    stat = host.ansible(
        "win_reg_stat",
        "path=\"HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\"",
        check=False,
    )["properties"]
    assert stat["DefaultUserName"]["value"] == admin_user

def test_DefaultPassword_registry(host):
    result = host.ansible("debug", "msg={{ lookup('amazon.aws.aws_secret', 'gitlab/CurrentBuildmgmt_svc/password') }}")
    admin_password = result.get("msg")["gitlab/CurrentBuildmgmt_svc/password"]

    stat = host.ansible(
        "win_reg_stat",
        "path=\"HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\"",
        check=False,
    )["properties"]
    assert stat["DefaultPassword"]["value"] == admin_password

def test_WindowsError_registry(host):
    stat = host.ansible(
        "win_reg_stat",
        "path=HKLM:\\System\\CurrentControlSet\\Control\\Windows",
        check=False,
    )["properties"]
    assert stat["ErrorMode"]["value"] == 2

def test_windows_error_reporting_registry(host):
    stat = host.ansible(
        "win_reg_stat",
        "path=\"HKLM:\\Software\\Microsoft\\Windows\\Windows Error Reporting\"",
        check=False,
    )["properties"]
    assert stat["DontShowUI"]["value"] == 1

def test_windows_error_reporting_ui(host):
    err = host.ansible("win_shell", "C:/dependencies/test_wer.ps1", check=False,)["stderr"]
    assert err.strip() == ""

def test_microsoft_powershellscript_startup(host):
    stat = host.ansible(
        "win_reg_stat",
        "path=\"HKCR:\\Microsoft.PowerShellScript.1\\Shell\"",
        check=False,
    )["properties"]
    assert stat[""]["value"] == "0"

def test_opencover(host):
    result = host.ansible("debug", "msg={{ lookup('env', 'CurrentBld_svc_username') }}")
    autologon_user = result.get('msg')

    ver = host.ansible("win_shell", f"C:\\Users\\{autologon_user}\\AppData\\Local\\Apps\\OpenCover\\opencover.console.exe -version", check=False,)["stdout"]
    assert ver.strip() == "OpenCover version 4.7.922.0"

def test_chrome_test(host):
    whoami = host.ansible("win_whoami", check=False,)["account"]
    server = whoami.get("domain_name")

    result = host.ansible("debug", "msg={{ lookup('env', 'CurrentBuildmgmt_svc_password') }}")
    autologon_password = result.get("msg")

    result = host.ansible("debug", "msg={{ lookup('env', 'CurrentBld_svc_username') }}")
    autologon_user = result.get("msg")

    result = host.ansible("debug", "msg={{ lookup('env', 'TKN_DevOps_AYX_CORE_Clone') }}")
    git_clone_tkn = result.get("msg")

    result = host.ansible("debug", "msg={{ lookup('env', 'Artifactory_API_Key') }}")
    api_key = result.get("msg")

    err = host.ansible(
        "win_shell",
        f'psexec -accepteula \\\\{server} -s -i 1 -w C:/dependencies -u {autologon_user} -p "{autologon_password}" -h cmd.exe /c "echo .|powershell.exe -file C:/dependencies/chrome_test.ps1 -token {git_clone_tkn} -apikey {api_key}"',
        check=False,
    )["rc"]
    assert err == 0

def test_windows_defender(host):
    ver = host.ansible("win_shell", "(Get-MpComputerStatus).RealTimeProtectionEnabled", check=False,)['stdout']
    assert ver.strip() == 'False'
