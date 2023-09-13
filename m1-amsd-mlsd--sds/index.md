# Système pour la Data Science

## Master AMSD/MLSD

- [Séance 1](seance1) : Langage système de base
    - [demande](seance1-demande)
- [Séance 2](seance2) : Scripts `shell`
    - [demande](seance2-demande)
- [Séance 3](seance3) : Correction et commentaires sur les scripts `shell`
    - [demande](seance3-demande)
- [Séance 4](seance4) : Gestion des scripts R et Python en `shell`
    - [demande](seance4-demande)

- [Séance 5](seance5) : Mini-projet *Tableaux de bord temps réel*

- [Séance 6](seance6) : Introduction à MongoDB
    - [tutoriel MongoDB - R](seance6-r)
    - [tutoriel MongoDB - Python](seance6-python)
    - [demande](seance6-demande)

- [Projet](projet) : Suite du travail de la séance 5 et rendu final pour évaluation

---

## Machine virtuelle

Vous trouverez ci-dessous le lien de téléchargement d'une machine virtuelle complètement créée et paramètrée (en suivant les différents tutoriels indiqués) :

<https://filesender.renater.fr/?s=download&token=74018a9f-3f0c-4388-bcd9-4cfdb7add1df> (taille d'environ **3Go** - téléchargeable avec le 18 janvier)

Voici comment l'importer dans VirtualBox pour pouvoir l'utiliser :

1. Dans Virtual Box, cliquer sur *Fichier* dans le menu, puis *Importer un appareil virtuel*
1. Choisir le fichier `Serveur Data Science.ova`
1. Cliquer sur *Finish* (ou *Terminer*)
    - l'importation prend un peu de temps
1. Lors de son lancement, vous devrez sûrement avoir un avertissement et une fenêtre pour choisir un autre mode d'accès
    - Choisir donc **Accès par pont** (*Bridged access* ou qqch du genre)

Pour rappel, l'utilisateur est `user` et le mot de passe est `123456`.

<!--
Pitch général :
- Avoir un serveur
- Installer différents outils
    - RStudio Server
    - Shiny server
    - NoSQL type MongoDB
- Lancer en Batch des scripts (Bash, R, Python ou JS) pour récupérer des données 
    - peut-être bien du web-scraping
- Reporting shiny à jour en temps réel


Idées de données :
- http://archive.ics.uci.edu/ml/datasets/Activity+recognition+with+healthy+older+people+using+a+batteryless+wearable+sensor
- http://archive.ics.uci.edu/ml/datasets/UbiqLog+%28smartphone+lifelogging%29
- http://archive.ics.uci.edu/ml/datasets/WISDM+Smartphone+and+Smartwatch+Activity+and+Biometrics+Dataset+


Sources intéressantes :
- https://linux.die.net/man/1/rscript
- https://www.techtarget.com/searchwindowsserver/definition/command-line-interface-CLI#:~:text=A%20command%2Dline%20interface%20(CLI)%20is%20a%20text%2D,interfaces%20and%20character%20user%20interfaces.
- https://connect.ed-diamond.com/GNU-Linux-Magazine/glmf-131/awk-le-langage-script-de-reference-pour-le-traitement-de-fichiers

https://linux.goffinet.org/administration/scripts-shell/

Idées de trucs à faire :
- commande awk ?
- création de comptes linux
- lancement récurrent de scripts
- scripts R :
    - Rscript
    - R CMD BATCH
    - Paramètres
    - attention : utilisation de --no-restore
- scripts Python ??


Machine virtuelle :
- VirtualBox : https://www.virtualbox.org/
- Ubuntu : https://www.ubuntu-fr.org/download/

-->
