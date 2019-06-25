#!/bin/sh

# MAC address and hostname monitor runner.
#
# This script will start and continuously restart
# the MAC address and hostname monitoring until
# instructed to stop.
#
# Author: Sean Critica <sean.critica@toptal.com>


# Define globals
MONITOR_CMD="ip monitor neigh dev br-lan"
DNS_CMD="nslookup"
ACTIVE_FLAG="/var/run/monitoring_enabled"
PID_FILE="/var/run/mac_monitor.pid"
FIFO="/var/run/mac_monitor.fifo"


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

        echo "MAC $ipaddr $mac $hostname"
    fi
}


# Import libraries
. ./common_utils.sh


main()
{
    echo "Starting MAC and hostname monitoring..." >&2

    create_fifo $FIFO
    autorestart_monitor $ACTIVE_FLAG $PID_FILE "$MONITOR_CMD" $FIFO
    destroy_fifo $FIFO

    echo "MAC and hostname monitoring stopped." >&2
}


main

