#!/bin/bash

function getIp() {
    URLS=("http://myexternalip.com/raw" "http://wtfismyip.com/text" "http://ipecho.net/plain")
    for URL in ${URLS[*]}; do
        MYIP=$(wget -O- -q $URL)
        if [[ ! -z "$MYIP" ]]; then
            # echo "got ip from $URL"
            echo $MYIP
            return
        fi
    done
}

while true; do
    MYIP=$(getIp)
    echo $MYIP | curl --data-binary @- http://post.paukl.at/post/myIp
    sleep 300
done
