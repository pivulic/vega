#!/usr/bin/env bats

load $(pwd)/functions/utils.sh

@test "Test to-lower-case() should return 'a string' - if string is 'A String'" {
    local STRING="A String"
    run to-lower-case "$STRING"
    [ "$output" == "a string" ]
}

@test "Test is-string-in-variable() should pass - if string is found in variable" {
    local SEARCH_STRING="substring"
    local VARIABLE_STRING="some string with a substring you want to match"
    run is-string-in-variable "$SEARCH_STRING" "$VARIABLE_STRING"
    [ $status = 0 ]
}

@test "Test is-string-in-variable() should fail - if string is not found in variable" {
    local SEARCH_STRING="non-existing-string"
    local VARIABLE_STRING="some string with a substring you want to match"
    run is-string-in-variable "$SEARCH_STRING" "$VARIABLE_STRING"
    [ $status = 1 ]
}