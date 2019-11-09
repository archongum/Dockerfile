#!/bin/bash -l

if [ "$1" = 'spark-master' ]; then
    spark-master.sh
elif [ "$1" = 'spark-worker' ]; then
    spark-worker.sh
else
    exec "$@"
fi
