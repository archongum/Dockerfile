FROM dockergum/centos:oj11

ENV PRESTO_VERSION 324

RUN  curl -fSL https://repo1.maven.org/maven2/io/prestosql/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz -o /tmp/presto.tar.gz \
  # untar
  && mkdir /usr/lib/presto \
  && tar -xzf /tmp/presto.tar.gz --strip-components=1 -C /usr/lib/presto \
  # delete un-use connectors
  && cd /usr/lib/presto/plugin \
  && rm -rf \
    accumulo \
    blackhole \
    cassandra \
    example-http \
    geospatial \
    google-sheets \
    kafka \
    localfile \
    memory \
    ml \
    mongodb \
    phoenix \
    postgresql \
    presto-elasticsearch \
    presto-iceberg \
    presto-kinesis \
    presto-thrift \
    raptor \
    redis \
    redshift \
    sqlserver \
    tpcds \
  && rm -rf /tmp/* /var/tmp/*

COPY ./files /

# backup default etc due to if using --volume flag would override it
RUN mkdir -p /usr/lib/presto/default && cp -r /etc/presto /usr/lib/presto/default/etc

EXPOSE 8080

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["run-presto"]