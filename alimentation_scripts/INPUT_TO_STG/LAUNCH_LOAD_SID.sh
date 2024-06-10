#!/bin/bash

# Variables
LOGFILE="LAUNCH_LOAD_SID.log"
DATA_HOSPITAL_DIR="/root/Data_Hospital"
DOSSIER_LOAD="load_scripts"
DROP_SCRIPT="/root/NF26_PROJECT/installation_scripts/tables_creation_scripts/STG_tables_creation.sql"
BTEQ="/opt/teradata/client/17.00/bin/bteq"

# Test du nombre d'arguments
if ! [ $# -eq 1 ]; then
		echo "- $0 : argument manquant"
		echo "  usage : ./LAUCH_LOAD_SID.sh BDD_directory"
		exit
fi;

# Premier argument : dossier vers une base de données contenant les données pour une journée
BDD_HOSPITAL_DIR=$1

if ! [ -e "$DATA_HOSPITAL_DIR/$BDD_HOSPITAL_DIR" ]; then
		echo "- $0 : fichier inexistant ($DATA_HOSPITAL_DIR/$BDD_HOSPITAL_DIR)"
		exit
fi;
# Function to extract date from directory name
extract_date_from_directory() {
    dirname="$1"
    DATE="${BDD_HOSPITAL_DIR: -8}"
    echo $DATE
}

# Initialize log file
echo "Start of installation: $(date)" > $LOGFILE

# Drop stg tables
# Fonction pour exécuter un script SQL avec BTEQ
run_sql_script() {
    local script=$1
    echo "Exécution de $script..." >> $LOGFILE
    $BTEQ <<EOF >> $LOGFILE 2>&1
.RUN FILE=$script;
.IF ERRORCODE <> 0 THEN .QUIT 100;
.LOGOFF;
.EXIT;
EOF

    if [ $? -ne 0 ]; then
        echo "Erreur lors de l'exécution de $script. Consultez le fichier de log pour plus de détails." >> $LOGFILE
        exit 1
    fi
}

run_sql_script $DROP_SCRIPT

# Traverse subdirectories and execute TPT scripts
for subdir in "$DATA_HOSPITAL_DIR/$BDD_HOSPITAL_DIR"; do
    echo ${subdir}
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
        echo "tbuild -f \"$TPT_SCRIPT\" -v DATE=\"$DATE\" -j \"load_${TABLE}\"" >> $LOGFILE
        tbuild -f "$TPT_SCRIPT" -u DATE="'$DATE'" -j "load_${TABLE}"


        # Log the TPT script execution
        echo "Executed TPT script: $TPT_SCRIPT" >> $LOGFILE
    done
done

# End of log file
echo "End of installation: $(date)" >> $LOGFILE
