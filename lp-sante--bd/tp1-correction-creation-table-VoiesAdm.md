# TP1 - *Correction*

## Partie Création de la table `VoiesAdm`

Dans ce script, qui repart de la base déjà créée donc, nous avons 2 possibilités pour séparer les voies d'administration. Voici ce que réalise ce code, étape par étape :

1. Connexion à la base de données déjà créée
2. Création en SQL de la table `VoiesAdm`
3. Récupération des 2 colonnes `CodeCIS` et `VoiesAdm` dans la table `CIS`
4. Récupération des codes dans une variable `CodeCIS`
5. Séparation des voies d'administration, stockées dans une liste `Voies`
6. 2 options pour remplir la table
    1. Utilisation d'une double boucle `for`
        - La deuxième boucle permet de naviguer dans les voies d'administration s'il y a plusieurs valeurs
        - Ce code est assez lent, à cause des boucles
    2. Utilisation des fonctions `Reduce` et `mapply`, dédiées au travail sur les listes
        - Le `DELETE` fait avant est la pour supprimer les lignes faites avec l'option précédente
7. Déconnexion de la base de données

```r
library(RSQLite)
library(readr)

db = dbConnect(SQLite(), "bdpm_2023-01-06.sqlite")

dbExecute(db, "
CREATE TABLE VoiesAdm (
  CodeCIS INT NOT NULL REFERENCES CIS,
  Voie TEXT NOT NULL,
  PRIMARY KEY (CodeCIS, Voie)
);
           ")

df = dbGetQuery(db, "SELECT CodeCIS, VoiesAdm FROM CIS;")
CodeCIS = df$CodeCIS
Voies = strsplit(df$VoiesAdm, ";")

# Première option, avec une boucle -> LENT car R est lent avec les boucles
for (i in 1:nrow(df)) {
  for (j in 1:length(Voies[[i]])) {
    dbExecute(db, 
              sprintf("INSERT INTO VoiesAdm VALUES (%s, '%s');",
                      CodeCIS[i],
                      Voies[[i]][j]))
  }
}

# Deuxième option : manipulation en R puis insertion dans la table

dbExecute(db, "DELETE FROM VoiesAdm;")

df2 = Reduce(
  rbind, 
  mapply(
    function (c, v) {
      return (data.frame(CodeCIS = c, Voie = v))
    }, 
    CodeCIS, Voies, SIMPLIFY = FALSE)
)
dbAppendTable(db, "VoiesAdm", df2)

dbDisconnect(db)
```