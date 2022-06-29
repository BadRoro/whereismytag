# Where is my tag ?
Projet IOS – M1 MIAGE 
Romain BADINO – Yann MARINO

## Présentation
L’application est une application de géolocalisation des arrêts TAG à proximité (dans un rayon de 400m) et de navigation de l’utilisateur vers l’arrêt choisi.
C’est une application simple d’utilisation avec 2 vues :
- Une vue qui affiche une carte et un bouton de recherche.
- Une vue qui affiche la liste des arrêts à proximité.
Cette application fait appel à l’API de la TAG pour avoir accès à sa base de données.

## Fonctionnalités
- Localisation de l’utilisateur sur la carte.
- Recherche des arrêts à proximité de l’utilisateur.
- Affichage de la liste des arrêts à proximité de l’utilisateur.
- Affichage sur la carte d’un parcours entre la position de l’utilisateur et celle de l’arrêt sélectionné.
- Actualisation de la position de l’utilisateur.

## Fonctionnalités manquantes
- Afficher la distance des arrêts sur la liste des arrêts.
- Possibilité d’entrer une adresse pour rechercher un arrêt à proximité.
- Possibilité d’avoir les lignes de bus/tram qui passent à l’arrêt sélectionné.
- Possibilité d’afficher les temps des prochains passages.
- Améliorer la navigation de l’utilisateur vers l’arrêt choisi.
- Ajouter des paramètres pour choisir la distance de recherche.
- Ajouter des paramètres pour mémoriser un arrêt favori.
- Ajout d’un bouton pour accéder rapidement à l’arrêt favori.

## Retours sur le projet
Ce projet nous a permis de découvrir la programmation sur un nouvel environnement avec des problématiques propre au mobile.
Nous avons choisi de faire un projet simple afin de découvrir le langage Swift, car nous ne connaissions ni ce langage ni les langages dont il est inspiré (Objective-C, Haskell, Ruby, Python, C#).
Nous avons fait du pair programming en nous inspirant de l’exemple proposé afin de bien comprendre les concepts du langage et de progresser ensemble.
Nous avons réussi à rendre une application fonctionnelle avec les fonctions minimales ce qui a été notre objectif principal.
La principale difficulté de ce projet a été les 2 semaines de pause entre les sessions. Ces pauses ont été très longues et nécessité une reprise en main du langage et des outils qui n’a pas été évidente. Les pauses ont aussi été difficiles à gérer pour le projet en début de période ou nous devions bien suivre ce que nous devions faire les prochaines sessions.

## Guide de l'API Tag
https://www.mobilites-m.fr/pages/opendata/OpenDataApi.html#Hor

### LISTE DES LIGNES DE TRANSPORT À PROXIMITÉ D'UN POINT

URL : http://data.mobilites-m.fr/api/linesNear/json?x={X}&y={Y}&dist={Z}&details={bool}

Permet de connaître la liste des lignes de transport à proximité d'un point décrit par ses coordonnées GPS (WGS 84).
Cette fonctionnalité est, par exemple, utilisée par les applications mobiles M, fonctionnalité "A Proximité". Par défaut la distance du rayon de la recherche est de 300m. Il est possible de la modifier
Un paramètre permet d'avoir une description plus précise des éléments retournés.

Paramètre	Explication	Type	Obligatoire
x={X}	Longitude du point de référence, centre du cercle de recherche (en mode 'details' uniquement)	float	oui
y={Y}	Latitude du point de référence, centre du cercle de recherche (en mode 'details' uniquement)	float	oui
dist	Distance, en mètre, du centre de recherche (en mode 'details' uniquement)	int	non
Si non, 300 par défaut
details	Détail dans la liste de ligne retourné (en mode 'details' uniquement)	bool	non
Si non, non, par défaut

Voir les données 

EXEMPLE :

http://data.mobilites-m.fr/api/linesNear/json?x=5.709360123&y=45.176494599999984&dist=400&details=true -- permet d'obtenir la liste des lignes à proximité d'un point dans un rayon de 400m, avec un détail maximal.
