docker-postgres
===============

Docker image for Postgresql 9.3 on Debian stable, including PostGIS 2.1.4. 

Data will be stored under a volume called `/data` in the container, make sure that this volume is linked to the host when running the container if you want the data to be persistent, e.g. `-v /whatever/on/host:/data`.

When the database is first run, a superuser and a password will be created if `POSTGRES_USER` and `POSTGRES_PASSWORD` environment variables are set, and a database will also be created if `POSTGRES_DB` environment variable is set. 

This image also does continuous archiving to AWS S3 using WAL-e, if the following environment variables are set: `S3_BACKUP_DIR`, `S3_BACKUP_KEY`, and `S3_BACKUP_SECRET`. (Note: to enable logging for Wal-e, link the host volume by specifying `-v /dev/log:/dev/log`) 
