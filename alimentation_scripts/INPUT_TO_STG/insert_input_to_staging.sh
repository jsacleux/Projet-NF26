#!/bin/bash

# Variables
dt=$(date '+%d_%m_%Y_%H_%M_%S');
LOGFILE="LOG/insert_input_to_staging_${dt}.log"
DATA_HOSPITAL_DIR="/root/Desktop/NF26/projet-nf26-groupe2/Data_Hospital"
DOSSIER_LOAD_STG="/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/INPUT_TO_STG/load_scripts"

# Check number of arguments
if ! [ $# -eq 1 ]; then
    echo "- $0 : argument missing"
    echo "  usage : ./insert_input_to_staging.sh BDD_directory"
    exit 1
fi

# First argument : folder containing data for a day
BDD_HOSPITAL_DIR=$1

if ! [ -d "$DATA_HOSPITAL_DIR/$BDD_HOSPITAL_DIR" ]; then
    echo "- $0 : directory does not exist ($DATA_HOSPITAL_DIR/$BDD_HOSPITAL_DIR)"
    exit 1
fi

# Function to extract date from directory name
extract_date_from_directory() {
    dirname="$1"
    DATE="${dirname: -8}"
    echo $DATE
}

# Initialize log file
echo "Start of input to stg at $(date)" > $LOGFILE

# Removing Checkpoints to avoid error if load script fails.
# Without this, the drop tables are not executed each time and 
# load script will fail when it is launched again with table
# exists error
echo "Removing TPT checkpoints to avoid error : executing 'rm /opt/teradata/client/20.00/tbuild/checkpoint/*' " >> $LOGFILE
rm /opt/teradata/client/20.00/tbuild/checkpoint/*

# Go through subdirectories and execute TPT scripts
for subdir in "$DATA_HOSPITAL_DIR/$BDD_HOSPITAL_DIR"; do
    # Extract the date from the subdirectory name
    DATE=$(extract_date_from_directory "${subdir##*/}")
    
    echo "Processing ${subdir} for date $DATE. This might take a while..."
    echo "Processing ${subdir} for date $DATE" >> $LOGFILE
    
    # Loop through files in the subdirectory
    for file in "$subdir"/*.txt; do
        # Extract the table name from the file
        TABLE=$(basename "$file" | cut -d '_' -f 1)

        # Define the TPT script path
        TPT_SCRIPT="$DOSSIER_LOAD_STG/load_${TABLE}.tpt"

        # Execute TPT script with dynamically set variables
        echo "Processing file in ${subdir} for table $TABLE, executing $TPT_SCRIPT..."
        echo "Processing file in ${subdir} for table $TABLE, executing $TPT_SCRIPT..." >> $LOGFILE
        echo "tbuild -f \"$TPT_SCRIPT\" -v DATE=\"$DATE\" -j \"load_${TABLE}\"" >> $LOGFILE

        tbuild -f "$TPT_SCRIPT" -u DATE="'$DATE'" -j "load_${TABLE}" >> $LOGFILE

        # Log the TPT script execution
        echo "Executed TPT script: $TPT_SCRIPT" >> $LOGFILE
    done
done

# End of log file
echo "End of input to stg at $(date)" >> $LOGFILE

