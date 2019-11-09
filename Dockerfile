FROM dockergum/centos:oj8

# use -l/--login flag to source /etc/profile
SHELL ["/bin/bash", "-c", "-l"]

# set version and variables
RUN  echo $'' >> /etc/profile \
  && echo $'# hadoop' >> /etc/profile \
  && echo $'export HADOOP_VERSION=3.1.2' >> /etc/profile \
  && echo $'export HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}' >> /etc/profile \
  && echo $'export HADOOP_CONF_DIR=/etc/hadoop' >> /etc/profile \
  && echo $'export PATH=${HADOOP_HOME}/bin/:$PATH' >> /etc/profile

# install hadoop
RUN  curl -fSL https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -o /tmp/hadoop.tar.gz \
  # untar
  && mkdir -p ${HADOOP_HOME} \
  && tar -xzf /tmp/hadoop.tar.gz --strip-components=1 -C ${HADOOP_HOME} \
  ## conf
  && mv ${HADOOP_HOME}/etc/hadoop ${HADOOP_CONF_DIR} \
  && ln -s ${HADOOP_CONF_DIR} ${HADOOP_HOME}/etc/hadoop \
  ## cleanup
  && rm -rf /tmp/* /var/tmp/*