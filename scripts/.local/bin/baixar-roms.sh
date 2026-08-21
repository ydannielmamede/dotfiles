#!/bin/bash

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
. "$SCRIPT_DIR/lib-sync.sh"

sync_run download roms
