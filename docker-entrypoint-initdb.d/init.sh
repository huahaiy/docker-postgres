#!/bin/bash
set -e
gosu postgres pg_ctl -w start 
if [ -z "$(ls -A "$PGDATA")" ]; then
  gosu postgres psql -q <<-EOF
    CREATE USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD'; 
    ALTER USER postgres WITH PASSWORD '$POSTGRES_PASSWORD';
  EOF
  gosu postgres createdb -O $POSTGRES_USER $POSTGRES_DB
fi
if [ -n "$S3_BACKUP_DIR" ]; then 
  gosu postgres envdir /etc/wal-e.d/env /usr/local/bin/wal-e backup-push "$PGDATA"
fi
gosu postgres pg_ctl stop 
