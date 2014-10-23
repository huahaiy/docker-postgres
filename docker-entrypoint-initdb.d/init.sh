#!/bin/bash
set -e

gosu postgres pg_ctl -w start 
gosu postgres psql -q <<-EOF
  CREATE USER $POSTGRES_USER WITH SUPERUSER PASSWORD '$POSTGRES_PASSWORD'; 
  ALTER USER postgres WITH PASSWORD '$POSTGRES_PASSWORD';
EOF
gosu postgres createdb -O $POSTGRES_USER $POSTGRES_DB
gosu postgres pg_ctl stop 
