#!/bin/bash

. "${SPARK_HOME}/sbin/spark-config.sh"
. "${SPARK_HOME}/bin/load-spark-env.sh"

HOSTNAME=$(cat /proc/sys/kernel/hostname)
SPARK_MASTER_HOST=${SPARK_MASTER_HOST:-${HOSTNAME}}

spark-class org.apache.spark.deploy.master.Master \
    --host ${SPARK_MASTER_HOST} \
    --port ${SPARK_MASTER_PORT} \
    --webui-port ${SPARK_MASTER_WEBUI_PORT}