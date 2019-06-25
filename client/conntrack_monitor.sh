#!/bin/sh

# Connection tracking events monitor runner.
#
# This script will start and continuously restart
# the connection tracking event monitoring until
# instructed to stop.
#
# Author: Sean Critica <sean.critica@toptal.com>


# Define globals
MONITOR_CMD="conntrack -E -o extended"
ACTIVE_FLAG="/var/run/monitoring_enabled"
PID_FILE="/var/run/conntrack_monitor.pid"
FIFO="/var/run/conntrack_monitor.fifo"


process_monitor_line()
{
    echo "CON $*"
}


# Import utilities
. ./common_utils.sh


main()
{
    echo "Starting connection tracking event monitoring..." >&2

    create_fifo $FIFO
    autorestart_monitor $ACTIVE_FLAG $PID_FILE "$MONITOR_CMD" $FIFO
    destroy_fifo $FIFO

    echo "Connection tracking event monitoring stopped." >&2
}


main

