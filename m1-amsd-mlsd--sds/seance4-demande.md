# Système pour la Data Science

## Master AMSD/MLSD

### Gestion des scripts R et Python en `shell`

#### Demande à réaliser

## Mettre à jour votre machine virtuelle

La dernière commande est pour être sûr que tout est OK.

```bash
$ sudo apt update
$ sudo apt upgrade
$ sudo apt update
```

## Installer `mailutils`

Pour pouvoir recevoir des messages envoyés par `cron`

```bash
$ sudo apt install mailutils
```

## Installer les outils de travail

- Installer R si ce n'est pas encore fait
    - [lien vers la procédure officielle](https://cloud.r-project.org/bin/linux/ubuntu/)
    
- Installer RStudio Server
    - [lien vers la procédure officielle](https://posit.co/download/rstudio-server/)
    - [autre aide](https://www.r-bloggers.com/2015/01/installing-rstudio-server-on-ubuntu-server/)

- Installer Python 3 si ce n'est pas déjà fait (testé avec `$ type python3`)
    - [lien vers la procédure](https://docs.python-guide.org/starting/install3/linux/)
    - Mais **surtout installer `pip`** : `$ sudo apt install python3-pip`

- Installer Jupyter Hub / Jupyter Lab
    - [lien vers la procédure](https://jupyterhub.readthedocs.io/en/stable/)


- Tester si les deux services (R Studio Server et Jupyter Hub) fonctionnent
    - Dans VirtualBox, configuration de la VM -> Réseau -> "Accès par pont"
    - Utiliser `$ ip addr` dans le `shell` pour connaître l'adresse IP (locale) de votre machine virtuelle
    - Pour RStudio Server : adresse de type `http://192.168.1.15:8787` (attention, `192.168.1.15` est l'adresse IP en local sur ma machine)
    - Pour JupyterLab : adresse de type `http://192.168.1.15:8000`

- **A noter** : RStudio Server et Jupyter Lab vous offre tous les deux la possibilité d'écrire des fichiers texte (donc un script `shell`) et d'avoir un terminal de commande (donc de faire du `shell` dans un navigateur). Ce qui sera beaucoup plus pratique pour écrire les scripts `shell`.

## Récupération des données Velib'

- Ecrire en `shell`, R et en Python (3 versions donc) un script permettant de récupérer les données en temps réel des stations Velib
    - [Données Velib](https://opendata.paris.fr/explore/dataset/velib-disponibilite-en-temps-reel/information/?disjunctive.name&disjunctive.is_installed&disjunctive.is_renting&disjunctive.is_returning&disjunctive.nom_arrondissement_communes)
    - Le code doit récupérer le fichier `JSON` et le stocker dans un fichier avec l'horodatage dans le nom de fichier
        - Attention au répertoire de sauvegarde de ce fichier
    
- Programmer ces 3 codes pour qu'ils s'exécutent toutes les 5 minutes du 10 au 13 novembre

## Rendus

- Faire un fichier compressé avec les 3 codes + un fichier texte reprenant ce que vous avez programmé avec `cron`, à m'envoyer via Slack


