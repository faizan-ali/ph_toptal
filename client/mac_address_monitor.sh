#!/bin/sh

# MAC address and hostname monitor runner.
#
# This script will start and continuously restart
# the MAC address and hostname monitoring until
# instructed to stop.
#
# Author: Sean Critica <sean.critica@toptal.com>


# Import config
. $SCRIPT_BASE_DIR/config.sh


# Define globals
MONITOR_CMD="ip monitor neigh dev br-lan"
DNS_CMD="nslookup"


process_monitor_line()
{
    local ipaddr=$1
    eval state=\${$#}
    eval mac=\${$(($# - 1))}

    if [ "$state" = "REACHABLE" ]; then
        local hostname="unk"
        local line="$($DNS_CMD $1 2>&1 | /bin/grep name)"

        if [ -z $(echo "$line" | /bin/sed "/name = /d") ]; then
            hostname="${line##* }"
        fi

        echo "MAC $ipaddr $mac $hostname" >> $FEED_MAC
    fi
}


# Import libraries
. $SCRIPT_BASE_DIR/common_utils.sh


main()
{
    echo "Starting MAC and hostname monitoring..." >&2

    create_fifo $FIFO_MAC
    autorestart_monitor $ACTIVE_FLAG $PID_FILE_MAC "$MONITOR_CMD" $FIFO_MAC
    destroy_fifo $FIFO_MAC

    echo "MAC and hostname monitoring stopped." >&2
}


main

