# Rattrapage Babacar LO

### Lundi 19 Juin – 14h

## Partie I : Bases de données (noté sur 20 points)

Après une analyse du fonctionnement d'un fédération sportive organisant des compétitions de soule, nous avons établi le Modèle Relationnel des Données (MRD) suivant :

```
- COMPETITION(NumComp, Intitule, DateComp, Organisateur, Ville, Pays)
- EQUIPE(NumEq, NomEq, Ville, Pays)
- JOUEUR(NumJou, Nom, Prenom, Age, Adresse, Ville, Pays)
- PARTICIPATION(#NumEq, #NumJou)
- EPREUVE(NumEpr, #NumComp, Niveau, DateEpr, Lieu, Duree, NumEq1, NumEq2, Score1, Score2)
```

### Créer les tables précédentes en SQL (5 points)

### Donner le code SQL permettant de fournir les informations suivantes (15 points)

1. Durée moyenne des épreuves de niveau 2 (1 point)
2. Noms des équipes étrangères ayant joué en France (1 point)
3. Pays ayant organisés depuis 1984 les compétitions intitulées "TFI" (1 point)
4. Noms des équipes ayant participé à la compétition "TNF" (2 points)
5. Noms des joueurs n'ayant jamais joué dans l'équipe "Gaulois de Paris" (2 points)
6. Le nom de la ville dans laquelle s'est déroulée la plus longue épreuve, supposée unique (2 points)
7. Pour chaque équipe, l'âge moyen de ses joueurs (2 points)
8. Pour chaque lieu, la durée moyenne des épreuves qui s'y sont déroulées, à condition qu'il y ait eu au moins deux épreuves disputées dans ce lieu (2 points)
9. Liste des équipes ayant toujours gagnées les compétitions auxquelles elles ont participées – elles auront donc gagné toutes leurs épreuves (2 points)


## Partie II : Tableaux de bord (noté aussi sur 20 points)

### Données

Voici quelques informations sur les [données fournies](donnees_co2.xlsx) (émission de CO2 jusqu’à 2015 – adresse : ) :

- Indicateur principal : Émissions de CO2 (kt)
- Indicateurs cumulables :
    - Émissions de CO2 attribuables à d’autres secteurs, hormis construction résidentielle et services commerciaux et publics (% de la combustion totale de carburants)
    - Émissions de CO2 attribuables à la production d’électricité et de chaleur (% de la combustion totale de carburants)
    - Émissions de CO2 attribuables au transport (% de la combustion totale de carburants)
    - Émissions de CO2 attribuables aux bâtiments résidentiels et aux services commerciaux et publics (% de la combustion totale de carburants)
    - Émissions de CO2 attribuables aux industries manufacturières et à la construction (% de la combustion totale de carburants)

Pour les cartes, il est préférable de la produire avec la variable `Country.Code` et d'ajouter `Country.Name` dans la fenêtre d’informations.

### Demande

A partir des données fournies, vous devez faire le travail suivant :

- Une feuille par demande
    - Tableau global sur l'indicateur principal : moyenne, médiane, minimum, maximum, par pays, classé par ordre décroissant de la moyenne de l'indicateur principal
    - Evolution de l'indicateur principal sur la période 1960-2011, avec le choix du pays représenté (choix unique à prévoir - ce sera la France représentée par défaut)
    - Evolution des indicateurs cumulables sur la période 1960-2011, avec le choix du pays (idem que dans 3)
    - Carte des pays avec une couleur en fonction d'un des indicateurs cumulables, avec le choix par l'utilisateur de l'indicateur représenté ainsi que de l'année
- Une histoire avec une vue pour chaque demande

### Rendu

Envoyer le fichier créé sauvegardé en tant que classeur complet (**`.twbx`**) à : 

> `francois-xavier.jollois@u-paris.fr`