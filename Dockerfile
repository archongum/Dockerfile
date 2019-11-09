FROM dockergum/hadoop:3.1.2-oj8-base

# set version and variables
RUN  echo $'' >> /etc/profile \
  && echo $'# hive' >> /etc/profile \
  && echo $'export HIVE_VERSION=3.1.2' >> /etc/profile \
  && echo $'export HIVE_HOME=/opt/hive-${HIVE_VERSION}' >> /etc/profile \
  && echo $'export HIVE_CONF_DIR=/etc/hive' >> /etc/profile \
  && echo $'export PATH=${HIVE_HOME}/bin:$PATH' >> /etc/profile

# install Hive and HMS
RUN  curl -fSL https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz -o /tmp/hive.tar.gz \
  # untar
  && mkdir -p ${HIVE_HOME} \
  && tar -xzf /tmp/hive.tar.gz --strip-components=1 -C ${HIVE_HOME} \
  ## conf
  && mv ${HIVE_HOME}/conf ${HIVE_CONF_DIR} \
  && ln -s ${HIVE_CONF_DIR} ${HIVE_HOME}/conf \
  # cleanup
  && rm -rf /tmp/* /var/tmp/*

# Mysql is not present in Centos7 repositories, use mariadb as a replacement
# mariadb-server installs resolveip in /usr/bin but mysql_install_db expects it in /usr/libexec
# `hive` needs `which`
RUN  curl -fSL http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.48/mysql-connector-java-5.1.48.jar -o ${HIVE_HOME}/lib/mysql-connector-java-5.1.48.jar \
  && yum install -y mariadb-server which \
  && ln -s /usr/bin/resolveip /usr/libexec \
  # cleanup
  && yum -y autoremove && yum -y clean all && rm -rf /tmp/* /var/tmp/* 