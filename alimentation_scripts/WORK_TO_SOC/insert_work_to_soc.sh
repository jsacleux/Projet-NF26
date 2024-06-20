#!/bin/bash

# Variables
dt=$(date '+%d_%m_%Y_%H_%M_%S');
LOGFILE="LOG/insert_work_to_soc_${dt}.log"
BTEQ="/opt/teradata/client/17.00/bin/bteq"

# Scripts for SOC tables alimentation
SCRIPTS_DB_COMPLETION=(
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/init_suivi_tch.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/WORK_TO_SOC/work_to_soc_adresse.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/WORK_TO_SOC/work_to_soc_chambre.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/WORK_TO_SOC/work_to_soc_consultation.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/WORK_TO_SOC/work_to_soc_hospitalisation.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/WORK_TO_SOC/work_to_soc_individu.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/WORK_TO_SOC/work_to_soc_medicament.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/WORK_TO_SOC/work_to_soc_rpart.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/WORK_TO_SOC/work_to_soc_staff.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/WORK_TO_SOC/work_to_soc_telephone.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/WORK_TO_SOC/work_to_soc_traitement.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/end_suivi_tch.sql"
)

# Function that executes an SQL script with BTEQ
run_sql_script() {
    local script=$1
    echo "Executing $script..." >> $LOGFILE
    $BTEQ <<EOF >> $LOGFILE 2>&1

.RUN FILE=$script;

.IF ERRORCODE <> 0 THEN .QUIT 100;

.LOGOFF;
.EXIT;
EOF

    if [ $? -ne 0 ]; then
        if [ "$scrit" != "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/end_suivi_tch.sql" ]; then
            echo "Launching script 'suivi tch' before exiting because of error in script $script." >> $LOGFILE
            run_sql_script "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/end_suivi_tch.sql"
        fi
        echo "Error while processing $script. Please read the log file for more details." >> $LOGFILE
        exit 1
    fi
}

echo "Execution de work to soc started at $(date)" > $LOGFILE

# Execute each SQL script for SOC tables alimentation
for script in "${SCRIPTS_DB_COMPLETION[@]}"; do
    run_sql_script $script
done

# End of installation
echo "Work to SOC ended with success: $(date)" >> $LOGFILE
exit 0