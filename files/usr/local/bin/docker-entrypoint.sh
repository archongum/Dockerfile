#!/bin/bash

if [ "$1" = 'run-presto' ]; then
    set -xeuo pipefail

    # if not initiated
    if [[ ! -d /usr/lib/presto/etc ]]; then
        # if /etc/presto is empty, copy default etc
        if [[ ! "$(ls -A /etc/presto)" ]]; then
            cp -r /usr/lib/presto/default/etc/* /etc/presto
        fi
        ln -s /etc/presto /usr/lib/presto/etc
    fi

    set +e
    grep -s -q 'node.id' /usr/lib/presto/etc/node.properties
    NODE_ID_EXISTS=$?
    set -e

    NODE_ID=""
    if [[ ${NODE_ID_EXISTS} != 0 ]] ; then
        NODE_ID="-Dnode.id=${HOSTNAME}"
    fi

    exec /usr/lib/presto/bin/launcher run ${NODE_ID} "${@:2}"
else
    exec "$@"
fi
