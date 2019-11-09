FROM dockergum/centos:oj8

# use -l/--login flag to source /etc/profile
SHELL ["/bin/bash", "-c", "-l"]

# set version and variables
RUN  echo $'' >> /etc/profile \
  && echo $'# spark' >> /etc/profile \
  && echo $'export SPARK_VERSION=2.4.4' >> /etc/profile \
  && echo $'export SPARK_HOME=/opt/spark-${SPARK_VERSION}-bin-hadoop2.7' >> /etc/profile \
  && echo $'export SPARK_CONF_DIR=/etc/spark' >> /etc/profile \
  && echo $'export PATH=${SPARK_HOME}/bin/:$PATH' >> /etc/profile

# install spark
RUN  curl -fSL https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz -o /tmp/spark.tar.gz \
  # untar
  && mkdir -p ${SPARK_HOME} \
  && tar -xzf /tmp/spark.tar.gz --strip-components=1 -C ${SPARK_HOME} \
  # conf
  && mv ${SPARK_HOME}/conf ${SPARK_CONF_DIR} \
  && ln -s ${SPARK_CONF_DIR} ${SPARK_HOME}/conf \
  # cleanup
  && rm -rf /tmp/* /var/tmp/*

# install some libs, like mysql-jdbc
RUN  curl -fSL http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.48/mysql-connector-java-5.1.48.jar -o ${SPARK_HOME}/jars/mysql-connector-java-5.1.48.jar