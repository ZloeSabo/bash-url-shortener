# bash-url-shortener
Why not use bash?

### Run
To run this you need to install socat. Then:

    socat TCP4-LISTEN:8080,fork EXEC:"bash ./server"
