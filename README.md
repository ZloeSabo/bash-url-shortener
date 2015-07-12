# bash-url-shortener
Why not use bash?

### Run
To run this you need to install socat. Then:

    socat TCP4-LISTEN:8080,fork EXEC:"bash ./server"

### Add url
To add url you need to pass json like that:
    curl -H "Content-Type: application/json" -X POST -d '{"url":"http://google.com"}' server:port

The output will be
    {"url":"://server:port/code"}

### Use redirecting
Just open url in your browser
