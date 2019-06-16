#!/bin/bash
set -e

if [ "$1" = 'jsc' ]; then
    exec rlwrap bin/jsc
fi

if [[ -z $1 ]] || [[ ${1:0:1} == '-' ]] ; then
  exec rlwrap bin/jsc "$@"
fi

exec "$@"