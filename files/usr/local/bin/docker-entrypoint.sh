#!/bin/bash -l

if [ "$1" = 'supervisord' ]; then
    # make file system hostname resolvable
    if [ ! "$(grep "hadoop-master" /etc/hosts)" ]; then 
        echo "127.0.0.1 hadoop-master" >> /etc/hosts
    fi
    # init hdfs if dir not exists or is empty
    if [ ! -d /hadoop/hdfs ] || [ ! "$(ls -A /hadoop/hdfs)" ]; then
        # in case /hadoop/hdfs has been delete
        mkdir -p /hadoop/hdfs && chown hdfs:hdfs /hadoop/hdfs

        # hdfs namenode -format
        su -c "echo 'N' | hdfs namenode -format" hdfs

        # start hdfs
        su -c "hdfs namenode  2>&1 > /var/log/hadoop-hdfs/hadoop-hdfs-namenode.log" hdfs &

        # wait for process starting
        sleep 15s

        # chmod hdfs /
        su -s /bin/bash hdfs -c 'hdfs dfs -mkdir -p /tmp /user'
        su -s /bin/bash hdfs -c 'hdfs dfs -chmod 777 / /tmp /user'
        # init hive directories, presto need it
        su -s /bin/bash hdfs -c 'hdfs dfs -mkdir -p /user/hive/warehouse'
        su -s /bin/bash hdfs -c 'hdfs dfs -chmod 1777 /user/hive/warehouse'
        su -s /bin/bash hdfs -c 'hdfs dfs -chown hive /user/hive/warehouse'

        # stop hdfs
        killall java
    fi

    # init HMS(mysql) if dir not exists or is empty
    if [ ! -d /var/lib/mysql ] || [ ! "$(ls -A /var/lib/mysql)" ]; then
        # in case /var/lib/mysql has been delete
        mkdir -p /var/lib/mysql && chown mysql:mysql /var/lib/mysql

        # setup metastore
        mysql_install_db
        # due to `mysql_install_db` is executed by root, change the owner of mysql's data directories to mysql
        chown -R mysql:mysql /var/lib/mysql

        # start mysql
        mysqld_safe &

        # wait for process starting
        sleep 15s

        # change some privileges
        echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql
        echo "CREATE DATABASE metastore;" | mysql
        mysqladmin -u root password 'root'

        # init HMS
        $HIVE_HOME/bin/schematool -dbType mysql -initSchema

        # stop mysql and wait
        killall mysqld
        sleep 15s
    fi
fi

exec "$@"