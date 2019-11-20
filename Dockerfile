FROM dockergum/zeppelin:0.8.2-oj11-base

COPY ./files /

# backup default etc due to if using --volume flag would override it
RUN mkdir -p ${ZEPPELIN_HOME}/default && cp -r /etc/zeppelin ${ZEPPELIN_HOME}/default/conf

EXPOSE 8080

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["run-zeppelin"]