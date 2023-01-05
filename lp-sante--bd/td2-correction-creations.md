# Modèle relationnel et SQL

## Ecrire les requêtes SQL permettant de créer les tables de ce MRD

- VILLE (<ins>CodeVille</ins>, ANomVille, MNomVille)
```
CREATE TABLE VILLE (
    CodeVille INT NOT NULL PRIMARY KEY,
    ANomVille VARCHAR2(100),
    MNomVille VARCHAR2(100)
);
```

- MUSEE (<ins>CodeMusee</ins>, NomMusee, #CodeVille)
```
CREATE TABLE MUSEE (
    CodeMusee INT NOT NULL PRIMARY KEY,
    NomMusee VARCHAR2(100),
    CodeVille INT REFERENCES VILLE
);
```
ou
```
CREATE TABLE MUSEE (
    CodeMusee INT NOT NULL PRIMARY KEY,
    NomMusee VARCHAR2(100),
    CodeVille INT,
    FOREIGN KEY (CodeVille) REFERENCES VILLE
);
```

- SITE (<ins>CodeSite</ins>, DesSite, CivSite)
```
CREATE TABLE SITE (
    CodeSite INT NOT NULL PRIMARY KEY,
    DesSite VARCHAR2(100),
    CivSite VARCHAR2(100)
);
```

- OBJET (<ins>NumObj</ins>, DesObj, TypeObj, DateObj, #CodeMusee, #CodeSite)
```
CREATE TABLE OBJET (
    NumObj INT NOT NULL PRIMARY KEY,
    DesObj VARCHAR2(100),
    TypeObj VARCHAR2(50),
    DateObj DATE,
    CodeMusee INT REFERENCES MUSEE,
    CodeSite INT REFERENCES SITE
);
```

- AUTEUR (<ins>NumAuteur</ins>, NomAuteur, PrenomAuteur)
```
CREATE TABLE AUTEUR (
    NumAuteur INT NOT NULL PRIMARY KEY,
    NomAuteur VARCHAR2(50),
    PrenomAuteur VARCHAR2(50)
);
```

- EDITEUR (<ins>NumEdi</ins>, DesEdi)
```
CREATE TABLE EDITEUR (
    NumEdi INT NOT NULL PRIMARY KEY,
    DesEdi VARCHAR2(100)
);
```

- OUVRAGE (<ins>NumOuv</ins>, TitreOuv, #NumEdi)
```
CREATE TABLE OUVRAGE (
    NumOuv INT NOT NULL PRIMARY KEY,
    TitreOuv VARCHAR2(100),
    NumEdi INT REFERENCES EDITEUR,
    DateEdi DATE
);
```

- SITUATION (<ins>#CodeVille, #CodeSite</ins>)
```
CREATE TABLE SITUATION (
    CodeVille INT NOT NULL REFERENCES VILLE,
    CodeSite INT NOT NULL REFERENCES SITE,
    PRIMARY KEY (CodeVille, CodeSite)
);
```

- EXPOSITION (<ins>#NumObj, #CodeMusee, DateDeb</ins>, DateFin)
```
CREATE TABLE EXPOSITION (
    NumObj INT NOT NULL REFERENCES OBJET,
    CodeMusee INT NOT NULL REFERENCES MUSEE,
    DateDeb DATE NOT NULL,
    DateFin DATE,
    PRIMARY KEY (NumObj, CodeMusee, DateDeb)
);
```

- REFOBJET (<ins>#NumOuv, #NumObj</ins>)
```
CREATE TABLE REFOBJET (
    NumOuv INT NOT NULL REFERENCES OUVRAGE,
    NumObj INT NOT NULL REFERENCES OBJET,
    PRIMARY KEY (NumOuv, NumObj)
);
```

- REFSITE (<ins>#NumOuv, #CodeSite</ins>)
```
CREATE TABLE REFSITE (
    NumOuv INT NOT NULL REFERENCES OUVRAGE,
    CodeSite INT NOT NULL REFERENCES SITE,
    PRIMARY KEY (NumOuv, CodeSite)
);
```

- ECRITURE (<ins>#NumAuteur, #NumOuv</ins>)
```
CREATE TABLE ECRITURE (
    NumAuteur INT NOT NULL REFERENCES AUTEUR,
    NumOuv INT NOT NULL REFERENCES OUVRAGE,
    PRIMARY KEY (NumAuteur, NumOuv)
);
```


