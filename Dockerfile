FROM library/centos:7

# Change default timezone
RUN ln -snf "/usr/share/zoneinfo/Asia/Shanghai" /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

RUN  set -xeu \
  # install commonly needed packages
  && yum install -y \
      net-tools \
      telnet \
      sudo \
      vi \
      less \
  # install epel-release
  && yum install -y epel-release \
  # install supervisor
  && yum install -y supervisor \
  # cleanup
  && yum -y autoremove && yum -y clean all && rm -rf /tmp/* /var/tmp/*