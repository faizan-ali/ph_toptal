#!/bin/sh

# Monitor traffic forwarder.
#
# This script is responsible for forwarding collected
# monitoring data to the target remote server.
# It communicates with the remote server via HTTP.
#
# Author: Sean Critica <sean.critica@toptal.com>


# Import config
. ./config.sh


# Define globals
POST_DATA=""
CURL_COMMAND='/usr/bin/curl -f -H PHN-id:'$UUID' -H Content-Type:text/plain --data-binary'


open_feeds()
{
    exec 11<$FEED_MAC
    exec 12<$FEED_CONNTRACK
}


close_feeds()
{
    exec 11<&-
    exec 12<&-
}


collect_data_from_feed()
{
    if read -rt 0 <&$1; then
        local line=''

        read -r -t $READ_TIMEOUT line <&$1
        if [ ! -z "$POST_DATA" ]; then
            POST_DATA=$POST_DATA$'\n'$line
        else
            POST_DATA=$line
        fi

        while [ ! -z "$line" ]
        do
            read -r -t $READ_TIMEOUT line <&$1
            POST_DATA=$POST_DATA$'\n'$line
            line=''
        done
   fi
}


collect_data()
{
    POST_DATA=''
    collect_data_from_feed 11
    collect_data_from_feed 12
}


send_data()
{
    if [ ! -z "$POST_DATA" ]; then
        $CURL_COMMAND "$POST_DATA" $POST_URL
    fi
}


main()
{
    echo "Starting traffic forwarder." >&2

    open_feeds

    while test -e "$ACTIVE_FLAG"
    do
        collect_data
        send_data
        sleep $SEND_INTERVAL
    done

    close_feeds

    echo "Traffic forwarder stopped." >&2
}


main

