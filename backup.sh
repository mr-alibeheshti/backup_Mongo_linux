#!/bin/bash

# Settings
NODE_PATH="YOUR NODE PATH"
BACKUP_DIR="YOUR BACKUP DIR"
DATE=$(date +%Y-%m-%d)
BACKUP_FOLDER="${BACKUP_DIR}/$DATE"
DBNAME="YOUR DB NAME"
DB_URL="YOUR DB URL"
BUCKET_PATH="YOUR BUCKET PATH"
DOMAIN="SERVICE DOMAIN"
SEND_MAIL="PATH OF SMTP CODE"
mkdir -p "${BACKUP_FOLDER}"

# Perform the backup
mongodump --uri=$DB_URL --db=$DBNAME --gzip --out="$BACKUP_FOLDER"
if [ $? -eq 0 ]; then
    echo "Backup operation completed successfully"

    # Upload to Storage
    aws s3 cp $BACKUP_FOLDER $BUCKET_PATH --endpoint-url=https://$DOMAIN --recursive
    if [ $? -eq 0 ]; then
        echo "Send Backup to Storage completed successfully. Deleting local backup."
        rm -rf "$BACKUP_FOLDER"
    else
        echo "Can't Send Backup to Storage" | $NODE_PATH $SEND_MAIL
    fi
else
    echo "Can't Finish Backup Operation" | $NODE_PATH $SEND_MAIL
fi


