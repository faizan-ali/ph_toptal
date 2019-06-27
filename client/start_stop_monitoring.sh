#!/bin/sh

# Management script for monitoring tools.
#
# This script allows starting and stopping the 
# various monitoring scripts.
#
# Author: Sean Critica <sean.critica@toptal.com>


# Import config
. ./config.sh


# Import common library
. ./common_utils.sh


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
    nohup $1 >> $2 2>/dev/null &
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
    echo "Enabling active flag."
    set_active_flag

    echo "Creating feeds."
    create_fifo $FEED_CONNTRACK
    create_fifo $FEED_MAC

    echo "Starting monitoring scripts."
    start_script $SCRIPT_CONNTRACK $FEED_CONNTRACK
    start_script $SCRIPT_MAC $FEED_MAC

    echo "Starting communicator."
    start_script $SCRIPT_COMMUNICATOR /tmp/communication.log
}

shutdown()
{
    unset_active_flag

    stop_pid $PID_FILE_CONNTRACK
    stop_pid $PID_FILE_MAC

    destroy_fifo $FEED_CONNTRACK
    destroy_fifo $FEED_MAC
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
            shutdown
            startup
            ;;
        *)
            echo "Command not specified."
    esac
}


main $*

