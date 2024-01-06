# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.33] - 2022-06-23
Updated:
* Decreased volume size to 100 from 200.

## [0.0.32] - 2022-06-21
Updated:
* Replace CurrentBuildmgmt_svc with shorter name "CurrentBld_svc".

## [0.0.31] - 2022-05-16
Updated:
* Copy artifacts to different location.

## [0.0.30] - 2022-05-15
Updated:
* Added testcase back as we can pull fixed-version of artifacts.

## [0.0.29] - 2022-05-03
Updated:
* Temporarily comment out testcase due to changes from TCUD-3662 in ayx-core.

## [0.0.28] - 2022-04-24
Updated:
* Replace Devopsmgmt_svc with CurrentBuildmgmt_svc.

## [0.0.27] - 2022-03-21
Updated:
* Removed Iexplore and updated tests to work since there has been multiple updates since last they were run.

## [0.0.26] - 2022-02-15
Updated:
* Turn of windows defender realtime protection so it doesn't mark apm as a virus.

## [0.0.25] - 2022-01-20
Updated:
* grabbing the security group and the subnet from environment variables.

## [0.0.24] - 2021-12-02
Updated:
* Better logging
* Always grabbing the latest ami.

## [0.0.23] - 2021-11-17
Updated:
* Pointed towards the LZ account.

## [0.0.22] - 2021-11-11
Added:
* Added a wait to ensure that chrome is installed before continuing.

## [0.0.21] - 2021-11-10
Removed:
* sysprep

## [0.0.20] - 2021-11-05
Added:
* sysprep

## [0.0.19] - 2021-10-14
UPdated:
* Updated base AMI to include new process_end script updates.
* Change the method we used to download psexec as choco failed due to checksum.

## [0.0.18] - 2021-09-14
UPdated:
* Using the Windows Regression vanilla base ami instead of the manual ami.

## [0.0.17] - 2021-09-14
UPdated:
* Using new base ami and setting the chrome as default browser using a script and to be placed in the startup script location.

## [0.0.16] - 2021-09-03
UPdated:
* Using new base ami that has chrome set as default for the svc management account.

## [0.0.15] - 2021-09-02
UPdated:
* Modified the creation of the Windows_manual_guitest_ ami and made sure to sysprep the image before hand.
Added:
* We install google chrome via chocolaty.

## [0.0.14] - 2021-08-26
UPdated:
* Created a new manual ami after a full run of the Guitest role with a manual action to ensure that the browser the guitests are opening is chrome.
* Set the Guitest ami to be built off of the manually created ami and commentted out a large portion of the tasks to both include them in the event of future changes but to also ensure theat there were still some tasks that make changes to the ami.
Added:
* Additional test file to test gui test that opens a web browser.

## [0.0.13] - 2021-08-23
Updated:
* Guitest sonarqube job failed due to access deny when calling Opencover which is installed
  to default location C:/Users. Using 'become' in ansible code to provide full privileges to
  the remote user. In this case, we use CurrentBuildmgmt_svc which is the user to run pipeline.

Added:
* Install opencover 4.7.922 and add to PATH

## [0.0.11] - 2021-06-29
Added:
* Created new smoke tests test functionality rather then unit testing.
* Installilng psexec.
* Additional variables to have molecule ensure exist before continuing.
* psexec
* Startup batch script to allow for registering the instance to gitlab through the console mode.

Updated:
* We are using chocolaty to install google chrome.

## [0.0.10] - 2021-06-18
Updated:
* removed sysprep as it was undoing registry changes.
* Changed how we were installing google chrome as the choco way can't find the msi anymore.
* Additional usefull registry changes.
* Ensuring that the molecule creation doesn't start unless we have the autologon variable defined.

## [0.0.9] - 2021-06-11
Updated:
* Updated to use the new Windows 2016 Base AMI.

## [0.0.8] - 2021-06-11
Updated:
* Using the correct packer filter to look for the base AMI.

## [0.0.7] - 2021-06-08
Added:
* Allowed for long file paths.
* 7-zip.

## [0.0.6] - 2021-06-07
Added:
* Google Chrome is installed.

## [0.0.5] - 2021-06-03
Added:
* Windows Error reporting turned off.

## [0.0.4] - 2021-06-03
Added:
* Auto Logon enabled for the DevOpsAdmin account.

## [0.0.3] - 2021-06-02
Added:
* TightVNC and DFmirage.

## [0.0.2] - 2021-06-01
Added:
* Created the packages task to install nunit and jfrog.

## [0.0.1] - 2021-05-27
- Initialize.
