pedropilla/backup-to-s3
======================

[![Docker Stars](https://img.shields.io/docker/stars/pedropilla/backup-to-s3.svg)](https://hub.docker.com/r/pedropilla/backup-to-s3/)
[![Docker Pulls](https://img.shields.io/docker/pulls/pedropilla/backup-to-s3.svg)](https://hub.docker.com/r/pedropilla/backup-to-s3/)
[![Docker Build](https://img.shields.io/docker/automated/pedropilla/backup-to-s3.svg)](https://hub.docker.com/r/pedropilla/backup-to-s3/)
[![Layers](https://images.microbadger.com/badges/image/pedropilla/backup-to-s3.svg)](https://microbadger.com/images/pedropilla/backup-to-s3)

Docker container that periodically backups files to Amazon S3 using [s3cmd sync](http://s3tools.org/s3cmd-sync) and cron.

### Usage

    docker run -d [OPTIONS] pedropilla/backup-to-s3

### Parameters:

* `-e ACCESS_KEY=<AWS_KEY>`: Your AWS key.
* `-e SECRET_KEY=<AWS_SECRET>`: Your AWS secret.
* `-e S3_PATH=s3://<BUCKET_NAME>/<PATH>/`: S3 Bucket name and path. Should end with trailing slash.
* `-v /path/to/backup:/data:ro`: mount target local folder to container's data folder. Content of this folder will be synced with S3 bucket.

### Optional parameters:

* `-e PARAMS="--dry-run"`: parameters to pass to the sync command ([full list here](http://s3tools.org/usage)).
* `-e DATA_PATH=/data/`: container's data folder. Default is `/data/`. Should end with trailing slash.
* `-e 'CRON_SCHEDULE=0 1 * * *'`: specifies when cron job starts ([details](http://en.wikipedia.org/wiki/Cron)). Default is `0 1 * * *` (runs every day at 1:00 am).
* `no-cron`: run container once and exit (no cron scheduling).

### Examples:

Run upload to private S3 (minio) everyday at 12:00pm:

    docker run -d \
        -e ACCESS_KEY=privatekey \
        -e SECRET_KEY=privatesecretkey \
        -e PARAMS=--host=s3.privateminio.com:80 --host-bucket=privatekey --no-check-certificate --no-check-hostname --no-ssl --signature-v2 \
        -e S3_PATH=s3://privatekey/test/ \
        -e 'CRON_SCHEDULE=0 12 * * *' \
        -v /home/user/data:/data:ro \
        pedropilla/backup-to-s3


Run upload to S3 everyday at 12:00pm:

    docker run -d \
        -e ACCESS_KEY=myawskey \
        -e SECRET_KEY=myawssecret \
        -e S3_PATH=s3://my-bucket/backup/ \
        -e 'CRON_SCHEDULE=0 12 * * *' \
        -v /home/user/data:/data:ro \
        pedropilla/backup-to-s3

Run once then delete the container:

    docker run --rm \
        -e ACCESS_KEY=myawskey \
        -e SECRET_KEY=myawssecret \
        -e S3_PATH=s3://my-bucket/backup/ \
        -v /home/user/data:/data:ro \
        pedropilla/backup-to-s3 no-cron

Run once to get from S3 then delete the container:

    docker run --rm \
        -e ACCESS_KEY=myawskey \
        -e SECRET_KEY=myawssecret \
        -e S3_PATH=s3://my-bucket/backup/ \
        -v /home/user/data:/data:rw \
        pedropilla/backup-to-s3 get

Run once to delete from s3 then delete the container:

    docker run --rm \
        -e ACCESS_KEY=myawskey \
        -e SECRET_KEY=myawssecret \
        -e S3_PATH=s3://my-bucket/backup/ \
        pedropilla/backup-to-s3 delete

Security considerations: on restore, this opens up permissions on the restored files widely.
