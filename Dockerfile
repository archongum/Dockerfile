FROM dockergum/spark:2.4.4-oj8-base

# set version and variables
RUN  echo $'' >> /etc/profile \
  && echo $'# livy' >> /etc/profile \
  && echo $'export LIVY_VERSION=0.6.0-incubating' >> /etc/profile \
  && echo $'export LIVY_HOME=/opt/livy-${LIVY_VERSION}' >> /etc/profile \
  && echo $'export LIVY_CONF_DIR=/etc/livy' >> /etc/profile \
  && echo $'export PATH=${LIVY_HOME}/bin/:$PATH' >> /etc/profile

# install livy
RUN  curl -fSL https://archive.apache.org/dist/incubator/livy/${LIVY_VERSION}/apache-livy-${LIVY_VERSION}-bin.zip -o /tmp/livy.zip \
  && yum install -y unzip \ 
  # unzip
  && mkdir -p ${LIVY_HOME} \
  && unzip -d ${LIVY_HOME} /tmp/livy.zip && f=(${LIVY_HOME}/*) && mv ${LIVY_HOME}/*/* ${LIVY_HOME} && rmdir "${f[@]}" \
  # conf
  && mv ${LIVY_HOME}/conf ${LIVY_CONF_DIR} \
  && ln -s ${LIVY_CONF_DIR} ${LIVY_HOME}/conf \
  # By default, livy doesn't include scala api jar and need to add manually. 
  # Therefore pre-downloaded it here so that no need to add manually.
  && curl -fSL http://repo1.maven.org/maven2/org/apache/livy/livy-scala-api_2.11/0.6.0-incubating/livy-scala-api_2.11-0.6.0-incubating.jar -o ${LIVY_HOME}/repl_2.11-jars/livy-scala-api_2.11-0.6.0-incubating.jar \
  # cleanup
  && yum -y remove unzip \
  && yum -y autoremove && yum -y clean all && rm -rf /tmp/* /var/tmp/*