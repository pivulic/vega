#!/usr/bin/env bats

load $(pwd)/functions/utils/strings.sh

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

@test "Test has-variable-prefix() should pass - if variable starts with prefix \"m2-\"" {
    local VARIABLE="m2-ikea"
    local PREFIX="m2-"
    run has-variable-prefix "$VARIABLE" "$PREFIX"
    [ $status = 0 ]
}

@test "Test has-variable-prefix() should fail - if variable doesn't starts with prefix \"m2-\"" {
    local VARIABLE="super-m2-ikea"
    local PREFIX="m2-"
    run has-variable-prefix "$VARIABLE" "$PREFIX"
    [ $status = 1 ]
}