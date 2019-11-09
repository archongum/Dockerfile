#!/bin/bash

. "${SPARK_HOME}/sbin/spark-config.sh"
. "${SPARK_HOME}/bin/load-spark-env.sh"

HOSTNAME=$(cat /proc/sys/kernel/hostname)
SPARK_MASTER=${SPARK_MASTER:-spark://${HOSTNAME}:7077}

spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port $SPARK_WORKER_WEBUI_PORT \
    $SPARK_MASTER