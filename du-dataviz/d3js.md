# Visualisation de données - d3.js

> Data-Driven Documents

[d3.js](http://www.d3js.org) est une librairie `javascript` très complète avec beaucoup d'exemples à disposition, avec une personnalisation totale possible. Elle permet l'accès à des primitives `SVG` permettant toute innovation. Malheureusement, elle est peu accessible directement et assez technique.

L'idée principale est de lier les **données** au **DOM** (*Document Object Model*), et d'appliquer des transformations, basées sur les données, au document.

<!-- 
Les documents de cours sont disponibles sur [ObservableHQ](https://observablehq.com/collection/@fxjollois/d3js).
<iframe width="100%" height="500" frameborder="0"
  src="https://observablehq.com/embed/@fxjollois/initiation-a-d3js?cell=*"></iframe>
-->

- [Cours introductif](d3js--slides.html)
- [Tutoriel pas à pas](d3js--tutoriel) de construction d'un **TOPn**

## Travail à réaliser

En repartant des données de production scientifique (au format `CSV` cette fois) disponible via ce lien <https://fxjollois.github.io/donnees/scimagojr/scimagojr.csv>, refaire les demandes suivants :

- Faire toutes les demandes dans le tutoriel pour améliorer le TOP
- **Nuage de points** : nuage de points entre le nombre de documents produits et le nombre moyen de citations pour la dernière année disponible, pour chaque pays, avec les contraintes suivantes :
    - couleur (entre du vert pour le 1er et du rouge pour le dernier) en fonction de son rang
    - taille en fonction du *H-index*
    - lignes de références au niveau des moyennes de chaque variable
    - axes logarithmiques
    - nom de chaque pays indiqué lorsque la souris passe dessus


### Rendu

Merci de déposer un fichier `zip` contenant l'ensemble de vos fichiers (`HTML`, `JS` et éventuellement `CSS`), avec votre nom de famille dans le nom de fichier, sur cet espace :

<https://cloud.parisdescartes.fr/index.php/s/AwxBA8HaDNW6KK8>


<!--
Questions pour QCM :

d3.select("#aaaa").html("bla bla bla")
Où sera placé le texte "bla bla bla" ?

d3.select("body").style("color", "red")
Que fait ce code ?

Il n'est pas possible d'associer un tableau à une sélection plus grande ?

d3.select("#aaaa")
  .html("")
  .selectAll("p")
  .data(["pomme", "cerise", "fraise"])
  .enter()
  .append("p")
  .html(d => "Le fruit est une " + d);
Que fait ce code ?

Il est possible de placer du code suite à l'importation de données sans se
soucier du temps mis pour les télécharger

d3.rollups(
  [{a: 0, b: 5}, {a: 1, b: 7}, {a: 1, b: 12}, {a: 0, b: 4}],
  v => d3.mean(v, e => e.b)
  d => d.a
)
-->
