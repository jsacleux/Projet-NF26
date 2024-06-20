#!/bin/bash

# Variables
dt=$(date '+%d_%m_%Y_%H_%M_%S');
LOGFILE="LOG/LAUNCH_LOAD_SID_${dt}.log"
DATA_HOSPITAL_DIR="/root/Desktop/NF26/projet-nf26-groupe2/Data_Hospital"

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

# Initialize log file
echo 
echo "----------------------------------------------------------------------------------------------"
echo "Start of run at $(date)"
echo
echo "----------------------------------------------------------------------------------------------"

echo "Start of run at $(date)" > $LOGFILE


echo "Executing INPUT_TO_STG/insert_input_to_staging.sh with argument $BDD_HOSPITAL_DIR at $(date)"
echo "Executing INPUT_TO_STG/insert_input_to_staging.sh with argument $BDD_HOSPITAL_DIR at $(date)" >> $LOGFILE
INPUT_TO_STG/insert_input_to_staging.sh $BDD_HOSPITAL_DIR

echo "Executing STG_TO_WORK/insert_staging_to_work.sh at $(date)"
echo "Executing STG_TO_WORK/insert_staging_to_work.sh at $(date)" >> $LOGFILE
STG_TO_WORK/insert_staging_to_work.sh 

echo "Executing WORK_TO_SOC/insert_work_to_soc.sh at $(date)"
echo "Executing WORK_TO_SOC/insert_work_to_soc.sh at $(date)" >> $LOGFILE
WORK_TO_SOC/insert_work_to_soc.sh 

# End of log file
echo "End of run at $(date)" >> $LOGFILE

# Ask if another day should be processed
read -p "Do you want to process another day? (yes/no): " choice
if [ "$choice" == "yes" ]; then
    read -p "Enter the directory for the chosen day: " new_directory
    ./LAUNCH_LOAD_SID.sh "$new_directory"
else
    echo "Finished."
    exit 0
fi

