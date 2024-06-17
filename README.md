# Projet NF26 Groupe2

## Description

Projet de la partie 3 de NF26 réalisé avec SMART TEEM en P24.

Choix du sujet : Etablissement de santé

Le groupe est constitué de Juliette Sacleux, Nesrine Serradj, Eliott Sebbagh, Louise Caignaert, Xavier Lemerle et Camille Bauvais.

[Suivi de projet Jira](https://nf26groupe2.atlassian.net/jira/software/projects/SCRUM/boards/1/backlog)

## To Do
- [ ] Mettre tous les commentaires soit en français soit en anglais (scripts sh notamment)
- [ ] formater les scripts sql pour qu'ils aient la même présentation et mettre un petit commentaire par requête SQL quand ce n'est pas fait
- [ ] tester pour tous les jours (test uniquement pour le premier jour chez moi pour le moment)
- [ ] faire slides soutenance
- [ ] si temps faire powerbi

Sur le work to soc (cf excel)
- [ ] En l'état fonctionnel pour chambre (testé, RAS), traitement (testé, OK, mais on doit récupérer medc_id dans R_MEDC, donc soit changer le soc soit le work :  il suffira de faire un select une fois la table R_MEDC opérationnelle, ou alors tout gérer en amont dans le work (mieux je pense) et faire le select d'une table work vers une autre), hospitalisation (testé, OK, mais on doit recuperer stff_id dans la table R_PART (ou depuis work, comme pour traitement)), consultation (testé, OK, mais on doit récupérer stff_id et patn_id dans la table R_PART (ou depuis work, comme pour traitement) ET on doit remplacer les TRUE par 1 et les FALSE par 0 pour le diabète et l'hospitalisation, cf excel, à faire dans le work)
- [ ] les autres sont à tester, je ne l'ai pas encore fait, mais attention à bien reprendre le excel hopital mapping colonne règle de gestion
Attention, pour les tables en insert, il faut supprimer leur contenu entre deux tests, sinon on insère deux fois les mêmes lignes et ça plante par contrainte d'unicité (cf consultation, hospitalisation...)
## Documentation de Terradata

[BTEQ](https://docs.teradata.com/r/Enterprise_IntelliFlex_Lake_VMware/Basic-Teradata-Query-Reference-17.20/Introduction-to-BTEQ/BTEQ-Operation-in-the-Client-Server-Environment/BTEQ-Communication)

[TPT](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://quickstarts.teradata.com/tools-and-utilities/run-bulkloads-efficiently-with-teradata-parallel-transporter.html&ved=2ahUKEwjvodTlssGGAxUgUaQEHQLLDTwQFnoECBIQAQ&usg=AOvVaw1lBRZClWMFdRnEst-f-i4L)
