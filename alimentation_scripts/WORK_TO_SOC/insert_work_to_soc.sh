#!/bin/bash

# Variables
LOGFILE="insert_work_to_soc.log"
BTEQ="/opt/teradata/client/17.00/bin/bteq"
EXEC_ID_TEST='12345'

SCRIPTS_DB_COMPLETION=(
    "init_suivi_tch.sql"
    "chambre.sql"
    "end_suivi_tch.sql"
)

# Function to execute sql script using BTEQ
run_sql_script() {
    local script=$1
    echo "Exécution de $script..." >> $LOGFILE
    $BTEQ <<EOF >> $LOGFILE 2>&1
.LOGON localhost/dbc

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
for script in "${SCRIPTS_DB_COMPLETION[@]}"; do
    run_sql_script $script
done

# End of installation
echo "Installation terminée avec succès: $(date)" >> $LOGFILE
exit 0