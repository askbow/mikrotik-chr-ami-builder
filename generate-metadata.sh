#!/usr/bin/env bash

BUCKET=$1

IMAGE_DATA_CACHE=mikrotik.image.data.txt
METADATA_JSON_FILE=mikrotik.chr.json

IMAGE_FILE_NAME=$(grep download.mikrotik.com $IMAGE_DATA_CACHE | awk -F'"' '{print $2}' | awk -F'/' '{print $6}' | tr -d '[:blank:]')
IMAGE_VERSION=$(grep download.mikrotik.com $IMAGE_DATA_CACHE | awk -F'"' '{print $2}' | awk -F'/' '{print $5}' | tr -d '[:blank:]')

echo '{"Description": "Mikrotik RouterOS CHR v'"$IMAGE_VERSION"'",
"Format":"raw", "UserBucket": {
"S3Bucket": "'"$BUCKET"'",
"S3Key": "'"$IMAGE_FILE_NAME"'"
}}' | jq '.' > $METADATA_JSON_FILE
