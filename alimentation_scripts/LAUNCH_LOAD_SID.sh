#!/bin/bash

# Variables
LOGFILE="LAUNCH_LOAD_SID.log"
DATA_HOSPITAL_DIR="/root/Desktop/NF26/projet-nf26-groupe2/Data_Hospital"
DOSSIER_LOAD_STG="INPUT_TO_STG\load_scripts"

# Check number of arguments
if ! [ $# -eq 1 ]; then
    echo "- $0 : argument missing"
    echo "  usage : ./LAUNCH_LOAD_SID.sh BDD_directory"
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
echo "Start of installation: $(date)" > $LOGFILE

# Removing Checkpoints to avoid error if load script fails
# Without this, the drop tables are not run each time and 
# load script will fail when it is launched again with table
# exists error
echo "Removing TPT checkpoints to avoid error" >> $LOGFILE
rm /opt/teradata/client/20.00/tbuild/checkpoint/*

# Go through subdirectories and execute TPT scripts
for subdir in "$DATA_HOSPITAL_DIR/$BDD_HOSPITAL_DIR"; do
    echo ${subdir}
    # Extract the date from the subdirectory name
    DATE=$(extract_date_from_directory "${subdir##*/}")

    # Loop through files in the subdirectory
    for file in "$subdir"/*.txt; do
        # Extract the table name from the file
        TABLE=$(basename "$file" | cut -d '_' -f 1)

        # Define the TPT script path
        TPT_SCRIPT="$DOSSIER_LOAD_STG/load_${TABLE}.tpt"

        # Execute TPT script with dynamically set variables
        echo "Executing TPT script for table $TABLE with date $DATE" >> $LOGFILE
        echo "tbuild -f \"$TPT_SCRIPT\" -v DATE=\"$DATE\" -j \"load_${TABLE}\"" >> $LOGFILE

        tbuild -f "$TPT_SCRIPT" -u DATE="'$DATE'" -j "load_${TABLE}"

        # Log the TPT script execution
        echo "Executed TPT script: $TPT_SCRIPT" >> $LOGFILE
    done
done

# Execute additional scripts
echo "Executing STG_TO_WORK\\insert_staging_to_work.sh" >> $LOGFILE
STG_TO_WORK\insert_staging_to_work.sh 

echo "Executing WORK_TO_SOC\\insert_work_to_soc.sh" >> $LOGFILE
WORK_TO_SOC\insert_work_to_soc.sh 

# End of log file
echo "End of installation: $(date)" >> $LOGFILE

# Ask if another day should be processed
while true; do
    read -p "Do you want to process another day? (yes/no): " choice
    if [ "$choice" == "yes" ]; then
        read -p "Enter the directory for the chosen day: " new_directory
        ./LAUNCH_LOAD_SID.sh "$new_directory"
    else
        echo "Finished."
        exit 0
    fi
done
