# Projet NF26 Groupe2

## Description du projet

Projet de la partie 3 de NF26 réalisé avec SMART TEEM en P24.

Ce projet porte sur la mise en place d'une solution décisionnelle (Datawarehouse Teradata et Reporting Power BI)

Nous avons choisi les données portant sur l'établissement de santé.

Le groupe est constitué de Juliette Sacleux, Nesrine Serradj, Eliott Sebbagh, Louise Caignaert, Xavier Lemerle et Camille Bauvais.

## Liens utiles

[Suivi de projet Jira](https://nf26groupe2.atlassian.net/jira/software/projects/SCRUM/boards/1/backlog)

[Dépôt gitlab](https://gitlab.utc.fr/esebbagh/projet-nf26-groupe2)

[Slides soutenance](https://www.canva.com/design/DAGIatDK5eQ/3IFqkWeCya4NKvFGBXLdgg/edit)

## Guide d'exécution

Cloner le repository dans un dossier `/root/Desktop/NF26/` sur une vm teradata (version utilisée dans le projet : Vantage 17.20).

### Installation du SID

Pour créer les bases de données et les tables, exécuter le fichier `install_SID.sh` situé dans le dossier `installation_scripts`.

### Ingestion des données

Pour alimenter la base de données STG, exécuter le fichier `insert_input_staging_to_work.sh` situé dans le dossier `alimentation_scripts/INPUT_TO_STG`, qui prend en argument le nom du dossier contenant les données à ingérer (de la forme `BDD_HOSPITAL_{YYYYMMDD}`).

### Alimentation du datawarehouse

Pour alimenter la base de données WRK, exécuter le fichier `insert_staging_to_work.sh` situé dans le dossier `alimentation_scripts/STG_TO_WORK`.

Pour alimenter la base de données SOC, exécuter le fichier `insert_work_to_soc.sh` situé dans le dossier `alimentation_scripts/WORK_TO_SOC`.

### Execution de toute la chaine INPUT -> STG -> WORK -> SOC

Afin de faire en une fois l'insertion des données d'une journée dans les tables STG, puis WORK, puis SOC,l'utilisateur peut se servir de `LAUNCH_LOAD_SID.sh`, présent dans le dossier. On laisse le choix à l'utilisateur d'effectuer chaque étape séparément (pour des raisons de débogage notamment) ou d'exécuter la chaîne en une fois avec `LAUNCH_LOAD_SID.sh`. Une fois l'insertion effectuée pour une journée, ce script proposera à l'utilisateur de saisir un nouveau nom de dossier à ingérer (pour traiter un autre jour).

Exemple d'utilisation depuis le dossier `alimentation_scripts/`: `./LAUNCH_LOAD_SID.sh BDD_HOSPITAL_20240429`
Puis l'utilisateur saisit `yes` pour saisir un autre jour puis `BDD_HOSPITAL_20240430` pour traiter les données du jour suivant. L'utilisateur peut alors continuer avec d'autres jour, et saisir `no` pour arrêter.

Tous les fichiers de LOG seront présents à l'issu de l'exécution dans le dossier `alimentation_scripts/LOG/` (un fichier par script sh pour chaque jour, donc 4 fichiers log par jour).

### Fichiers de log

Dans les répertoires contenant des scripts `.sh`, on trouve un repertoire LOG. Celui-ci contient des fichiers de log du même nom que les fichiers `.sh` auquel on concatène la date avec l'extension `.log` (par exemple install_SID_YYYY_MM_DD_HH_MM_SS.log) sont disponibles. Ils retracent le déroulement de chaque exécution.

## Documentation de Terradata

[BTEQ](https://docs.teradata.com/r/Enterprise_IntelliFlex_Lake_VMware/Basic-Teradata-Query-Reference-17.20/Introduction-to-BTEQ/BTEQ-Operation-in-the-Client-Server-Environment/BTEQ-Communication)

[TPT](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://quickstarts.teradata.com/tools-and-utilities/run-bulkloads-efficiently-with-teradata-parallel-transporter.html&ved=2ahUKEwjvodTlssGGAxUgUaQEHQLLDTwQFnoECBIQAQ&usg=AOvVaw1lBRZClWMFdRnEst-f-i4L)
