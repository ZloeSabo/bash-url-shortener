#!/usr/bin/env bash

NOW=$(date +"%a, %d %b %Y %H:%M:%S %Z")
declare -a RESPONSE_HEADERS=(
    "Date: $NOW"
    "Server: bash url shortener"
)

declare -a RESPONSE_CODES=(
    [200]="OK"
    [400]="Bad Request"
    [404]="Not Found"
    [500]="Internal Server Error"
)

set_response_header() {
    RESPONSE_HEADERS+=("$1: $2")
}

response_code() {
    echo ${RESPONSE_CODES[$1]}
}

send_start_line() {
    local description=$(response_code "$1")
    send "HTTP/1.1 $1 $description"
}

send_headers() {
    for i in "${RESPONSE_HEADERS[@]}"; do
        send "$i"
    done
}

send_body() {
    while read -r line; do
        send "$line"
    done
}

send_response() {
    send_start_line $1
    send_headers
    send
    send_body
}

send_response_ok() {
    send_response 200;
    exit 0;
}

send_response_ok_empty() {
    send_response_ok <<< ""
}

send_response_redirect() {
    send_response 301 <<< ""
    exit 0;
}

send_response_bad_request() {
    send_response 400 <<< "";
    exit 1;
}

send_response_not_found() {
    send_response 404 <<< "Not found"
    exit 1;
}

send_response_internal_error() {
    send_response 500 <<< "";
    exit 1;
}

send_json_response() {
    set_response_header "Content-Type" "application/json"
    send_response_ok
}
