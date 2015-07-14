shortener_redirect() {
    local id=$2
    local url=$(resolve_url "$id")
    recv "Redirecting id: $id to $url"
    [ -n "$url" ] || \
        send_response_internal_error

    #increase_views $id
    set_response_header "Location" $url
    send_response_redirect
}

shorten_url() {
    local url=$(get_json_val "url" $REQUEST_BODY)
    [ -n "$url" ] || \
        send_response_bad_request
    recv "Shorten url: $url"

    local shortcode=$(do_locked shorten $url)
    local server_url=$(server_url)
    local newurl="://$server_url/$shortcode"
    send_json_response <<< "{\"url\":\"$newurl\"}"
}


post '^/(.*)' shorten_url
get '^/(.*)' shortener_redirect
