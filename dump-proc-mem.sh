#!/usr/bin/env bash
#
# copy&paste ideas from https://serverfault.com/a/408929/371036
#
# to generate core file of process, run:
# $ gcore <pid>
#

usage="usage: `basename $0` <pid>"

die()
{
    echo >&2
    echo "$@" >&2
    echo >&2
    exit 1
}


pid=$1

[ "x${pid}" != "x" ] \
    || die ${usage}

[ -d /proc/${pid} ] \
    || die "pid of \`$pid' does not exist!"

cp /proc/${pid}/maps ${pid}-maps
grep rw-p ${pid}-maps \
    | sed -n 's/^\([0-9a-f]*\)-\([0-9a-f]*\) .*$/\1 \2/p' \
    | while read start stop; do \
    gdb --batch --pid ${pid} \
        -ex "dump memory ${pid}-${start}-${stop}.dump 0x${start} 0x${stop}"; \
done
