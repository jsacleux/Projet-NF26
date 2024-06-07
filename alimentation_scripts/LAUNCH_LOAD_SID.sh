#!/bin/bash

# Variables
LOGFILE="LAUNCH_LOAD_SID.log"
DATA_HOSPITAL_DIR="/root/Data_Hospital"

### TODO ADD 
## In jobvars.txt :
# LoadLogTable    = 'irs.irs_returns_lg' 
# LoadErrorTable1 = 'irs.irs_returns_et'
# LoadErrorTable2 = 'irs.irs_returns_uv'
# REPEAT FOR ALL STG TABLES (CHAMBRE, CONSULTATION...)

## In load.txt :
# ('DROP TABLE ' || @LoadLogTable || ';'),
# ('DROP TABLE ' || @LoadErrorTable1 || ';'),
# ('DROP TABLE ' || @LoadErrorTable2 || ';'),
# REPEAT FOR ALL STG TABLES (CHAMBRE, CONSULTATION...)

# TODO execution of TPT scripts TO READ ALL DATABASES FROM A GIVEN INPUT DAY

# Dossiers contenant les scripts SQL
DOSSIER_LOAD="load_scripts"
DOSSIER_JOBVARS="jobvars_scripts"


# Initialisation du fichier de log
echo "Début de l'installation: $(date)" > $LOGFILE

# Loop through each subdirectory in Data_hospital
for subdir in "$DATA_HOSPITAL_DIR"/BDD_HOSPITAL_*; do
    # Extract the date from the subdirectory name
    DATE=$(basename "$subdir" | cut -d '_' -f 3)
    
    # Loop through files in the subdirectory
    for file in "$subdir"/*; do
        # Extract the table name from the file
        TABLE=$(basename "$file" | cut -d '_' -f 1)


        # Execute TPT script with dynamically set variables
        echo "tbuild -f \"$file\" -v \"$DOSSIER_JOBVARS/jobvars_${TABLE}.sh\" -j "file_load_${TABLE}_${DATE}""
        tbuild -f "$file" -v "$DOSSIER_JOBVARS/jobvars_${TABLE}.sh" -j "file_load_${TABLE}_${DATE}" -d "$DATE"
        cat "$DOSSIER_JOBVARS/jobvars_${TABLE}.sh"
    done
done

# Fin du fichier de log
echo "Fin de l'installation: $(date)" >> $LOGFILE
