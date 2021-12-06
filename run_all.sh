#!/usr/bin/env bash

set -euo pipefail

for day in $(seq -f "%02g" 1 25); do
  if [ -d "${day}" ]; then
    cd "${day}"
    ./day_"${day}".rb
    printf "\n######################\n\n"
    cd ..
  fi
done
