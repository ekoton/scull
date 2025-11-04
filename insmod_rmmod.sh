#!/bin/bash
#$1: "insmod/rmmod" for printing some info, if there is no parameter, this run as non debug mode.
#$2: "debug" for printing some info, if there is no parameter, this run as non debug mode.

set -Eeuo pipefail
trap 'echo "ERROR: $BASH_COMMAND exited with $?"' ERR

debugMode=0
if [ -n "${2:-}" ]; then
    if [ "$2" = "debug" ]; then
        debugMode=1
    fi
fi

sculldir="/home/so/git/scull/scull"
cd $sculldir

if [ $1 = "insmod" ]; then

    sudo insmod ${sculldir}/scull.ko

    datestr=$(date '+%Y-%m-%dT%H:%M:%S+09:00')

    start=$(date '+%Y-%m-%dT%H:%M:%S+09:00' -d "${datestr} - 30sec")

    end=$(date '+%Y-%m-%dT%H:%M:%S+09:00' -d "${datestr} 30sec")

    if [ "${debug:-}" = 1 ]; then
        echo "[debug] datestr: ${datestr}, start: ${start}, end: ${end}"
    fi

    if [ "${debug:-}" = 1 ]; then
        echo "[debug] entire line of /var/log/kern.log written with major number: $(awk -F' ' -v start="$start" -v end="$end" '$1 >= start && $1 <= end && $0 ~ /dynamically allocated major number is/ {print}' /var/log/kern.log)"
    fi

    major_number=`awk -F' ' -v start="$start" -v end="$end" '$1 >= start && $1 <= end && $0 ~ /dynamically allocated major number is/ {print $10}' /var/log/kern.log`

    sudo mknod /dev/scull0 c "$major_number" 0
    sudo mknod /dev/scull1 c "$major_number" 1
    sudo mknod /dev/scull2 c "$major_number" 2
    sudo mknod /dev/scull3 c "$major_number" 3
    sudo chmod 666 /dev/scull*
    ls -l /dev/scull*

elif [ "${1:-}" = "rmmod" ]; then
    sudo rmmod scull
    sudo rm -i /dev/scull*
fi
