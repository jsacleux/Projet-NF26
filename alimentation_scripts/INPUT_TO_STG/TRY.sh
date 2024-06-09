#!/bin/bash

# Variables
LOGFILE="LAUNCH_LOAD_SID.log"
DATA_HOSPITAL_DIR="/root/Data_Hospital"
DOSSIER_LOAD="load_scripts"

# Function to extract date from directory name
extract_date_from_directory() {
    dirname="$1"
    DATE="${dirname: -8}"
    echo $DATE
}

# Initialize log file
echo "Start of installation: $(date)" > $LOGFILE

# Traverse subdirectories and execute TPT scripts
for subdir in "$DATA_HOSPITAL_DIR"/BDD_HOSPITAL_*; do
    # Extract the date from the subdirectory name
    DATE=$(extract_date_from_directory "${subdir##*/}")

    # Loop through files in the subdirectory
    for file in "$subdir"/*.txt; do
        # Extract the table name from the file
        TABLE=$(basename "$file" | cut -d '_' -f 1)

        # Define the TPT script path
        TPT_SCRIPT="$DOSSIER_LOAD/load_${TABLE}.tpt"

        # Execute TPT script with dynamically set variables
        echo "Executing TPT script for table $TABLE with date $DATE" >> $LOGFILE
        echo "tbuild -f \"$TPT_SCRIPT\" -v DATE=\"$DATE\" -j \"load_${TABLE}_${DATE}\"" >> $LOGFILE
        tbuild -f "$TPT_SCRIPT" -v DATE="$DATE" -j "load_CHAMBRE"


        # Log the TPT script execution
        echo "Executed TPT script: $TPT_SCRIPT" >> $LOGFILE
    done
done

# End of log file
echo "End of installation: $(date)" >> $LOGFILE
