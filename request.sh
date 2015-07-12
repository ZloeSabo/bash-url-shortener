declare REQUEST_BODY
declare REQUEST_METHOD
declare REQUEST_URI
declare REQUEST_HTTP_VERSION

handle_request_start_line() {
    read -r line
    line=${line%%$'\r'}
    recv "$line"

    echo $line
}

request_header_for() {
    local header=$1
    header=${header//-/_}
    header=$(to_upper "$header")
    echo "REQUEST_HEADER_$header"
}

handle_request_headers() {
    while IFS=':' read -r key value; do
        key=$(trim "$key")
        value=$(trim "$value")
        [ -z $key ] && break
        local header=$(request_header_for "$key")
        #recv "Header: $header=>$value"
        printf -v $header %s "$value" #some kind of evaluation magic
    done
}

handle_request_body() {
    local body_length=$1
    read -n $1 line
    REQUEST_BODY=$line
}

handle_request() {
    read -r REQUEST_METHOD REQUEST_URI REQUEST_HTTP_VERSION <<< $(handle_request_start_line)
    [ -n "$REQUEST_METHOD" ] && \
        [ -n "$REQUEST_URI" ] && \
        [ -n "$REQUEST_HTTP_VERSION" ] \
        || send_response_bad_request

    handle_request_headers
    local content_length=${REQUEST_HEADER_CONTENT_LENGTH}
    [ -n "$content_length" ] && \
        handle_request_body $content_length
}

server_url() {
    echo ${REQUEST_HEADER_HOST}
}
