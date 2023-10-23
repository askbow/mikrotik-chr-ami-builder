#!/usr/bin/env bash

# adapted from https://help.mikrotik.com/docs/display/RKB/Create+an+RouterOS+CHR+7.6+AMI

METADATA_JSON_FILE=mikrotik.chr.json

DESCRIPTION=$(jq -r '.Description' $METADATA_JSON_FILE)

CMD=$1

case $CMD in
    "import-snapshot")
        aws ec2 import-snapshot --description "${DESCRIPTION} raw snapshot" --disk-container "file://${METADATA_JSON_FILE}"
        ;;

    "monitor-import")
        TASK_ID="$2"

        while true; do
            clear
            date
            echo ""
            aws ec2 describe-import-snapshot-tasks --import-task-ids "${TASK_ID}"
            sleep 10
        done
        ;;

    "register-image")
        SNAPSHOT_ID="$2"

        aws ec2 register-image \
          --name "$DESCRIPTION" \
          --description "$DESCRIPTION" \
          --architecture x86_64 \
          --virtualization-type hvm \
          --ena-support \
          --root-device-name "/dev/sda1" \
          --block-device-mappings '[{"DeviceName": "/dev/sda1", "Ebs": { "SnapshotId": "'"$SNAPSHOT_ID"'"}}]'
    ;;

    *)
        echo "Unknown command: ${CMD}"
        exit 1
    ;;
esac