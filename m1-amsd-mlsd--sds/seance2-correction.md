# Système pour la Data Science

## Master AMSD/MLSD

### Scripts `shell`

#### *Correction*

## Manipulations à faire en amont

On se place dans le répertoire `sysds` créé lors de la séance 1

```bash
$ cd sysds
```

- Créer un répertoire `seance2` dans le répertoire du cours

```bash
$ mkdir seance2
```

- Copier le répertoire `UbiqLog4UCI` dans ce nouveau répertoire

```bash
$ cp -r seance1/UbiqLog4UCI/ seance2/
```

## Scripts simples

- Ecrire un script prenant des entiers en paramètres et affichant la somme de ceux-ci
    - Gérer le cas aucun paramètre fourni
    - Gérer le cas paramètre non entier

```bash
#!/bin/bash
if [ $# = 0 ]; then
    echo "Merci de fournir des entiers en paramètres !"
    exit
fi
let res=0
for v in $@ ; do
    if ! [[ "$v" =~ ^-?[0-9]+$ ]] ; then
        echo "Que des entiers ! $v n'en est pas un..."
        exit
    fi
    let res=$res+$v
done
echo "Somme = $res"
exit
```

- Ecrire un script qui demande "Avez-vous compris le cours (Oui/Non/Exit) ?"
    - Qui répond 
        - "Bravo" si l'utlisateur répond "Oui"
        - "N'hésitez pas à poser des questions à l'enseignant" si l'utilisateur répond "Non"
        - "Au revoir" si l'utlisateur répond "Exit"
        - "Merci de lire les consignes..." sinon
    - Gérer les variations à la réponse
        - "Oui" peut être écrit aussi "oui", "OUI", "o", "O"
        - "Non" peut être écrit aussi "non", "NON", "n", "N"
        - "Exit" peut êter écrit aussi "exit", "EXIT", "e", "E"

```bash
#!/bin/bash
let stop=0
until [ $stop == 1 ] ; do
    read -p "Avez-vous compris (Oui/Non/Exit) ? " rep
    if [[ $rep =~ ^[oO][uU]?[iI]?$ ]] ; then
        echo "Bravo"
    elif [[ $rep =~ ^[nN]?[oO]?[nN]?$ ]] ; then
        echo "N'hésitez pas à poser des questions à l'enseignant !"
    elif [[ $rep =~ ^[eE]?[xX]?[iI]?[tT]?$ ]] ; then
        echo "Au revoir"; let stop=1
    else
        echo "Merci de lire les consignes"
    fi
done
exit
```

## Script de recherche d'informations

On va travailler sur les fichiers présents dans le répertoire `UbiqLog4UCI`.

- Faire un script qui demande à l'utilisateur un numéro d'individu (de 1 à ?) et qui vérifie que celui-ci existe bien dans la liste des répertoires
    - De plus, le script nous indiquera si cet individu est un homme (`M` dans le nom) ou une femme (`F`)

- Compléter ce script pour demander une date à l'utilisateur
    - Le script indiquera s'il y a bien un fichier de log pour ce jour la et cette personne

- Compléter encore le script pour pouvoir passer en paramètre les deux informations, avec le formalisme suivant :
    - `-i 12` : pour tester si l'individu 12 existe
    - `-d 2014-01-11` : pour tester si la date existe pour cet individu
        - si l'option `-i` n'est pas utilisée, alors message d'erreur
    
- Gérer les appels 
    - si pas de paramètre : demande de l'utilisateur puis de la date
    - si juste utilisateur (`-i`) : affichage pour dire si c'est un homme ou une femme, puis demande de la date
    - si utilisateur (`-i`) et date (`-d`) : affichage pour dire si c'est un homme ou une femme, et dire si la date existe

