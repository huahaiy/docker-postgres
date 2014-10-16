docker-postgres
===============

Docker image for Postgresql 9.3 on Debian stable, including PostGIS 2.1.4. 

It also does continuous archiving to AWS S3 if these environment variables are set when running the container: `S3_BACKUP_DIR`, `S3_BACKUP_KEY`, and `S3_BACKUP_SECRET`.
