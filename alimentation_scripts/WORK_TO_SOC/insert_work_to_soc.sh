#!/bin/bash

# Variables
LOGFILE="insert_work_to_soc.log"
BTEQ="/opt/teradata/client/17.00/bin/bteq"

# Scripts for SOC tables alimentation
SCRIPTS_DB_COMPLETION=(
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/init_suivi_tch.sql"
    "work_to_soc_adresse.sql"
    "work_to_soc_chambre.sql"
    "work_to_soc_consultation.sql"
    "work_to_soc_hospitalisation.sql"
    "work_to_soc_individu.sql"
    "work_to_soc_medicament.sql"
    "work_to_soc_rpart.sql"
    "work_to_soc_staff.sql"
    "work_to_soc_telephone.sql"
    "work_to_soc_traitement.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/end_suivi_tch.sql"
)

# Function that executes an SQL script with BTEQ
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
        if [ "$scrit" != "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/end_suivi_tch.sql" ]; then
            echo "Lancement du script de suivi tch avant de sortir à cause de l'erreur." >> $LOGFILE
            run_sql_script "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/end_suivi_tch.sql"
        fi
        echo "Erreur lors de l'exécution de $script. Consultez le fichier de log pour plus de détails." >> $LOGFILE
        exit 1
    fi
}

# Exectute each SQL script for SOC tables alimentation
for script in "${SCRIPTS_DB_COMPLETION[@]}"; do
    run_sql_script $script
done

# End of installation
echo "Installation terminée avec succès: $(date)" >> $LOGFILE
exit 0