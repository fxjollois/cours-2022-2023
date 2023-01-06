# TP1 - *Correction*

## Partie Requêtes

### Au début, on se connecte

```r
library(RSQLite)

db = dbConnect(SQLite(), "bdpm_2023-01-06.sqlite")
```

### 1 - Combien de médicaments sont dans la BD ?

```r
df01 = dbGetQuery(db, "
SELECT COUNT(*) AS Nb_medicaments
  FROM CIS;
           ");
df01
```

### 2 - Combien de génériques ?

```r
df02 = dbGetQuery(db, "
SELECT COUNT(*) AS Nb_génériques
  FROM CIS_GENER;
           ");
df02
```

### 3 - Donner les différents types de génériques.

```r
df03 = dbGetQuery(db, "
SELECT DISTINCT Type AS Type_génériques
  FROM CIS_GENER;
           ");
df03
```

### 4 - Lister les médicaments pour lesquelles il y a une surveillance renforcée

```r
df04 = dbGetQuery(db, "
SELECT CodeCIS, Denomination
  FROM CIS
  WHERE Surveillance LIKE 'oui';
           ");
View(df04)
```

### 5 - Donner les 10 médicaments ayant les présentations les plus onéreuses

```r
df05 = dbGetQuery(db, "
SELECT CodeCIS, CodeCIP7, Denomination, Prix1, Prix2, Prix3
  FROM CIS_CIP INNER JOIN CIS USING ('CodeCIS')
  ORDER BY Prix2 DESC
  LIMIT 10;
           ");
View(df05)
```

### 6 - Quels sont les dix médicaments avec le plus de composants (Code CIS, Dénomination et nombre de composants) ?

```r
df06 = dbGetQuery(db, "
SELECT CodeCIS, Denomination, COUNT(*) AS Nb_composants
  FROM CIS INNER JOIN CIS_COMPO USING (CodeCIS)
  GROUP BY CodeCIS
  ORDER BY 3 DESC
  LIMIT 10;
           ");
View(df06)
```

### 7 - Pour chaque type de générique, on veut savoir le nombre de médicaments associés, ainsi que leur taux de remboursement moyen et leur prix moyen.

```r
df07 = df = dbGetQuery(db, "
SELECT LibGroupe, 
    COUNT(DISTINCT CodeCIS) AS Nb_medicaments, 
    AVG(Taux) AS Taux_moyen,
    AVG(Prix2) AS Prix_moyen
  FROM CIS_GENER INNER JOIN CIS USING (CodeCIS)
                 INNER JOIN CIS_CIP USING (CodeCIS)
  GROUP BY LibGroupe
  ORDER BY 4 DESC;
           ");
View(df07)
```

### 8 - Quelles sont les voies d'administration possibles ? Et combien de médicaments sont concernés pour chaque voie ?

```r
df08 = dbGetQuery(db, "
SELECT Voie, COUNT(*) AS Nb_medicaments
  FROM VoiesAdm
  GROUP BY Voie
  ORDER BY 2 DESC;
           ");
View(df08)
```

### 9 - Quels sont les médicaments dont le service médical rendu (ou SMR) est jugé insuffisant ? Indiquez leur taux de remboursement et leur prix, en les 
```r
classant par prix décroissant.
df09 = dbGetQuery(db, "
SELECT DISTINCT CodeCIS, CodeCIP7, Denomination, Taux, Prix2
  FROM CIS INNER JOIN CIS_HAS_SMR USING (CodeCIS)
           INNER JOIN CIS_CIP USING (CodeCIS)
  WHERE ValeurSMR = 'Insuffisant'
  ORDER BY Prix2 DESC; 
           ");
View(df09)
```

## A la fin, on se déconnecte !

```r
dbDisconnect(db)
```
