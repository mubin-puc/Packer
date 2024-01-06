guitest-molecule
=========

This role is used to create Guitest machines.

Requirements
------------

All requirements needed to run this molecule in a local environemnt can be found in the requiremnts.txt located in the root dir of this repository.

Role Variables
--------------

The only variables that need to be set for this role to work is `$GOLD_ADMIN_USER`, `$GOLD_ADMIN_PASSWORD`, `CurrentBld_svc_username`, `CurrentBuildmgmt_svc_password`, and `TEDDY_PASSWORD`. These variables correspond to the default credentials set on the ami to allow for login and TightVNC auto logon.

Dependencies
------------

No dependencies.