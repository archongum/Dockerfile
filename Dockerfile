FROM dockergum/centos:oj11

# use -l/--login flag to source /etc/profile
SHELL ["/bin/bash", "-c", "-l"]

# set version and variables
RUN  echo $'' >> /etc/profile \
  && echo $'# zeppelin' >> /etc/profile \
  && echo $'export ZEPPELIN_VERSION=0.8.2' >> /etc/profile \
  && echo $'export ZEPPELIN_HOME=/opt/zeppelin-${ZEPPELIN_VERSION}' >> /etc/profile \
  && echo $'export ZEPPELIN_CONF_DIR=/etc/zeppelin' >> /etc/profile \
  && echo $'export PATH=${ZEPPELIN_HOME}/bin:$PATH' >> /etc/profile

RUN  curl -fSL https://archive.apache.org/dist/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-netinst.tgz -o /tmp/zeppelin.tar.gz \
  # untar
  && mkdir -p ${ZEPPELIN_HOME} \
  && tar -xzf /tmp/zeppelin.tar.gz --strip-components=1 -C ${ZEPPELIN_HOME} \
  # conf
  && mv ${ZEPPELIN_HOME}/conf ${ZEPPELIN_CONF_DIR} && ln -s ${ZEPPELIN_CONF_DIR} ${ZEPPELIN_HOME}/conf \
  # delete spark interpreter
  && rm -rf ${ZEPPELIN_HOME}/interpreter/spark \
  # add jdbc interpreter
  && ${ZEPPELIN_HOME}/bin/install-interpreter.sh --name jdbc \
  && rm -rf ${ZEPPELIN_HOME}/local-repo \
  # cleanup
  && rm -rf /tmp/* /var/tmp/*