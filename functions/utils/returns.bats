#!/usr/bin/env bats

load $(pwd)/functions/utils/returns.sh

@test "Test return-true() should pass - if status is 0" {
    run return-true
    [ $status = 0 ]
}

@test "Test return-false() should pass - if status is 1" {
    run return-false
    [ $status = 1 ]
}