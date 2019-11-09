FROM dockergum/hive:3.1.2-oj8-base

# add users
RUN  useradd --create-home --shell /bin/bash --uid 1000 hadoop \
  && useradd --create-home --shell /bin/bash --uid 1001 hdfs \
  && useradd --create-home --shell /bin/bash --uid 1002 hive \
  && useradd --create-home --shell /bin/bash --uid 1003 yarn 

# setup sock proxy
# install psmisc for killall command
RUN  yum install -y openssh openssh-clients openssh-server psmisc \
  && yum -y autoremove && yum -y clean all && rm -rf /tmp/* /var/tmp/*
RUN  ssh-keygen -t rsa -b 4096 -C "qq349074225@live.com" -N "" -f /root/.ssh/id_rsa \
  && ssh-keygen -t rsa -b 4096 -N "" -f /etc/ssh/ssh_host_rsa_key \
  && ssh-keygen -t dsa -b 1024 -N "" -f /etc/ssh/ssh_host_dsa_key \
  && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN  chmod 755 /root && chmod 700 /root/.ssh \
  && passwd --unlock root

# cleanup and copy files
RUN  rm -rf \
  /etc/hadoop \
  /etc/hive \
  /etc/supervisor \
  /etc/tez
COPY ./files /

RUN \
  # hdfs
  mkdir -p /hadoop/hdfs && chown hdfs:hdfs /hadoop/hdfs \
  # mysql
  && mkdir -p /var/lib/mysql /var/log/mysql/ && chown mysql:mysql /var/lib/mysql /var/log/mysql/ \
  # supervisor
  && mkdir /var/log/hadoop-hdfs && chown hdfs:hdfs /var/log/hadoop-hdfs \
  && mkdir /var/log/hive        && chown hive:hive /var/log/hive \
  && mkdir /var/log/hadoop-yarn && chown yarn:yarn /var/log/hadoop-yarn \
  && chmod 770 /var/log/hadoop-hdfs /var/log/hive /var/log/hadoop-yarn

EXPOSE \
# HDFS ports
9870 9864 \
# YARN ports
8088 \
# HIVE ports
9083 \
# SOCKS port
1180

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisord.conf"]