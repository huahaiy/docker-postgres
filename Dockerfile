#
# Postgres 11
# 
#
# Version     0.10
#

FROM huahaiy/debian

ENV LANG en_US.utf8

RUN \
  echo "===> add user and group to make sure their IDs get assigned consistently" && \
  groupadd -r postgres && useradd -r -g postgres postgres && \
  \
  \
  echo "===> grab gosu for easy step-down from root" && \
  apt-get update && \ 
  wget -O /usr/local/bin/gosu \
    https://github.com/tianon/gosu/releases/download/1.1/gosu  && \
  chmod +x /usr/local/bin/gosu && \
  \
  \
  echo "make en_US.UTF-8 locale so postgres will be utf-8 enabled by default" && \ 
  apt-get  -y --no-install-recommends install gpg locales && \ 
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8  && \
  \
  \
  echo "===> install postgres" && \
  apt-get -y --no-install-recommends install postgresql && \
  #echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | tee \ 
    #/etc/apt/sources.list.d/stretch-pgdg.list  && \ 
  #wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    #apt-key add - && \ 
  #apt-get update && \ 
  #apt-get -y --no-install-recommends install postgresql-common && \
  #sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf && \
  #apt-get -y --no-install-recommends install postgresql-9.6 && \
  \
  \
  #echo "===> install wal-e" && \
  #apt-get install -y libxml2-dev libxslt1-dev python-dev libevent-dev libffi-dev daemontools python-pip lzop pv && \
  #pip install wal-e &&\
  \
  \
  echo "===> clean up" && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  \
  \
  echo "===> setup" 
  
RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

ENV PATH /usr/lib/postgresql/11/bin:$PATH

ENV PGDATA /data

VOLUME ["/data", "/var/log/postgresql", "/etc/postgresql", "/dev/log"]

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432

CMD ["postgres"]
