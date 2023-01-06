# TP1 - *Correction*

## Partie Création de la base de données

Le script ci-dessous réalise les étapes suivantes :

1. Connexion à la base de données
    - Si le fichier existe déjà, il est supprimé pour repartir d'une base de données vide
2. Création de toutes les tables
    - Avec pour chaque table, les étapes
        1. Création de la table SQL
        2. Importation des données du fichier texte en R, dans un data.frame
        3. Renommage des variables avec le nom des colonnes de la table SQL
        4. Si besoin, modification de certaines colonnes
        5. Ajout des valeurs du data.frame dans la table SQL
    - Ordre de création (car références présentes)
        1. `CIS`
        2. `CIS_CIP` (avec référence à `CIS`)
        3. `CIS_COMPO` (avec référence à `CIS`)
        4. `CIS_CPD` (avec référence à `CIS`)
        5. `CIS_GENER` (avec référence à `CIS`)
        6. `HAS_Liens`
        7. `CIS_HAS_ASMR` (avec référence à `CIS` et `HAS_liens`)
        8. `CIS_HAS_SMR` (avec référence à `CIS` et `HAS_Liens`)
        9. `CIS_Infos` (avec référence à `CIS`)
3. Déconnexion à la base de données
4. Suppression des variables utilisées dans le script (`don` et `db`)

Il est important de noter les points suivants :

