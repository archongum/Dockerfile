FROM dockergum/centos:7

RUN  set -xeu \
  # install Java
  && yum install -y java-1.8.0-openjdk-devel \
  # cleanup
  && yum -y autoremove && yum -y clean all && rm -rf /tmp/* /var/tmp/*

RUN  echo $'' >> /etc/profile \
  && echo $'# java' >> /etc/profile \
  && echo $'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk' >> /etc/profile