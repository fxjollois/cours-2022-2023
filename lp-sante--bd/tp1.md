# Langage SQL

Dans ce TP, nous allons utilier la [base de données publique des médicaments](https://base-donnees-publique.medicaments.gouv.fr/). Dans la page Téléchargement (lien situé tout en bas du site), vous trouverez les liens vers un fichier explicatif (en PDF) et les fichiers de données (au format texte). 

## Librairie `RSQLite` sous `R`

L'utilisation conjointe de la librairie [`DBI`](https://dbi.r-dbi.org/) et de la librairie [`RSQLite`](https://cran.r-project.org/web/packages/RSQLite/vignettes/RSQLite.html) permet de se connecter à une base de données au format [`SQLite`](https://www.sqlite.org/index.html) dans `R`. Vous trouverez sur [cette page](https://db.rstudio.com/databases/sqlite/) un certain nombre d'informations utiles. Voici ce qu'il faut en retenir pour la réalisation de ce TP.

> L'ensemble des commandes vues ici sont réutilisables pour se connecter à un autre SGBD que `SQLite`, en utilisant d'autres drivers (comme [`ODBC`](https://db.rstudio.com/databases/oracle/) - connecteur universel).

| Fonction | Utilité | Paramètres et retour |
|-|-|-|
| **`dbConnect()`** | Création d'une base de données | Driver (ici : `RSQLite::SQLite()`) <br> Nom du fichier ou `":memory:"`<br> Renvoie un connecteur à garder dans une variable |
| **`dbDisconnect()`** | Déconnexion propre | |
| **`dbListTables()`** | Liste des tables | |
| **`dbExecute()`** | Exécution d'une requête autre que `SELECT` | Connecteur à la BD<br> Requête dans une chaîne de caractères<br> Renvoie un code d'erreur |
| **`dbGetQuery()`** | Exécution d'une requête `SELECT` | Connecteur à la BD<br> Requête dans une chaîne de caractères<br> Renvoie le résultat de la requête dans un data.frame |

## Demande

A partir du modèle de la base et des fichiers de données fournies, nous allons recréer la BD médicaments.

1. Télécharger les 9 fichiers de données
    - les placer idéalement dans un répertoire dédié.
2. Créer la base de données
3. Créer les tables et les renseigner (i.e. mettre les valeurs dedans)
    - les taux et les prix sont dans au format chaîne de caractères (resp. "xx %" et "xx,xx") et donc à modifier avant importation. 
    - les voies d'administration sont listées dans une seule variable, et séparées par des “;” (par exemple "cutanée;orale;sublinguale"). Il faut donc ici aussi faire une nouvelle table "VoieAdministration" et insérer les données correctement.
4. Répondre aux demandes suivantes :
    - Combien de médicaments sont dans la BD ?
    - Combien de génériques ?
    - Donner les différents types de génériques.
    - Lister les médicaments pour lesquelles il y a une *surveillance renforcée*
    - Donner les 10 médicaments ayant les présentations les plus onéreuses 
    - Quels sont les dix médicaments avec le plus de composants (Code CIS, Dénomination et nombre de composants) ?
    - Pour chaque type de générique, on veut savoir le nombre de médicaments associés, ainsi que leur taux de remboursement moyen et leur prix moyen.
    - Quelles sont les voies d'administration possibles ? Et combien de médicaments sont concernés pour chaque voie ?
    - Quels sont les médicaments dont le service médical rendu (ou SMR) est jugé insuffisant ? Indiquez leur taux de remboursement et leur prix, en les classant par prix décroissant.
5. Questions complémentaires
  - Pour chaque médicament, récupérer la dernière évaluation (dernières valeurs SMR et ASMR obtenues), avec la date
  - Calculer par année le nombre de médicaments mis sur le marché (et l'afficher dans un graphique)
  - Faire de même, mais de façon plus fine par mois de chaque année
  - Calculer le temps entre la date d'AMM et la date de commercialisation pour chaque médicament, et représenter la sous la forme d'un graphique
  - Lister les 10 composants les plus présents dans les médicaments

    
## Réalisation pour la première table `CIS`

On commence par charger les librairies utiles

```r
library(RSQLite)
library(readr)
```

### Création de la base de données 

Comme le fichier est inexistant au départ, la base est créée. En SQLite, une base de données est égale à un fichier (généralement avec l'extension `.sqlite`).

```r
db = dbConnect(SQLite(), "bdpm_2023-01-06.sqlite")
```

On peut lister directement les tables présentes dans la base (vide pour le moment)

```r
dbListTables(db)
```

### Visualisation des premières lignes de `CIS_bdpm.txt`

Pour être sûr du type de chaque variable (entier, texte ou date), on peut vérifier en regardant les premières lignes du fichier directement dans R. Le fichier texte étant assez gros (plus de 3 Mo), il n'est pas judicieux de l'ouvrir directement.

```r
read_lines("CIS_bdpm.txt", n_max = 10)
```

On remarque que le séparateur est une tabulation (`"\t"`). On peut ainsi aller plus loin en découpant les chaînes pour mieux voir chaque valeur.

```r
strsplit(read_lines("CIS_bdpm.txt", n_max = 10), "\t")
```

### Création de la table CIS

Une fois qu'on est certain de nos types de variable, nous créons la table en SQL. On a aussi identifié (dans le document PDF de la base, sur le site) que `CodeCIS` était la clé primaire de cette table.

```r
dbExecute(db, "
CREATE TABLE CIS (
  CodeCIS INT NOT NULL PRIMARY KEY,
  Denomination TEXT,
  FormePharma TEXT,
  VoiesAdm TEXT,
  StatutAMM TEXT,
  ProcedureAMM TEXT,
  EtatComm TEXT,
  DateAMM DATE,
  StatutBdm TEXT,
  NumAutorEuro TEXT,
  Titulaires TEXT,
  Surveillance TEXT
);
")
```

On peut vérifier que la table a bien été créée dans la base.

```r
dbListTables(db)
```

Mais bien évidemment, cette table est vide pour le moment.

```r
dbGetQuery(db, "SELECT * FROM CIS;")
```

#### Suppression d'une table

Si, dans vos essais, vous vous apercevez que vous avez fait une erreur dans la création de la table, vous devez la supprimer pour la re-créer. Pour cela, vous avez deux options : `DROP TABLE` en SQL ou `dbRemoveTable()`.

```r
dbExecute(db, "DROP TABLE CIS;")
dbRemoveTable(db, "CIS")
```

### Chargement des données présentes dans le fichier

Maintenant, nous allons récupérer les données à mettre dans la table, à partir du fichier `CIS_bdpm.txt`.

```r
don = read_delim("CIS_bdpm.txt", col_names = F, locale = readr::locale(encoding = "latin1"))
```

On peut mettre les mêmes noms de variables que la table `CIS` pour plus de facilité lors de la manipulation.

```r
names(don) = dbListFields(db, "CIS")
```

#### Modification du type de la variable `DateAMM` 

La variable `DateAMM` du data.frame `don` est dans un format `jj/mm/aaaa`, ce qui ne correspond pas au format SQL. Il faut donc le modifier car il est primordial que le format de la variable correspondre au format DATE de SQL. Celui-ci est typiquement `aaaa-mm-jj`, et en mode chaîne de caractères. Sans cette étape, il ne sera pas possible de faire des requêtes sur les dates en SQL. 

```r
don = transform(don, DateAMM = as.character(as.Date(DateAMM, "%d/%m/%Y")))
```

### Insertion des valeurs du data.frame don dans la table `CIS` de la BD

Maintenant que nous avons les données dans un data.frame (`don`), nous pouvons les insérer dans la table `CIS` comme ceci :

```r
dbAppendTable(db, "CIS", don)
```

Afin de vérifier que le chargement s'est correctement passé, nous pouvons requêter pour avoir les 10 premières lignes par exemple.

```r
dbGetQuery(db, "SELECT * FROM CIS LIMIT 10;")
```

#### Suppression des valeurs dans une table

Si vous rencontrez des soucis dans le chargement des données, vous devez parfois supprimer le contenu d'une table. Pour cela, plutôt que de la supprimer et de la recréer, vous pouvez aussi seulement supprimer toutes les lignes, avec `DELETE` en SQL.

```r
dbExecute(db, "DELETE FROM CIS;")
```

### Déconnexion à la base de données (important à faire dans un environnement pro)

Lors de l'utilisation d'une connexion à une base de données (que ce soit SQLite ou autre système), il est très important de se déconnecter en fin d'utilisation.

```r
dbDisconnect(db)
```
