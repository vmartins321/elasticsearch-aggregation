#!/bin/bash
set -e
envsubst < logstash.yml > config/logstash.yml
envsubst < pipeline/$CONF_FILE > pipeline/run.conf

if [ -z "$WORKER" ]; then
    echo "execute with default number of workers ..."
    bin/logstash -f pipeline/run.conf &
else
    echo "execute with $WORKER workers ..."
    bin/logstash -f pipeline/run.conf -w $WORKER -b $BATCH_SIZE & 
fi

wait $!
[ -e /usr/share/logstash/categories/ ] && gsutil -m cp -r -n /usr/share/logstash/ategories/* $GCS_DIR && rm /usr/share/logstash/categories/*
