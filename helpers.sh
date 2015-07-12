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

#see https://gist.github.com/cjus/1047794
function get_json_val () {
    local value=$(echo $2 | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $1)
    echo ${value##*|}
}

do_locked() {
    #ITS A TRAP
    trap "rm -rf '$LOCKFILE'" 0 2 3 15

    lockfile -l1 $LOCKFILE && \
        "$@"
}
