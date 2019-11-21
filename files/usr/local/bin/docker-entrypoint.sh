#!/bin/bash -l
if [ "$1" = 'run-zeppelin' ]; then
    set -xeuo pipefail

    # if not initiated
    if [[ ! -d ${ZEPPELIN_HOME}/conf ]]; then
        ln -s /etc/zeppelin ${ZEPPELIN_HOME}/conf
    fi
    # if /etc/presto is empty, copy default etc
    if [[ ! "$(ls -A /etc/zeppelin)" ]]; then
        cp -r ${ZEPPELIN_HOME}/default/conf/* /etc/zeppelin
    fi

    ${ZEPPELIN_HOME}/bin/zeppelin.sh
else
    exec "$@"
fi
