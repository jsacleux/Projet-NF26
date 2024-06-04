#!/bin/bash

# Variables
LOGFILE="LAUNCH_LOAD_SID.log"

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
DOSSIER_JOBVARS="load_scripts"
DOSSIER_LOAD="jobvars_scripts"
DATE="dates"

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

# Initialisation du fichier de log
echo "Début de l'installation: $(date)" > $LOGFILE

# Fonction pour exécuter un script SQL avec TPT 
for ((i=0; i<${#SCRIPT_JOBVARS[@]}; i++))
do
    tbuild -f "${SCRIPT_LOAD[$i]}" -v "${SCRIPT_JOBVARS[$i]}" -j file_load
done

# Fin du fichier de log
echo "Fin de l'installation: $(date)" >> $LOGFILE
