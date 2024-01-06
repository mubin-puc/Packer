# windows-2016-guitest

## Technical Dependencies
1. Packer
2. Bash

## General
This is used to build an AMI that can run guitests in the ayx-core repository.

## Building the image locally
**DO NOT RUN WITH PACKER ALONE! USE THE BUILD SCRIPT**
1. Grab the Gold ami user (DevOpsAdmin) from lastpass
    1. If you don't have access to lastpass any user and password will work 
    here as long as its remembered to login to the image later
2. Run the script `./build-golden.sh`. This script will ask you for the user/password
information and will set additional env vars needed to build the image

## Usage of the image
This image will be used to run guitests inside the ayx-core repo.

This image is built from a custom vanilla windows 2016 ami and prepared for use by packer
and powershell scripts. This particular image has no scripts to run on boot since
its has no need to be prepped. 
