#!/usr/bin/env bats

load $(pwd)/functions/utils/files.sh

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