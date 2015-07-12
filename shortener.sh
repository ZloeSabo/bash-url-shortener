#!/usr/bin/env bash

SHORTENER_CHARSET=( {a..z} {A..Z} {0..9} )
LINK_DIRECTORY="$PWD/links"
LOCKFILE="$PWD/shortener.lock"

ensure_dirs() {
    [ -d $LINK_DIRECTORY ] || \
        mkdir $LINK_DIRECTORY
}

save_url() {
    local dir=$1
    local url=$2
    mkdir "$LINK_DIRECTORY/$dir"
    echo $url > "$LINK_DIRECTORY/$dir/url.txt"
}

resolve_url() {
    local id=$1
    local file_with_url="$LINK_DIRECTORY/$id/url.txt"
    [ -a $file_with_url ] && \
        echo $(cat $file_with_url)
}


increase_views() {
    #do noting for now
    return 0
}

generate_id() {
    #ls -l gives N+1 on non empty directory
    #so no need to increase
    local count=$(ls -l $LINK_DIRECTORY |wc -l)
    [ $count -lt 1 ] && \
        count=1

    echo $count
}

encode() {
    local num=$1
    #[ $num -lt 1000 ] && num=$(($num + 1000))
    local base=${#SHORTENER_CHARSET[*]}
    local result=""
    while [[ $num -gt 0 ]]; do
        local remainder=$(($num % $base))
        local index=$((remainder-1))
        recv "num: $num"
        recv "base: $base"
        recv "remainder: $remainder"
        recv "index: $index"
        result+=${SHORTENER_CHARSET[$index]}
        num=$(($num / $base))
    done

    echo $(echo $result |rev)
}

shorten() {
    local subject=$1
    ensure_dirs
    local new_link_number=$(generate_id)
    local shortcode=$(encode $new_link_number)
    save_url $shortcode $subject

    echo $shortcode
}
