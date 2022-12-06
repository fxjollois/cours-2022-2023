# Système pour la Data Science

## Master AMSD/MLSD

### Scripts `shell` à traduire

#### *Correction*

## En langage R

### Script de recherche d'informations

Ici, la gestion de l'appel au script avec des paramètres n'est pas géré.

```r
id = readline(prompt = "Numéro d'identifiant : ")

ids = data.frame(t(data.frame(strsplit(dir("UbiqLog4UCI/"), "_"))))
rownames(ids) = NULL
colnames(ids) = c("id", "sexe")
ids$rep = paste("UbiqLog4UCI", dir("UbiqLog4UCI/"), sep = "/")

if (any(ids$id == id)) {
  cat("Identifiant existant\n")
  qui = which(ids$id == id)
  if (ids$sexe[qui] == "M")
    cat("\tSexe : Homme\n")
  else
    cat("\tSexe : Femme\n")
  cat("\tRépertoire :", ids$rep[qui], "\n")
  
  d = readline(prompt = "Date (aaaa-mm-jj) : ")
  dd = strsplit(d, "-")[[1]][c(2, 3, 1)]
  f = paste0(ids$rep[qui], "/log_", paste(dd, collapse = "-"), ".txt")
  if (file.exists(f)) {
    cat("\nLog existant pour cette date\n")
    cat("\tFichier : ", f, "\n")
  }
} else {
  cat("Identifiant non présent\n")
}
```

### Script d'extraction 

```r
```

## En langage Python

### Script de recherche d'informations

Ici, la gestion de l'appel au script avec des paramètres n'est pas géré.

```python
id = input("Numéro d'identifiant : ")

import os
import pandas
import numpy

ids = pandas.DataFrame([r.split("_") for r in os.listdir("UbiqLog4UCI/")])
ids.columns = ["id", "sexe"]
ids = ids.assign(rep = ["UbiqLog4UCI/"+r for r in os.listdir("UbiqLog4UCI/")]) \
         .sort_values(by = "id") \
         .reset_index(drop = True)

if sum(ids.id == str(id)) > 0:
    qui = numpy.where(ids.id == str(id))[0][0]
    if ids.sexe[qui] == "M":
        print("\tSexe : Homme")
    else:
        print("\tSexe : Femme")
    print("\tRépertoire :", ids.rep[qui], "\n")

    d = input(prompt = "Date (aaaa-mm-jj) : ")
    dd = ("-").join([d.split("-")[i] for i in (1, 2, 0)])
    f = ids.rep[qui] + "/log_" + dd + ".txt"
    if os.path.exists(f):
        print("\nLog existant pour cette date\n")
        print("\tFichier : ", f, "\n")
else:
    print("Identifiant non présent\n")
```

### Script d'extraction 

```python
```


## Comparer les trois scripts

- Sur la taille du code
- Sur la difficulté de développement
- Sur la gestion de la mémoire vive