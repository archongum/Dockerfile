FROM dockergum/spark:2.4.4-oj8-livy-base

RUN  useradd --create-home --shell /bin/bash --uid 1004 spark \
  && useradd --create-home --shell /bin/bash --uid 1005 livy

# cleanup and copy files
RUN  rm -rf \
  /etc/spark \
  /etc/livy
COPY ./files /

RUN \
  # SPARK_WORKER_DIR
  mkdir /spark-work && chown spark:spark /spark-work \
  # spark.eventLog.dir
  && mkdir /tmp/spark-events && chmod 777 /tmp/spark-events \
  # LIVY_LOG_DIR
  && mkdir /livy-logs  && chown livy:livy /livy-logs \
  # supervisor
  && mkdir /var/log/spark && chown spark:spark /var/log/spark \
  && mkdir /var/log/livy  && chown livy:livy   /var/log/livy

EXPOSE \
# spark ports
8080 8081 7077 \
# livy ports
8998

RUN chmod +x /usr/local/bin/*

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisord.conf"]