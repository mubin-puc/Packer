#!/bin/bash

source ./setup-env.sh

packer build "$@" guitest.json
