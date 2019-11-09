# This file is sourced when running various Spark programs.
# Copy it as spark-env.sh and edit that to configure Spark for your site.

# Options for the daemons used in the standalone deploy mode
# Memory to allocate to the Spark master and worker daemons themselves (default: 1g).
SPARK_MASTER_PORT=7077
SPARK_MASTER_WEBUI_PORT=8080
SPARK_WORKER_WEBUI_PORT=8081
SPARK_DAEMON_MEMORY=256m
# Total number of cores to allow Spark applications to use on the machine 
# (default: all available cores).
# SPARK_WORKER_CORES
# Total amount of memory to allow Spark applications to use on the machine, e.g. 1000m, 2g 
# (default: total memory minus 1 GB); 
# note that each application's individual memory is configured using its `spark.executor.memory` property.
SPARK_WORKER_MEMORY=2g
# Directory to run applications in, which will include both logs and scratch space (default: SPARK_HOME/work).
SPARK_WORKER_DIR=/spark-work


# Generic options for the daemons used in the standalone deploy mode
# - SPARK_CONF_DIR      Alternate conf dir. (Default: ${SPARK_HOME}/conf)
# - SPARK_LOG_DIR       Where log files are stored.  (Default: ${SPARK_HOME}/logs)
# - SPARK_PID_DIR       Where the pid file is stored. (Default: /tmp)
# - SPARK_IDENT_STRING  A string representing this instance of spark. (Default: $USER)
# - SPARK_NICENESS      The scheduling priority for daemons. (Default: 0)
# - SPARK_NO_DAEMONIZE  Run the proposed command in the foreground. It will not output a PID file.
# Options for native BLAS, like Intel MKL, OpenBLAS, and so on.
# You might get better performance to enable these options if using native BLAS (see SPARK-21305).
# - MKL_NUM_THREADS=1        Disable multi-threading of Intel MKL
# - OPENBLAS_NUM_THREADS=1   Disable multi-threading of OpenBLAS