recv() { echo "< $@" >&2; }
send() { echo "> $@" >&2;
         printf '%s\r\n' "$*"; }

trim() {
    local var="$*"
    var="${var#"${var%%[[:alnum:][:punct:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[[:alnum:][:punct:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

to_upper() {
    local uc=$(echo $1 |tr '[:lower:]' '[:upper:]')
    echo "$uc"
}
