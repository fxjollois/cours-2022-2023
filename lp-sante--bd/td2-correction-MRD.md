# Modèle relationnel et SQL


## Ecrire le MRD à partir du MCD

- VILLE (<ins>CodeVille</ins>, ANomVille, MNomVille)
- MUSEE (<ins>CodeMusee</ins>, NomMusee, #CodeVille)
- SITE (<ins>CodeSite</ins>, DesSite, CivSite)
- OBJET (<ins>NumObj</ins>, DesObj, TypeObj, #CodeMusee, #CodeSite)
- EDITEUR (<ins>NumEdi</ins>, DesEdi)
- OUVRAGE (<ins>NumOuv</ins>, TitreOuv, #NumEdi, DateEdi)
- AUTEUR (<ins>NumAuteur</ins>, NomAuteur, PrenomAuteur)

- SITUATION (<ins>#CodeSite, #CodeVille</ins>)
- EXPOSITION (<ins>#NumObj, #CodeMusee, DateDeb</ins>, DateFin)
- REFSITE (<ins>#NumOuv, #CodeSite</ins>)
- REFOBJET (<ins>#NumOuv, #NumObj</ins>)
- ECRITURE (<ins>#NumOuv, #NumAuteur</ins>)
