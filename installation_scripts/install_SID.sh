#!/bin/bash

# Variables
dt=$(date '+%d_%m_%Y_%H_%M_%S');
LOGFILE="LOG/install_SID_${dt}.log"
BTEQ="/opt/teradata/client/17.00/bin/bteq"

# Folders containing the SQL scripts for db and tables creation
DOSSIER_DB_CREATION="bdd_creation_scripts"
DOSSIER_TABLES_CREATION="tables_creation_scripts"

# List of SQL scripts to execute
SCRIPTS_DB_CREATION=(
    "$DOSSIER_DB_CREATION/SOC_database_creation.sql"
    "$DOSSIER_DB_CREATION/STG_database_creation.sql"
    "$DOSSIER_DB_CREATION/TCH_database_creation.sql"
    "$DOSSIER_DB_CREATION/WRK_database_creation.sql"
)
SCRIPTS_TABLES_CREATION=(
    "$DOSSIER_TABLES_CREATION/SOC_tables_creation.sql"
    "$DOSSIER_TABLES_CREATION/STG_tables_creation.sql"
    "$DOSSIER_TABLES_CREATION/TCH_tables_creation.sql"
    "$DOSSIER_TABLES_CREATION/WRK_tables_creation.sql"
)

# Logging start of installation
echo "Installation of databases and tables started at $(date)" > $LOGFILE

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
        echo "Error while processing $script. Please read the log file for more details." >> $LOGFILE
        exit 1
    fi
}

# Execute each SQL script for db creation
for script in "${SCRIPTS_DB_CREATION[@]}"; do
    run_sql_script $script
done

# Execute each SQL script for tables creation
for script in "${SCRIPTS_TABLES_CREATION[@]}"; do
    run_sql_script $script
done

# End of installation
echo "Installation ended with success at $(date)" >> $LOGFILE
exit 0
