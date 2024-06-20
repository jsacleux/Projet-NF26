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

Pour alimenter la base de données STG, exécuter le fichier `LAUNCH_LOAD_SID.sh` situé dans le dossier `alimentation_scripts/INPUT_TO_STG`, qui prend en argument le nom du dossier contenant les données à ingérer (de la forme `BDD_HOSPITAL_{YYYYMMDD}`). Ce script lancera également `insert_staging_to_work.sh` et `insert_work_to_soc.sh`, pour insérer les données de STG dans WORK, puis de WORK dans SOC. Enfin, il proposera à l'utilisateur de saisir un nouveau nom de dossier à ingérer (pour traiter un autre jour).

### Alimentation du datawarehouse

Les deux scripts ci-dessous sont utilisés par `LAUNCH_LOAD_SID.sh`. On peut cependant vouloir les lancer à la main pour des raisons de débogage.

Pour alimenter la base de données WRK, exécuter le fichier `insert_staging_to_work.sh` situé dans le dossier `alimentation_scripts/STG_TO_WORK`.

Pour alimenter la base de données SOC, exécuter le fichier `insert_work_to_soc.sh` situé dans le dossier `alimentation_scripts/WORK_TO_SOC`.

### Fichiers de log

Dans les répertoires contenant des scripts `.sh`, des fichiers de log du même nom que les fichiers `.sh` avec l'extension `.log` sont disponibles. Ils retracent le déroulement de chaque exécution.

## Documentation de Terradata

[BTEQ](https://docs.teradata.com/r/Enterprise_IntelliFlex_Lake_VMware/Basic-Teradata-Query-Reference-17.20/Introduction-to-BTEQ/BTEQ-Operation-in-the-Client-Server-Environment/BTEQ-Communication)

[TPT](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://quickstarts.teradata.com/tools-and-utilities/run-bulkloads-efficiently-with-teradata-parallel-transporter.html&ved=2ahUKEwjvodTlssGGAxUgUaQEHQLLDTwQFnoECBIQAQ&usg=AOvVaw1lBRZClWMFdRnEst-f-i4L)
