# TP1 - *Correction*

## Partie Requêtes (premières questions)

### Au début, on se connecte

```r
library(RSQLite)
library(ggplot2) # Pour plus tard

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
  GROUP BY CodeCIS, Denomination
  ORDER BY 3 DESC
  LIMIT 10;
           ");
View(df06)
```

### 7 - Pour chaque type de générique, on veut savoir le nombre de médicaments associés, ainsi que leur taux de remboursement moyen et leur prix moyen.

```r
df07 = dbGetQuery(db, "
SELECT Type, 
    COUNT(DISTINCT CodeCIS) AS Nb_medicaments, 
    AVG(Taux) AS Taux_moyen,
    AVG(Prix2) AS Prix_moyen
  FROM CIS_GENER INNER JOIN CIS_CIP USING (CodeCIS)
  GROUP BY Type
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

### 9 - Quels sont les médicaments dont le service médical rendu (ou SMR) est jugé insuffisant ? Indiquez leur taux de remboursement et leur prix, en les classant par prix décroissant.

```r
df09 = dbGetQuery(db, "
SELECT DISTINCT CodeCIS, CodeCIP7, Denomination, Taux, Prix2
  FROM CIS INNER JOIN CIS_HAS_SMR USING (CodeCIS)
           INNER JOIN CIS_CIP USING (CodeCIS)
  WHERE ValeurSMR = 'Insuffisant'
  ORDER BY Prix2 DESC; 
           ");
View(df09)
```

## Questions complémentaires

### 1 - Pour chaque médicament, récupérer la dernière évaluation (dernières valeurs SMR et ASMR obtenues), avec la date

```r
dfb1 = dbGetQuery(db, "
SELECT DISTINCT CIS.CodeCIS, 
    ValeurSMR, CIS_HAS_SMR.DateAvis as DateSMR, 
    ValeurASMR, CIS_HAS_ASMR.DateAvis as DateASMR
  FROM CIS, CIS_HAS_SMR, CIS_HAS_ASMR
  WHERE CIS.CodeCIS = CIS_HAS_SMR.CodeCIS
  AND CIS.CodeCIS = CIS_HAS_ASMR.CodeCIS
  AND CIS_HAS_SMR.CodeHAS = (SELECT CodeHAS 
                              FROM CIS_HAS_SMR 
                              WHERE CodeCIS = CIS.CodeCIS 
                              ORDER BY DateAvis DESC 
                              LIMIT 1)
  AND CIS_HAS_ASMR.CodeHAS = (SELECT CodeHAS 
                                FROM CIS_HAS_ASMR 
                                WHERE CodeCIS = CIS.CodeCIS 
                                ORDER BY DateAvis DESC 
                                LIMIT 1)
  ORDER BY 1, 3 DESC;
           ");
View(dfb1)
```

### 2 - Calculer par année le nombre de médicaments mis sur le marché (et l'afficher dans un graphique)

```r
dfb2 = dbGetQuery(db, "
SELECT strftime('%Y',  DateAMM) AS Annee, COUNT(*) AS Nb_medicaments
  FROM CIS
  GROUP BY strftime('%Y',  DateAMM)
  ORDER BY 1;
           ")
ggplot(dfb2, aes(as.numeric(Annee), Nb_medicaments)) +
  geom_line() +
  theme_minimal() +
  labs(x = "", y = "Médicaments mis sur le marché")
```

### 3 - Faire de même, mais de façon plus fine par mois de chaque année

```r
dfb3 = dbGetQuery(db, "
SELECT strftime('%Y',  DateAMM) AS Annee, strftime('%m',  DateAMM) AS Mois, COUNT(*) AS Nb_medicaments
  FROM CIS
  GROUP BY Annee, Mois
  ORDER BY 1;
           ")
ggplot(dfb3, aes(Annee, Mois, fill = Nb_medicaments)) +
  geom_tile() +
  theme_minimal() +
  labs(x = "", y = "", fill = "Médicaments mis sur le marché") +
  scale_fill_gradient(low = "gray80", high = "red") +
  theme(axis.text.x = element_text(angle = 90))
```

#### Bonus : analyse par mois (quelque soit l'année)

On remarque une prépondérance à la mise sur le marché en juillet 

```r
dfb3bis = dbGetQuery(db, "
SELECT strftime('%m',  DateAMM) AS Mois, COUNT(*) AS NbMed
  FROM CIS
  GROUP BY strftime('%m',  DateAMM)
  ORDER BY 1;
           ")
ggplot(dfb3bis, aes(Mois, NbMed, fill = NbMed)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(x = "", y = "Médicaments mis sur le marché") +
  scale_fill_gradient(low = "gray80", high = "red")
```

### 4 - Calculer le temps entre la date d'AMM et la date de commercialisation pour chaque médicament, et représenter la sous la forme d'un graphique

- Énormément de valeurs négatives : problème dans la base ou AMM réellement arrivée après la vente ?
- Plusieurs médicaments commercialisés longtemps après l'AMM : nouvelle version des médicaments probablement, sans redemande d'AMM

```r
dfb4 = dbGetQuery(db, "
SELECT CodeCIS, DateAMM, DateComm, JULIANDAY(DateComm) - JULIANDAY(DateAMM) AS Duree
  FROM CIS INNER JOIN CIS_CIP USING (CodeCIS);
           ")
dfb4

ggplot(dfb4, aes(x = Duree)) +
  geom_boxplot(fill = "gray70") +
  theme_minimal() +
  labs(x = "", y = "", fill = "Médicaments mis sur le marché")
```

### 5 - Lister les 10 composants les plus présents dans les médicaments

```r
dfb5 = dbGetQuery(db, "
SELECT codesubstance, designation, COUNT(*) as Nb_medicaments
	FROM CIS_COMPO INNER JOIN CIS USING (codecis)
    GROUP BY codesubstance, designation
    ORDER BY 3 DESC
    LIMIT 10;
")
dfb5
```

## A la fin, on se déconnecte !

```r
dbDisconnect(db)
```
