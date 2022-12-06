# Système pour la Data Science

## Master AMSD/MLSD

### Mini-projet *Tableaux de bord temps réel*

#### Compléments et rendu

## Rendu

L'évaluation final aura donc lieu sous la forme d'un projet, que vous devez rendre pour fin décembre (**31 décembre, 23h59 dernier délai**). Vous devrez déposer un fichier compressé, contenant les différents fichiers et avec vos noms de famille dans le nom du fichier, à cette adresse de dépôt :

<https://cloud.parisdescartes.fr/index.php/s/admXLzBn4N4b8w9>

## Sujet

A partir du travail que vous avez initié lors de la [séance 5](seance5) (ou autre si vous le souhaitez), vous devez réaliser un tableau de bord, à l'aide d'une technologie au choix (type [Shiny](https://shiny.rstudio.com/), mais d'autres sont possibles si vous vous sentez plus à l'aise avec), sur des données récupérées via API et stockées dans une base de données Mongo.

### Contraintes

- Données récupérées régulièrement (à l'aide d'une tâche `cron`) 
    - via API
    - régularité au choix et période d'analyse au choix
- Stockage des données dans une BD Mongo
    - importation des données dans Mongo à faire au choix (via `mongoimport` ou via script R/Python/autre)

### Idée conductrice

Le but du projet est surtout de vous faire travailler sur la récupération de données et le stockage, moins sur la partie restitution. Celle-ci peut éventuellement être schématiser (*i.e* réflexion commentée sur ce qui doit être affiché - tableaux et/ou graphiques, KPI, ...)

### Contenu du fichier `zip`

- Ensemble des scripts bash, R et/ou Python (et autres) nécessaires à la réalisation de votre tableau de bord
- Document présentant la problèmatique, les données et votre travail
    - Problématique choisie
    - Sources de données (ainsi que leur modèle)
        - Comment sont structurées les sources ? Qu'est-ce qu'il y a dedans comme informations ?
        - Comment y a t'on accès ? 
        - Quelle périodicité faut-il prévoir pour les récupérer ?
        - Qu'ont-elles en commun éventuellement ? (hormis les aspects date et zone géographique)
        - Est-il possible de les ré-utiliser librement ou non ?
    - Tâches `cron` mises en place pour la récupération des données
    - Tableau de bord
        - Aspect visuel (schématiquement)
        - Graphiques et/ou tableaux prévus
        - Un seul ou plusieurs onglets ?
        - ...
- Captures d'écran et autres, si vous avez réussi à mettre en place votre tableau de bord


