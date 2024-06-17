#!/bin/bash

# Variables
LOGFILE="insert_staging_to_work.log"
BTEQ="/opt/teradata/client/17.00/bin/bteq"
SCRIPTS_STG_TO_WRK=(
    "/root/Desktop/NF26/projet-nf26-groupe2/installation_scripts/tables_creation_scripts/WRK_tables_creation.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/STG_TO_WORK/stg_to_work.sql"
)

# Function to execute sql file using BTEQ
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

# Execute each sql script for database creation
for script in "${SCRIPTS_STG_TO_WRK[@]}"; do
    run_sql_script $script
done

# End of installation
echo "Installation terminée avec succès: $(date)" >> $LOGFILE
exit 0
