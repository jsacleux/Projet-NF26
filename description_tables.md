# Description des tables SOC

Explications sur le Primary Index PI (je ne connaissais pas l'abréviation) : [primary_index_teradata](https://www.javatpoint.com/teradata-primary-index)
En gros c'est ce sur quoi on va faire un hash pour trouver quel noeud contient les données (je comprends ça comme ce qu'on a appelé clé de partitionnement sur la partie 2 de NF26)

- Une table des faits contenant toutes les autres clés primaires et ??un nombre?? (cf cours 2 partie 1. Doit-on rajouter un entier ?)
PI ??
- Une table `R_ROOM` qui liste des informations sur les chambres : PK, PI le numéro de la chambre
- Une table `O_TRET` qui liste des informations sur les traitements : PK, PI id du traitement
- Une table `R_PART` id personnel ou patient + fonction (différentes possibilités pour le personnel, 'Patient' pour les patients) : PK : Surrogate Key à partir de (ID_PERSONNEL,FONCTION_PERSONNEL) ou (ID_PATIENT, 'Patient). PI uniquement (ID_PERSONNEL,FONCTION_PERSONNEL) ??
- Une table `O_INDV` qui liste plus d'informations que `R_PART` sur le personnel ou les patients : PK, PI le PART_ID de la table `R_PART`
- Une table `O_STFF` qui liste des informations sur le staff (date de début d'activité (obligatoire), date et raison de fin d'activité (nullable)) : PK, PI le PART_ID de la table `R_PART`
- Une table `O_TELP` qui liste des informations concernant les numéros de téléphones des patients : PK (le PART_ID de la table `R_PART`, Date heure de début de validité), PI le PART_ID de la table `R_PART`
- Une table `O_ADDR` qui liste des informations sur les adresses des patients : PK (le PART_ID de la table `R_PART`, Date heure de début de validité), PI le PART_ID de la table `R_PART`
- Une table `O_CONS` qui listent des informations sur les consultations : PK id de la consult, PI id du patient
- Une table `O_HOSP` qui liste des informations sur les hospitalisations : PK l'id de l'hospitalisation, PI l'id de consultation
- Une table `R_MEDC` qui liste des informations sur les médicaments : PK, PI : Surrogate Key formée à partir de (CD_MEDICAMENT, CATG_MEDICAMENT, MARQUE_FABRI)

# Description des tables TCH 
tables TCH à intégrer dans le modèle physique ?? je pense que oui pusiqu'il y a l'identifiant de l'exécution pour chaque table :

- Une table `T_SUIVI_TRMT`: table de suivi des traitements des requêtes effectuées sur les tables, PK, PI : id_execution (compteur incrémental des scripts)
- Une table `T_SUIVI_TRMT`: table de suivi des traitements des runs : PK, PI : id du run
