#!/bin/bash

set -e

sleep 1

if [ "$1" = 'jsc' ]; then
    exec rlwrap bin/jsc
fi

if [ "$1" = 'gdb' ]; then
    exec rlwrap gdb bin/jsc
fi

if [[ -z $1 ]] || [[ ${1:0:1} == '-' ]] ; then
  exec rlwrap bin/jsc "$@"
fi

exec "$@"