#!/bin/bash

# Variables
LOGFILE="insert_staging_to_work.log"
BTEQ="/opt/teradata/client/17.00/bin/bteq"
SCRIPTS_STG_TO_WRK=(
    "/root/Desktop/NF26/projet-nf26-groupe2/installation_scripts/tables_creation_scripts/WRK_tables_creation.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/init_suivi_tch.sql"
    "stg_to_work_adresse.sql"
    "stg_to_work_chambre.sql"
    "stg_to_work_consultation.sql"
    "stg_to_work_hospitalisation.sql"
    "stg_to_work_individu.sql"
    "stg_to_work_medicament.sql"
    "stg_to_work_rpart.sql"
    "stg_to_work_staff.sql"
    "stg_to_work_telephone.sql"
    "stg_to_work_traitement.sql"
    "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/end_suivi_tch.sql"
)

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
        if [ "$scrit" != "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/end_suivi_tch.sql" ]; then
            echo "Lancement du script de suivi tch avant de sortir à cause de l'erreur." >> $LOGFILE
            run_sql_script "/root/Desktop/NF26/projet-nf26-groupe2/alimentation_scripts/SUIVI_TCH/end_suivi_tch.sql"
        fi
        echo "Erreur lors de l'exécution de $script. Consultez le fichier de log pour plus de détails." >> $LOGFILE
        exit 1
    fi
}

# Exécuter chaque script SQL pour la création de bases de données
for script in "${SCRIPTS_STG_TO_WRK[@]}"; do
    run_sql_script $script
done

# Fin de l'installation
echo "Installation terminée avec succès: $(date)" >> $LOGFILE
exit 0
