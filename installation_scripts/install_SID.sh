#!/bin/bash

# Variables
LOGFILE="install_SID.log"
BTEQ="/opt/teradata/client/17.00/bin/bteq"

# Dossiers contenant les scripts SQL
DOSSIER_DB_CREATION="bdd_creation_scripts"
DOSSIER_TABLES_CREATION="tables_creation_scripts"

SCRIPTS_DB_CREATION=(
    "$DOSSIER_DB_CREATION/SOC_database_creation.sql"
    "$DOSSIER_DB_CREATION/STG_database_creation.sql"
    "$DOSSIER_DB_CREATION/TCH_database_creation.sql"
)

# Liste des scripts SQL à exécuter pour la création de tables
SCRIPTS_TABLES_CREATION=(
    "$DOSSIER_TABLES_CREATION/SOC_tables_creation.sql"
    "$DOSSIER_TABLES_CREATION/STG_tables_creation.sql"
    "$DOSSIER_TABLES_CREATION/TCH_tables_creation.sql"
)

# Initialisation du fichier de log
echo "Début de l'installation: $(date)" > $LOGFILE

# Fonction pour exécuter un script SQL avec BTEQ
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

# Exécuter chaque script SQL pour la création de bases de données
for script in "${SCRIPTS_DB_CREATION[@]}"; do
    run_sql_script $script
done

# Exécuter chaque script SQL pour la création de tables
for script in "${SCRIPTS_TABLES_CREATION[@]}"; do
    run_sql_script $script
done

# Fin de l'installation
echo "Installation terminée avec succès: $(date)" >> $LOGFILE
exit 0
