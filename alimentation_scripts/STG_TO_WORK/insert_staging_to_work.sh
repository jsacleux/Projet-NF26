#!/bin/bash

# Variables
LOGFILE="LOG/insert_staging_to_work.log"
BTEQ="/opt/teradata/client/17.00/bin/bteq"

# Scripts for work tables alimentation
SCRIPTS_STG_TO_WRK=(
     # recreate work tables to work with empty tables
    "/root/Desktop/NF26/projet-nf26-groupe2/installation_scripts/tables_creation_scripts/WRK_tables_creation.sql"
    # start "suivi tch" for the run
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/init_suivi_tch.sql"

    # Run stg to work for rpart and medicament first as they might be needed for other tables
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/STG_TO_WORK/stg_to_work_rpart.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/STG_TO_WORK/stg_to_work_medicament.sql"

    # Run stg to work for other tables
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/STG_TO_WORK/stg_to_work_adresse.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/STG_TO_WORK/stg_to_work_chambre.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/STG_TO_WORK/stg_to_work_consultation.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/STG_TO_WORK/stg_to_work_hospitalisation.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/STG_TO_WORK/stg_to_work_individu.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/STG_TO_WORK/stg_to_work_staff.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/STG_TO_WORK/stg_to_work_telephone.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/STG_TO_WORK/stg_to_work_traitement.sql"

    # end "suivi tch" for the run
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
        echo "Error while processing $script. Please read the log file for more details." >> $LOGFILE
        exit 1
    fi
}

echo "Execution de stg to work started at $(date)" > $LOGFILE

# Execute each SQL script
for script in "${SCRIPTS_STG_TO_WRK[@]}"; do
    run_sql_script $script
done

# End of installation
echo "Stg to Work ended with success: $(date)" >> $LOGFILE
exit 0
