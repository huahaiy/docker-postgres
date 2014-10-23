docker-postgres
===============

Docker image for Postgresql 9.3 on Debian stable, including PostGIS 2.1.4. 

A superuser and a password will be created if `POSTGRES_USER` and `POSTGRES_PASSWORD` environment variables are set. A database will be created if `POSTGRES_DB` environment variable is set. 

It also does continuous archiving to AWS S3 if the following environment variables are set: `S3_BACKUP_DIR`, `S3_BACKUP_KEY`, and `S3_BACKUP_SECRET`.  
