#!/usr/bin/env bash

# adapted from https://help.mikrotik.com/docs/display/RKB/Create+an+RouterOS+CHR+7.6+AMI

description="Mikrotik RouterOS CHR v7.6"
json_file="mikrotik-routeros-chr-76-raw-containers.json"

JOB="$1"

case $JOB in
    "import-snapshot")
        aws ec2 import-snapshot --description "${description} image" --disk-container file://${json_file}
        ;;

    "monitor-import")
        import_task_id="$2"

        while true; do
            clear
            date
            echo ""
            aws ec2 describe-import-snapshot-tasks --import-task-ids ${import_task_id}
            sleep 10
        done

        #
        #snapshot_id=$(aws ec2 describe-import-snapshot-tasks --import-task-ids ${import_task_id} | grep SnapshotId | awk -F '"'  '{print $4}')
        #
        ;;

    "register-image")
        snapshot_id="$2"

        aws ec2 register-image \
          --name "$description" \
          --description "$description" \
          --architecture x86_64 \
          --virtualization-type hvm \
          --ena-support \
          --root-device-name "/dev/sda1" \
          --block-device-mappings "[{\"DeviceName\": \"/dev/sda1\", \"Ebs\": { \"SnapshotId\": \"$snapshot_id\"}}]"
    ;;

    *)
        echo "Unknown job type: ${JOB}"
    ;;
esac