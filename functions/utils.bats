#!/usr/bin/env bats

load $(pwd)/functions/utils.sh

@test "Test to-lower-case() should return 'a string' - if string is 'A String'" {
    local STRING="A String"
    run to-lower-case "$STRING"
    [ "$output" == "a string" ]
}