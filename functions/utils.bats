#!/usr/bin/env bats

load $(pwd)/functions/utils.sh

@test "Test return-true() should pass - if status is 0" {
    run return-true
    [ $status = 0 ]
}

@test "Test return-false() should pass - if status is 1" {
    run return-false
    [ $status = 1 ]
}

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

@test "Test get-file-name-from-path() should return 'php.ini' - if string is 'web/conf/php.ini'" {
    local FILE_PATH="web/conf/php.ini"
    run get-file-name-from-path "$FILE_PATH"
    [ "$output" == "php.ini" ]
}

@test "Test get-file-name-from-path() should return 'docker-compose.yml' - if string is 'docker-compose.yml'" {
    local FILE_PATH="docker-compose.yml"
    run get-file-name-from-path "$FILE_PATH"
    [ "$output" == "docker-compose.yml" ]
}