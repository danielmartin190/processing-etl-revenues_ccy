#!/bin/bash

set -eo pipefail
IFS=$'\n\t'

run_test() {
    echo Running $1
    $1
}

run_test ./tests/test_run_test.sh
