# whereismytag


https://www.mobilites-m.fr/pages/opendata/OpenDataApi.html#Hor

## LISTE DES LIGNES DE TRANSPORT À PROXIMITÉ D'UN POINT

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