- Option `show_col_type = FALSE` ajouté pour ne pas voir la liste des colonnes lors de l'importation des données
- Option `delim = "\t"` ajouté afin d'être sûr que ce code puisse être ré-utilisé sans problème
-  Toutes les étapes de vérifications et/ou de tests (comme l'affichage du contenu des fichiers) ont été supprimé

> L'idée est que ce script soit exécutable directement (avec la fonction `source()`) pour la création de la base de données une prochaine fois. Il est important d'écrire des scripts propres de ce type lorsqu'on est dans un environnement professionnel.

```r
library(RSQLite)
library(readr)

if (file.exists("bdpm_2023-01-06.sqlite"))
  file.remove("bdpm_2023-01-06.sqlite")
db = dbConnect(SQLite(), "bdpm_2023-01-06.sqlite")

#---------------------------- CIS

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

don = read_delim("CIS_bdpm.txt", 
                 col_names = F, 
                 delim = "\t",
                 locale = readr::locale(encoding = "latin1"),
                 show_col_types = FALSE)
names(don) = dbListFields(db, "CIS")
don = transform(don, DateAMM = as.character(as.Date(DateAMM, "%d/%m/%Y")))

dbAppendTable(db, "CIS", don)



#---------------------------- CIS_CIP

dbExecute(db, "
CREATE TABLE CIS_CIP (
  CodeCIS INT NOT NULL REFERENCES CIS,
  CodeCIP7 INT NOT NULL,
  Libelle TEXT,
  StatutAdm TEXT,
  EtatComm TEXT,
  DateComm DATE,
  CodeCIP13 INT,
  Agrement TEXT,
  Taux INT,
  Prix1 NUMBER,
  Prix2 NUMBER,
  Prix3 NUMBER,
  Indication TEXT,
  PRIMARY KEY (CodeCIS, CodeCIP7)
);
")

don = read_delim("CIS_CIP_bdpm.txt", 
                 col_names = F, 
                 delim = "\t",
                 locale = readr::locale(encoding = "latin1"),
                 show_col_types = FALSE)
names(don) = dbListFields(db, "CIS_CIP")
don = transform(don, 
                DateComm = as.character(as.Date(DateComm, "%d/%m/%Y")),
                Taux = as.numeric(sub("%", "", Taux)),
                Prix1 = as.numeric(sub(",", ".", Prix1)),
                Prix2 = as.numeric(sub(",", ".", Prix2)) / 100,
                Prix3 = as.numeric(sub(",", ".", Prix3)))

dbAppendTable(db, "CIS_CIP", don)


#---------------------------- CIS_COMPO

dbExecute(db, "
CREATE TABLE CIS_COMPO (
  CodeCIS INT NOT NULL REFERENCES CIS,
  Designation TEXT NOT NULL,
  CodeSubstance INT NOT NULL,
  DenomSub TEXT,
  Dosage TEXT,
  Reference TEXT,
  Nature TEXT,
  NumLien INT,
  PRIMARY KEY (CodeCIS, Designation, CodeSubstance, NumLien)
);
")

don = read_delim("CIS_COMPO_bdpm.txt", 
                 col_names = F, 
                 delim = "\t",
                 locale = readr::locale(encoding = "latin1"),
                 show_col_types = FALSE)
don$X9 = NULL # dernière colonne vide
names(don) = dbListFields(db, "CIS_COMPO")

dbAppendTable(db, "CIS_COMPO", don)


#---------------------------- CIS_CPD

dbExecute(db, "
CREATE TABLE CIS_CPD (
  CodeCIS INT NOT NULL REFERENCES CIS,
  Condition TEXT,
  PRIMARY KEY (CodeCIS, Condition)
);
")

don = read_delim("CIS_CPD_bdpm.txt", 
                 col_names = F, 
                 delim = "\t",
                 locale = readr::locale(encoding = "latin1"),
                 show_col_types = FALSE)
names(don) = dbListFields(db, "CIS_CPD")

dbAppendTable(db, "CIS_CPD", don)

#---------------------------- CIS_GENER

dbExecute(db, "
CREATE TABLE CIS_GENER (
  IdGroupe INT NOT NULL,
  LibGroupe TEXT,
  CodeCIS INT NOT NULL REFERENCES CIS,
  Type INT,
  NumTri INT,
  PRIMARY KEY (IdGroupe, CodeCIS)
);
")

don = read_delim("CIS_GENER_bdpm.txt", 
                 col_names = F, 
                 delim = "\t",
                 locale = readr::locale(encoding = "latin1"),
                 show_col_types = FALSE)
don$X6 = NULL
names(don) = dbListFields(db, "CIS_GENER")

dbAppendTable(db, "CIS_GENER", don)

#---------------------------- HAS_Liens

dbExecute(db, "
CREATE TABLE HAS_Liens (
  CodeHAS INT NOT NULL,
  Lien TEXT,
  PRIMARY KEY (CodeHAS, Lien)
);
")

don = read_delim("HAS_LiensPageCT_bdpm.txt", 
                 col_names = F, 
                 delim = "\t",
                 locale = readr::locale(encoding = "latin1"),
                 show_col_types = FALSE)
names(don) = dbListFields(db, "HAS_Liens")

dbAppendTable(db, "HAS_Liens", don)


#---------------------------- CIS_HAS_ASMR

dbExecute(db, "
CREATE TABLE CIS_HAS_ASMR (
  CodeCIS INT NOT NULL REFERENCES CIS,
  CodeHAS TEXT NOT NULL REFERENCES HAS_Liens,
  Motif TEXT,
  DateAvis DATE,
  ValeurASMR TEXT,
  LibelleASMR TEXT,
  PRIMARY KEY (CodeCIS, CodeHAS, ValeurASMR, LibelleASMR)
);
")

don = read_delim("CIS_HAS_ASMR_bdpm.txt", 
                 col_names = F, 
                 delim = "\t",
                 locale = readr::locale(encoding = "latin1"),
                 show_col_types = FALSE)
names(don) = dbListFields(db, "CIS_HAS_ASMR")
don = transform(don, DateAvis = as.character(as.Date(as.character(DateAvis), "%Y%m%d")))

dbAppendTable(db, "CIS_HAS_ASMR", don)

#---------------------------- CIS_HAS_SMR

dbExecute(db, "
CREATE TABLE CIS_HAS_SMR (
  CodeCIS INT NOT NULL REFERENCES CIS,
  CodeHAS TEXT NOT NULL REFERENCES HAS_Liens,
  Motif TEXT,
  DateAvis DATE,
  ValeurSMR TEXT,
  LibelleSMR TEXT,
  PRIMARY KEY (CodeCIS, CodeHAS, ValeurSMR, LibelleSMR)
);
")

don = read_delim("CIS_HAS_SMR_bdpm.txt", 
                 col_names = F, 
                 delim = "\t",
                 locale = readr::locale(encoding = "latin1"),
                 show_col_types = FALSE)
names(don) = dbListFields(db, "CIS_HAS_SMR")
don = transform(don, DateAvis = as.character(as.Date(as.character(DateAvis), "%Y%m%d")))

dbAppendTable(db, "CIS_HAS_SMR", don)

#---------------------------- CIS_Infos

dbExecute(db, "
CREATE TABLE CIS_Infos (
  CodeCIS INT NOT NULL REFERENCES CIS,
  DateDeb DATE NOT NULL,
  DateFin DATE,
  Texte TEXT,
  PRIMARY KEY (CodeCIS, DateDeb, Texte)
);
")

don = read_delim("CIS_InfoImportantes_20230105122631_bdpm.txt", 
                 col_names = F, 
                 delim = "\t",
                 locale = readr::locale(encoding = "latin1"),
                 show_col_types = FALSE)
names(don) = dbListFields(db, "CIS_Infos")
don = transform(don, 
                DateDeb = as.character(DateDeb),
                DateFin = as.character(DateFin))
dbAppendTable(db, "CIS_Infos", don)


dbDisconnect(db)
rm(don, db)
```

