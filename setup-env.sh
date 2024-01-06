#!/bin/bash

find_string () {
  if echo "$2" | grep -q "$1"; then
    return 0
  fi
  return 1
}

set_var () {
  if ! ( env | grep -q "$1"); then
    args=""
    add_echo=""
    if find_string 'PASSWORD' "$1"; then
      args+="-s"
      add_echo='echo'
    fi
    read -r -p "Enter $1: " $args value
    eval "export $1='$value'"
    eval "$add_echo"
  fi
}

set_var 'GOLD_ADMIN_USER'
set_var 'GOLD_ADMIN_PASSWORD'

export GOLD_VERSION="$(cat version.txt)"

if (env | grep -q "CI_COMMIT_REF_SLUG"); then
  export CI_COMMIT_REF_SLUG="$(git branch --show-current)"
fi

if (env | grep -q "CI_COMMIT_SHORT_SHA"); then
  export CI_COMMIT_SHORT_SHA="$(git rev-parse --short=8 HEAD)"
fi

branch=$CI_COMMIT_REF_SLUG
env=$branch
if [[ $branch == "main" ]]; then
  env="prod"
fi
export GOLD_ENV=$env


