#!/bin/sh

# Management script for monitoring tools.
#
# This script allows starting and stopping the 
# various monitoring scripts.
#
# Author: Sean Critica <sean.critica@toptal.com>


# Define globals
ACTIVE_FLAG="/var/run/monitoring_enabled"

SCRIPT_CONNTRACK="./conntrack_monitor.sh"
PID_FILE_CONNTRACK="/var/run/conntrack_monitor.pid"

SCRIPT_MAC="./mac_address_monitor.sh"
PID_FILE_MAC="/var/run/mac_monitor.pid"

TEST_FILE=/tmp/monitor_debug.out


set_active_flag()
{
    touch $ACTIVE_FLAG
}

unset_active_flag()
{
    rm -f $ACTIVE_FLAG
}

start_script()
{
    nohup $1 >> $TEST_FILE 2>/dev/null &
}

stop_pid()
{
    local target=$(cat $1)
    if [ -z "$target" ]; then
        echo -n
    else
        kill -9 $target
    fi
}

startup()
{
    set_active_flag
    start_script $SCRIPT_CONNTRACK
    start_script $SCRIPT_MAC
}

shutdown()
{
    unset_active_flag
    stop_pid $PID_FILE_CONNTRACK
    stop_pid $PID_FILE_MAC
}

main()
{
    case "$1" in
        start)
            startup
            ;;
        stop)
            shutdown
            ;;
        restart)
            startup
            shutdown
            ;;
        *)
            echo "Command not specified."
    esac
}


main $*

