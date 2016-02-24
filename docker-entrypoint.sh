#!/bin/bash
set -e

#function prep_backup {
  #umask u=rwx,g=rx,o=
  #mkdir -p /etc/wal-e.d/env
  #echo "$S3_BACKUP_SECRET" > /etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY
  #echo "$S3_BACKUP_KEY" > /etc/wal-e.d/env/AWS_ACCESS_KEY_ID
  #echo "$S3_BACKUP_DIR" > /etc/wal-e.d/env/WALE_S3_PREFIX
  #echo "stderr" > /etc/wal-e.d/env/WALE_LOG_DESTINATION
  #chown -R root:postgres /etc/wal-e.d
#}

if [ "$1" = 'postgres' ]; then
  chown -R postgres "$PGDATA"

  # first run
  if [ -z "$(ls -A "$PGDATA")" ]; then
    gosu postgres initdb
    
    sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf
    { echo; echo 'host all all 0.0.0.0/0 md5'; } >> "$PGDATA"/pg_hba.conf

    #if [ -n "$S3_BACKUP_DIR" ]; then 
      #prep_backup
      #{ echo; echo "wal_level = archive"; } >> "$PGDATA"/postgresql.conf
      #{ echo; echo "archive_mode = on"; } >> "$PGDATA"/postgresql.conf
      #{ echo; echo "archive_command = 'envdir /etc/wal-e.d/env /usr/local/bin/wal-e --terse wal-push %p'"; } >> "$PGDATA"/postgresql.conf
      #{ echo; echo "archive_timeout = 60"; } >> "$PGDATA"/postgresql.conf
    #fi

    gosu postgres pg_ctl -w start 

    if [ -n "$POSTGRES_PASSWORD" ]; then 
      gosu postgres psql -q <<-EOF
CREATE USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD'; 
ALTER USER postgres WITH PASSWORD '$POSTGRES_PASSWORD';
EOF
    fi

    if [ -n "$POSTGRES_DB" ]; then 
      gosu postgres createdb -O $POSTGRES_USER $POSTGRES_DB
    fi

    #if [ -n "$S3_BACKUP_DIR" ]; then 
      #gosu postgres envdir /etc/wal-e.d/env /usr/local/bin/wal-e backup-push "$PGDATA"
    #fi

    gosu postgres pg_ctl stop 
  fi

  #if [ -n "$S3_BACKUP_DIR" ]; then 
    #prep_backup
  #fi

  if [ -d /docker-entrypoint-initdb.d ]; then
    for f in /docker-entrypoint-initdb.d/*.sh; do
      [ -f "$f" ] && . "$f"
    done
  fi

  exec gosu postgres "$@"
fi

exec "$@"
