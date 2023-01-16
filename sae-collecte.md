# SAE Collecte de données web

- [Open data de l'APUR](https://opendata.apur.org/search?collection=Dataset&tags=apur_bd_economie)

- [Open data de la mairie de Paris](https://opendata.paris.fr/pages/home/)

- [Base nationale d'adresse](https://adresse.data.gouv.fr/api-doc/adresse)
    - [Exemple d'encodage](https://api-adresse.data.gouv.fr/search/?q=143+avenue+Versailles+paris) : adresse vers coordonnées
    - [Exemple de décodage](https://api-adresse.data.gouv.fr/reverse/?lon=2.267746&lat=48.841983) : coordonnées vers adresse(s)
    
- [Google API Places](https://developers.google.com/maps/documentation/places/web-service)
    - https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=143+avenue+de+versailles+75016+paris&key=API_KEY&inputtype=textquery

            {
                candidates: [
                    {
                        place_id: "ChIJ8dLLgqN65kcRQ9_G2dBSAe4"
                    }
                ],
                status: "OK"
            }
    
    - Plus d'infos : https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=IUT+143+avenue+de+versailles+75016+paris&key=API_KEY&inputtype=textquery&fields=formatted_address,name,geometry,business_status
    - Autre : https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=48.841983,2.267746&radius=100&key=API_KEY

https://maps.googleapis.com/maps/api/place/findplacefromtext/json?parameters
https://maps.googleapis.com/maps/api/place/findplacefromtext/json?parameters
