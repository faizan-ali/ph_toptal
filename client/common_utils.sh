# Common utility functions for shell scripts.
#
# This script contains a library of reusable functions
# for other scripts to use.
#
# Author: Sean Critica <sean.critica@toptal.com>


# Args:
# * FILE - filename of fifo to create
#
# Create a FIFO file in the given location.
# If the file already exists, it is deleted first.
create_fifo()
{
    if test -e "$1"; then
        rm -f $1
    fi
    mkfifo $1
}


# Args:
# * FILE - filename of fifo to remove
#
# Remove a FIFO file in the given location
destroy_fifo()
{
    rm -f $1
}


# Args:
# * PID  - pid value to write to file
# * FILE - filename to save into
#
# Save PID to the given file
save_pid()
{
    echo $1 > $2
}


# Args:
# * DATA - file to process line-by-line, usually a fifo
#
# This function reads the given data file and sends each
# line for processing to a function ``process_monitor_line``.
# The function must exist.
process_monitor_output()
{
    local data=$1

    while read -r line
    do
        process_monitor_line $line
    done < $data
}

# Args:
# * FLAG - regular file, if exists run CMD
# * PID  - filename for storing pid of CMD
# * CMD  - command to execute, outputs line-by-line
#          to stdout
# * DATA - file to send CMD output to, usually a fifo
#
# This function executes CMD and redirects its stdout
# to DATA. It then calls process_monitor_output to
# process DATA line-by-line.
autorestart_monitor()
{
    local test_file=$1
    local pid_file=$2
    local monitor_cmd="$3"
    local data=$4

    while test -e "$test_file"
    do
        echo "Running monitor command." >&2
        $monitor_cmd > $data &
        save_pid $! $pid_file

        echo "Processing output." >&2
        process_monitor_output $data
    done
}


# Args:
# TIME - seconds to sleep, can be fractional
#
# This function exists because busybox only supports
# 1-sec precision sleep. Lua is installed on OpenWRT
# by default.
luasleep()
{
    lua ./sleep.lua $1
}

