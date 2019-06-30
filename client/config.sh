#!/bin/sh

# This file contains all configurable options used
# by the different scripts.
#
# Author: Sean Critica <sean.critica@toptal.com>

ACTIVE_FLAG="/var/run/monitoring_enabled"

SCRIPT_MAC="$SCRIPT_BASE_DIR/mac_address_monitor.sh"
SCRIPT_CONNTRACK="$SCRIPT_BASE_DIR/conntrack_monitor.sh"
SCRIPT_COMMUNICATOR="$SCRIPT_BASE_DIR/monitor_communicator.sh"

PID_FILE_MAC="/var/run/mac_monitor.pid"
PID_FILE_CONNTRACK="/var/run/conntrack_monitor.pid"

FIFO_MAC="/var/run/mac_monitor.fifo"
FIFO_CONNTRACK="/var/run/conntrack_monitor.fifo"

FEED_MAC="/var/run/mac_monitor.feed"
FEED_CONNTRACK="/var/run/contrack_monitor.feed"

# Variables that control forwarding data to the server
UUID="<unset>"
READ_TIMEOUT=1
SEND_INTERVAL=0.5

POST_IP=172.16.2.1
POST_URL="http://$POST_IP:9876/upload"

DEBUG_LOG="/dev/null"

