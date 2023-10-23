#!/usr/bin/env bash

IMAGE_DATA_CACHE=mikrotik.image.data.txt

curl -Ss https://mikrotik.com/download | grep -E 'chr-7\.[0-9]+\.[0-9]+\.img\.zip' | sed 's|<br />|\n|g' | sed 's|><|>\n<|g' | grep -E 'chr-7\.[0-9]+\.[0-9]+\.img\.zip' | sort -u > $IMAGE_DATA_CACHE

IMAGE_URI=$(cat $IMAGE_DATA_CACHE | grep download.mikrotik.com | awk -F'"' '{print $2}' | tr -d '[:blank:]')
IMAGE_FILE_NAME=$(cat $IMAGE_DATA_CACHE | grep download.mikrotik.com | awk -F'"' '{print $2}' | awk -F'/' '{print $6}' | tr -d '[:blank:]')
IMAGE_MD5=$(cat $IMAGE_DATA_CACHE | grep MD5 | awk -F'>' '{print $3}' | awk -F' ' '{print $2}')
IMAGE_SHA256=$(cat $IMAGE_DATA_CACHE | grep SHA256 | awk -F'>' '{print $3}' | awk -F' ' '{print $2}')

echo "$IMAGE_MD5 $IMAGE_FILE_NAME" > $IMAGE_FILE_NAME.md5
echo "$IMAGE_SHA256 $IMAGE_FILE_NAME" > $IMAGE_FILE_NAME.sha256

wget $IMAGE_URI -O $IMAGE_FILE_NAME
sha256sum -c $IMAGE_FILE_NAME.sha256 || exit 1
md5sum -c $IMAGE_FILE_NAME.md5 || exit 1
