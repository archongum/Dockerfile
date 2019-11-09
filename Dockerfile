FROM dockergum/centos:oj8

# JAVA_HOME in /etc/profile
SHELL ["/bin/bash", "-c", "-l"]

ENV AZKABAN_VERSION=3.79.0

# install hadoop
RUN  yum install -y git unzip \
  # build
  && git clone --branch ${AZKABAN_VERSION} --depth 1 https://github.com/azkaban/azkaban \
  && cd ./azkaban \
  && ./gradlew distZip \
  # unzip
  && unzip /azkaban/azkaban-solo-server/build/distributions/azkaban-solo-server-${AZKABAN_VERSION}.zip -d /opt \
  && mv /opt/azkaban-solo-server-${AZKABAN_VERSION} /opt/azkaban-solo-server \
  # cleanup
  && rm -rf /root/.gradle /root/.m2 /azkaban \
  && yum autoremove -y git unzip \
  && yum -y autoremove && yum -y clean all && rm -rf /tmp/* /var/tmp/*

COPY ./files /

RUN  \
  # remove default conf
  rm -rf /opt/azkaban-solo-server/conf \
  # backup default etc due to if using --volume flag would override it
  && mkdir -p /opt/azkaban-solo-server/default \
  && cp -r /etc/azkaban /opt/azkaban-solo-server/default/conf

EXPOSE 8081

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["run-azkaban"]