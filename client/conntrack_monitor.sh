#!/bin/sh

# Connection tracking events monitor runner.
#
# This script will start and continuously restart
# the connection tracking event monitoring until
# instructed to stop.
#
# Author: Sean Critica <sean.critica@toptal.com>


# Import config
. ./config.sh


# Define globals
#MONITOR_CMD="conntrack -E -e NEW -e DESTROY -o extended"
MONITOR_CMD="conntrack -E -o extended"


process_monitor_line()
{
    for tok in $@
    do
        if [ "$tok" == "dst=$POST_IP" ]; then
            return
        fi
    done
    echo "CON $*" >> $FEED_CONNTRACK
}


# Import utilities
. ./common_utils.sh


main()
{
    echo "Starting connection tracking event monitoring..." >&2

    create_fifo $FIFO_CONNTRACK
    autorestart_monitor $ACTIVE_FLAG $PID_FILE_CONNTRACK "$MONITOR_CMD" $FIFO_CONNTRACK
    destroy_fifo $FIFO_CONNTRACK

    echo "Connection tracking event monitoring stopped." >&2
}


main

