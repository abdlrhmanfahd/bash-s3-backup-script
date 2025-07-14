time=$(date +%m-%y_%H_%M_%S)

Backup_file=/home/ubuntu/bash
Dest=/home/ubuntu/backup
filename=file-backup-$time.tar.gz
LOG_FILE="/home/ubuntu/backup/logfile.log"

S3_BUCKET="s3-new-bash-abdelrahman"
FILE_TO_UPLOAD="$Dest/$filename"

#--------------------------------------------------------------------

if ! command -v aws &> /dev/null
then
        echo "AWS CLI is not installed. Please install it first." | tee -a "$LOG_FILE"
        exit 2
fi


if [ $? -ne 2 ]
then
if [ -f $Dest/$filename ]
then
        echo "Error file $filename already exists!" | tee -a "$LOG_FILE"
else
        tar -czvf "$Dest/$filename" "$Backup_file"
        echo
        echo "Backup Complete Successfuly. Backupfile: $Dest/$filename" | tee -a "$LOG_FILE"
        echo
        aws s3 cp "$FILE_TO_UPLOAD" "s3://$S3_BUCKET/"
fi
fi

if [ $? -eq 0 ]
then
        echo
        echo "File: $filename uploaded successfuly to the S3 Bucket: $S3_BUCKET" | tee -a "$LOG_FILE"
else
        echo "File: $filename uplode to S3 failed" | tee -a "$LOG_FILE"
fi


#----------------------------------------------------------------------



                                