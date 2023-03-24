# Introduction à MongoDB (avec Python)

- [Introduction à MongoDB](python-mongodb.slides.html)

- [TP à faire](python-mongodb-evaluation)
    - [correction du début, sur `restaurants`](python-mongodb-correction-debut)

## Pour travail sur votre ordinateur

2 possibilités :

- Installation des outils sur votre ordinateur, en suivant la procédure décrite sur [cette page](../infos-mongo)
- Utilisation d'une machine virtuelle avec [*VirtualBox*](https://www.virtualbox.org/) (gratuit), en suivant cette procédure :
    - Télécharger le fichier [Python MongoDB.ova](https://filesender.renater.fr/?s=download&token=7b4badd3-0525-4fdb-aa06-90b4419abf49) (lien fonctionnel jusqu'au 31 mars 2023)
    - Dans Virtual Box, cliquer sur *Fichier* dans le menu, puis *Importer un appareil virtuel*
    - Choisir le fichier téléchargé
    - Cliquer sur *Finish* (ou *Terminer*)
        - L’importation prend un peu de temps
    - Vérifier la *configuration* de la machine
        - Aller dans *Réseaux*
        - Choisir donc *Accès par pont* (*Bridged access* ou qqch du genre)
    - Lancer la machine virtuelle
    - Se connecter à la machine
        - Utilisateur : **user** et mot de passe : **123456**
        - Noter qu'il y a parfois des afficahges sur la console qui peuvent perturber. Appuyer plusieurs fois sur *Entrée* pour vous assurer que vous avez un affichage similaire à celui-ci :
        ```
        user@pythonmongodb$ 
        ```
    - Exécuter la commande `./monip` pour connaître l'addresse IP de votre machine
    - Aller dans un navigateur et taper l'adresse suivante dans la barre d'adresse :
        - `194.168.1.xx:8000` (le `xx` est à remplacer par la valeur dans votre adresse IP)
    - Se connecter à JupyterHub avec les mêmes identifiants
