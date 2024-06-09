#!/bin/bash

# Variables
LOGFILE="LAUNCH_LOAD_SID.log"
DATA_HOSPITAL_DIR="/root/Data_Hospital"
DOSSIER_JOBVARS="jobvars_scripts"

# Function to extract date from directory name
extract_date_from_directory() {
    dirname="$1"
    DATE="${dirname: -8}"
    echo $DATE
}

# Function to create jobvars file
create_jobvars_file() {
    table_name="$1"
    DATE="$2"
    file_path="$3"

    cat <<EOL > "$file_path"
TargetTdpId           = '127.0.0.1'
TargetUserName        = 'dbc'
TargetUserPassword    = 'dbc'

FileReaderDirectoryPath = "/root/Data_Hospital/BDD_HOSPITAL_\$DATE/"
FileReaderFileName      = "${table_name}_\$DATE.txt"
FileReaderFormat        = 'Delimited'
FileReaderOpenMode      = 'Read'
FileReaderTextDelimiter = ';'
FileReaderSkipRows      = 1

DDLErrorList = '3807'

LoadTargetTable = 'STG.${table_name}'
EOL
}

# Initialisation du fichier de log
echo "Début de l'installation: $(date)" > $LOGFILE

# Parcours des sous-dossiers et génération des fichiers jobvars
for subdir in "$DATA_HOSPITAL_DIR"/BDD_HOSPITAL_*; do
    # Extract the date from the subdirectory name
    DATE=$(extract_date_from_directory "${subdir##*/}")

    # Loop through files in the subdirectory
    for file in "$subdir"/*.txt; do
        # Extract the table name from the file
        TABLE=$(basename "$file" | cut -d '_' -f 1)

        # Generate jobvars file for the current table and date
        JOBVARS_FILE="$DOSSIER_JOBVARS/jobvars_${TABLE}.txt"
        echo "Generating jobvars file for table $TABLE with date $DATE"
        create_jobvars_file "$TABLE" "$DATE" "$JOBVARS_FILE"

        # Execute TPT script with the corresponding file
        TPT_SCRIPT="$DOSSIER_JOBVARS/load_${TABLE}.tpt"
        echo "Running TPT script for table $TABLE"
        tbuild -f "$TPT_SCRIPT"

        # Log the content of the jobvars file for verification
        cat "$JOBVARS_FILE"
    done
done

# Fin du fichier de log
echo "Fin de l'installation: $(date)" >> $LOGFILE
