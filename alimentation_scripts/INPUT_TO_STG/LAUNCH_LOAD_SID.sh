#!/bin/bash

# Variables
LOGFILE="LAUNCH_LOAD_SID.log"
BASE_DIR="/root/Data_Hospital"
DOSSIER_LOAD="load_scripts"
DOSSIER_JOBVARS="jobvars_scripts"

# Function to extract date from directory name
extract_date_from_directory() {
    dirname="$1"
    # Extracting date from directory name assuming it's in the format BDD_HOSPITAL_YYYYMMDD
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

FileReaderDirectoryPath = "/root/Data_Hospital/BDD_HOSPITAL_${DATE}/"
FileReaderFileName      = "${table_name}_${DATE}.txt"
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
for dir in "$BASE_DIR"/*/
do
    dir=${dir%*/}
    DATE=$(extract_date_from_directory "${dir##*/}")

    for filepath in "$dir"/*.txt
    do
        filename=$(basename "$filepath")
        TABLE_NAME="${filename%%_*}"
        JOBVARS_FILE="$DOSSIER_JOBVARS/jobvars_${TABLE_NAME}.txt"

        echo "Generating jobvars file for table $TABLE_NAME with date $DATE"
        create_jobvars_file "$TABLE_NAME" "$DATE" "$JOBVARS_FILE"
    done
done

# Liste des scripts load et jobvars
SCRIPT_JOBVARS=(
    "$DOSSIER_JOBVARS/jobvars_chambre.txt"
    "$DOSSIER_JOBVARS/jobvars_consultation.txt"
    "$DOSSIER_JOBVARS/jobvars_hospitalisation.txt"
    "$DOSSIER_JOBVARS/jobvars_medicament.txt"
    "$DOSSIER_JOBVARS/jobvars_patient.txt"
    "$DOSSIER_JOBVARS/jobvars_personnel.txt"
    "$DOSSIER_JOBVARS/jobvars_traitement.txt"
)

SCRIPT_LOAD=(
    "$DOSSIER_LOAD/load_chambre.txt"
    "$DOSSIER_LOAD/load_consultation.txt"
    "$DOSSIER_LOAD/load_hospitalisation.txt"
    "$DOSSIER_LOAD/load_medicament.txt"
    "$DOSSIER_LOAD/load_patient.txt"
    "$DOSSIER_LOAD/load_personnel.txt"
    "$DOSSIER_LOAD/load_traitement.txt"
)

# Fonction pour exécuter un script SQL avec TPT 
for ((i=0; i<${#SCRIPT_JOBVARS[@]}; i++))
do
    # Extracting date from jobvars script filename
    extract_date_from_filename "${SCRIPT_LOAD[$i]}"
    echo "tbuild -f \"${SCRIPT_LOAD[$i]}\" -v \"${SCRIPT_JOBVARS[$i]}\" -j file_load -d $DATE"
    tbuild -f "${SCRIPT_LOAD[$i]}" -v "${SCRIPT_JOBVARS[$i]}" -j file_load -d "$DATE"
done

# Fin du fichier de log
echo "Fin de l'installation: $(date)" >> $LOGFILE