```bash
#!/bin/bash
# Gestion du paramètre identifiant
if [ $# = 0 ] ; then 
    read -p "Numéro d'identifiant : " id
elif [ $1 != "-i" ] ; then 
    echo "Paramètre -i en premier"
    exit
elif ! [ $2 ] ; then 
    echo "Identifiant à passer en paramètre"
    exit
else 
    id=$2
fi
r=$(ls -d 'UbiqLog4UCI/'$id'_'* 2>/dev/null)
s=${r#*_}
if [ $r ] ; then
    echo -e "\nIdentifiant existant"
else
    echo -e "\nIdentifiant non présent\n"
    exit
fi
case $s in
    "M") echo -e "\tSexe : Homme";;
    "F") echo -e "\tSexe : Femme";;
    *) echo "Erreur"
esac
echo -e "\tRépertoire :" $r "\n"

# Gestion du paramètre date
if ! [ $3 ] ; then
    read -p "Date (aaaa-mm-jj) : " d
elif [ $3 != -d ] ; then
    echo "Paramètre -d en deuxième"
elif ! [ $4 ] ; then
    echo "Date à passer en paramètre"
    exit
else
    d=$4
fi
dd=(${d//-/ })
ddd=${dd[1]}-${dd[2]}-${dd[0]}
if [ -f 'UbiqLog4UCI/'$id'_'$s'/log_'$ddd'.txt' ] ; then
    echo -e "Log existant pour cette date"
    echo -e "\tFichier :" 'UbiqLog4UCI/'$id'_'$s'/log_'$ddd'.txt'"\n"
fi
exit
```

## Script d'extraction 

Toujours dans le répertoire `UbiqLog4UCI`, on veut faire un script qui va concaténer tous les logs dans un seul fichier JSON, avec le format suivant :

```json
[
    {
        id: 1, // première partie du nom du répertoire
        sexe: "M", // deuxième partie du nom du répertoire
        date: "2014-01-11", // date ré-écrite au format YYYY-MM-DD
        log: [contenu_du_fichier], // contenu du fichier transformé en tableau JSON
    },
    ...
 ]
```

Les fichiers log sont formatés avec un litéral JSON par ligne, cf ci-dessous :

```json
{"Wifi": {...}}
{"Wifi": {...}}
...
```

Pour le transformer un tableau JSON, il faut donc encadrer ces lignes par des `[]` et mettre des virgules entre chaque ligne, comme ci-dessous :

```json
[
    {"Wifi": {...}},
    {"Wifi": {...}},
    ...
]
```

### A faire

- Créer un script permettant de concaténer toutes les informations dans un seul fichier avec le formalisme vu ci-dessus
    - nom du fichier par défaut `sortie.json`

- Modifier le script pour pouvoir indiquer le nom du fichier à écrire
    - paramètre `-o` suivi par le nom de fichier à écrire

- Etendre ce script à la possibilité de demander de n'extraire que les lignes correspondant à une certainte recherche (similaire à celle faite avec `grep`)
    - l'utilisateur indiquera comme paramètre `-s` suivi du critère de recherche (syntaxe `grep`)

```bash
#!/bin/bash
fichier=sortie.json
echo "[" > $fichier
for d in UbiqLog4UCI/* ; do
    #echo -n $d
    is=${d/UbiqLog4UCI\//}
    is=(${is/_/ })
    i=${is[0]}
    s=${is[1]}
    for f in $d/* ; do
        if [[ $f =~ .*log.*txt ]] ; then
            #echo -n "."
            date=${f##*log_}
            date=${date/.txt/}
            date=(${date//-/ })
            date=${date[2]}-${date[0]}-${date[1]}
            echo "{" >> $fichier
            echo "\"origine_rep\": \"$d\"," >> $fichier
            echo "\"origine_fic\": \"$f\"," >> $fichier
            echo "\"id\": $i," >> $fichier
            echo "\"sexe\": \"$s\"," >> $fichier
            echo "\"date\": \"$date\"," >> $fichier
            echo "\"log\": [" >> $fichier
            cat "$f" | sed "$ ! s/.*/&,/" >> $fichier        
            echo "] }," >> $fichier
        fi
    done
    #echo
done
echo "]" >> $fichier
echo
echo "Fichier $fichier créé"
exit
```



