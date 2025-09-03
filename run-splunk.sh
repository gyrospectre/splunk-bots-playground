#!/bin/sh
set -e

log () {
    echo '\n['`date "+%Y/%m/%d %H:%M:%S"`'] #--> \033[0;38;5;214m'$1'\033[0m'
}

if [ ! -f "botsv3_data_set.tgz" ]; then
    log "Downloading BOTSv3 dataset..."
    curl "https://botsdataset.s3.amazonaws.com/botsv3/botsv3_data_set.tgz" -o botsv3_data_set.tgz
fi

log "Building docker image..."
docker build . -t splunk_playground:latest
log "Done!"

echo Specify the Splunk admin password to use:
read -s password

log "Starting Splunk..."
docker run -d -p 80:8000 -p 8089:8089 -p 8088:8088 \
-e "SPLUNK_START_ARGS=--accept-license" \
-e "SPLUNK_PASSWORD=$password" \
-e "SPLUNK_LICENCE=Free" \
-e "SPLUNK_GENERAL_TERMS=--accept-sgt-current-at-splunk-com" \
splunk_playground

log "Setup complete. Login to the Splunk UI at http://127.0.0.1/"
