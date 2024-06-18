# Projet NF26 Groupe2

## Description du projet

Projet de la partie 3 de NF26 réalisé avec SMART TEEM en P24.

Ce projet porte sur la mise en place d'une solution décisionnelle (Datawarehouse Teradata et Reporting Power BI)

Nous avons choisi les données portant sur l'établissement de santé.

Le groupe est constitué de Juliette Sacleux, Nesrine Serradj, Eliott Sebbagh, Louise Caignaert, Xavier Lemerle et Camille Bauvais.

## Liens utiles

[Suivi de projet Jira](https://nf26groupe2.atlassian.net/jira/software/projects/SCRUM/boards/1/backlog)

[Slides soutenance](https://www.canva.com/design/DAGIatDK5eQ/3IFqkWeCya4NKvFGBXLdgg/edit)


## Guide d'éxécution

Cloner le repository dans un dossier Desktop/NF26.

### Installation du SID 

Pour créer les bases de données et les tables, éxécuter le fichier install_SID.sh situé dans le dossier installation_scripts.

### Ingestion des données 

Pour alimenter la base de données STG, éxécuter le fichier LAUNCH_LOAD_SID.sh situé dans le dossier alimentation_scripts/INPUT_TO_STG, qui prend en argument le nom du fichier contenant les données à ingérer (de la forme BDD_HOSPITAL_{AnnéeMoisJour}).

###  Alimentation du datawarehouse

Pour alimenter la base de données WRK, éxécuter le fichier insert_staging_to_work.sh situé dans le dossier alimentation_scripts/STG_TO_WORK. 

Pour alimenter la base de données SOC, éxécuter le fichier insert_work_to_soc.sh situé dans le dossier alimentation_scripts/WORK_TO_SOC.

## To Do
- [X] Mettre tous les commentaires soit en français soit en anglais (scripts sh notamment)
- [X] Voir commentaire Miguel sur traitement.sql dans WORK (alimentation)
- [X] formater les scripts sql pour qu'ils aient la même présentation et mettre un petit commentaire par requête SQL quand ce n'est pas fait
- [ ] tester pour tous les jours (test uniquement pour le premier jour chez moi pour le moment)
- [ ] faire slides soutenance
- [ ] si temps faire powerbi

Sur le work to soc (cf excel)
- [X] traitement (testé, OK, mais on doit récupérer medc_id dans R_MEDC,changer le work :  il suffira de faire un select une fois la table R_MEDC opérationnelle, ou alors tout gérer en amont dans le work (mieux je pense) faire le select d'une table work vers une autre),
- [ ]  hospitalisation (testé, OK, mais on doit recuperer stff_id dans la table R_PART (ou depuis work, comme pour traitement)), 
- [ ] consultation (testé, OK, mais on doit récupérer stff_id et patn_id dans la table R_PART (ou depuis work, comme pour traitement)
- [X] consultation on doit remplacer les TRUE par 1 et les FALSE par 0 pour le diabète et l'hospitalisation, cf excel, à faire dans le work)
- [ ] les autres sont à tester, je ne l'ai pas encore fait, mais attention à bien reprendre le excel hopital mapping colonne règle de gestion
Attention, pour les tables en insert, il faut supprimer leur contenu entre deux tests, sinon on insère deux fois les mêmes lignes et ça plante par contrainte d'unicité (cf consultation, hospitalisation...)

- [ ] TESTER 
## Documentation de Terradata

[BTEQ](https://docs.teradata.com/r/Enterprise_IntelliFlex_Lake_VMware/Basic-Teradata-Query-Reference-17.20/Introduction-to-BTEQ/BTEQ-Operation-in-the-Client-Server-Environment/BTEQ-Communication)

[TPT](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://quickstarts.teradata.com/tools-and-utilities/run-bulkloads-efficiently-with-teradata-parallel-transporter.html&ved=2ahUKEwjvodTlssGGAxUgUaQEHQLLDTwQFnoECBIQAQ&usg=AOvVaw1lBRZClWMFdRnEst-f-i4L)
