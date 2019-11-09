#!/bin/bash

if [ "$1" = 'run-azkaban' ]; then
    set -xeuo pipefail

    # if not initiated
    if [[ ! -d /opt/azkaban-solo-server/conf ]]; then
        # if /etc/azkaban is empty, copy default conf
        if [[ ! "$(ls -A /etc/azkaban)" ]]; then
            cp -r /opt/azkaban-solo-server/default/conf/* /etc/azkaban
        fi
        ln -s /etc/azkaban /opt/azkaban-solo-server/conf
    fi

    cd /opt/azkaban-solo-server
    exec java \
        -Xmx256m \
        -server \
        -Djava.io.tmpdir=/tmp \
        -Dserverpath=/opt/azkaban-solo-server \
        -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 \
        -cp lib/*: \
        azkaban.soloserver.AzkabanSingleServer \
        -conf conf
else
    exec "$@"
fi
