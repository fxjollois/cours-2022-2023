# SAE Collecte de données web

## Quelques open data ou API intéressantes

- [Open data de l'APUR](https://opendata.apur.org/search?collection=Dataset&tags=apur_bd_economie)

- [Base de données SIRENE](https://www.sirene.fr/sirene/public/static/acces-donnees)
    - Tous les numéros de SIREN et SIRET

- [Open data de la mairie de Paris](https://opendata.paris.fr/pages/home/)

- [Base nationale d'adresse](https://adresse.data.gouv.fr/api-doc/adresse)
    - [Exemple d'encodage](https://api-adresse.data.gouv.fr/search/?q=143+avenue+Versailles+paris) : adresse vers coordonnées
    - [Exemple de décodage](https://api-adresse.data.gouv.fr/reverse/?lon=2.267746&lat=48.841983) : coordonnées vers adresse(s)
    
- [Google API Places](https://developers.google.com/maps/documentation/places/web-service)
    - `API_KEY` est à remplacer par la clé que vous pouvez obtenir dans votre console Google Cloud
        - <https://console.cloud.google.com/google/maps-apis/api-list>
    - Appel avec l'adresse de l'IUT : 
        - `findplacefromtext` renvoie les `place_id` candidats
        - `https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=143+avenue+de+versailles+75016+paris&key=API_KEY&inputtype=textquery`

                {
                    candidates: [
                        {
                            place_id: "ChIJ8dLLgqN65kcRQ9_G2dBSAe4"
                        }
                    ],
                    status: "OK"
                }
    
    - Plus d'infos à partir d'une adresse
        - `https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=IUT+143+avenue+de+versailles+75016+paris&key=API_KEY&inputtype=textquery&fields=formatted_address,name,geometry,business_status`
    - Gédo-décodage possible : des coordonnées vers un ou plusieurs adresses 
        - `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=48.841983,2.267746&radius=100&key=API_KEY`
    - Récupération des informations à partir d'un `place_id` :
        - `https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJ8dLLgqN65kcRQ9_G2dBSAe4&key=YOUR_API_KEY`

                {
                    html_attributions: [ ],
                    result: {
                        address_components: [
                            {
                                long_name: "143",
                                short_name: "143",
                                types: [
                                    "street_number"
                                ]
                            },
                            {
                                long_name: "Avenue de Versailles",
                                short_name: "Av. de Versailles",
                                types: [
                                    "route"
                                ]
                            },
                            {
                                long_name: "Paris",
                                short_name: "Paris",
                                types: [
                                    "locality",
                                    "political"
                                ]
                            },
                            {
                                long_name: "Département de Paris",
                                short_name: "Département de Paris",
                                types: [
                                    "administrative_area_level_2",
                                    "political"
                                ]
                            },
                            {
                                long_name: "Île-de-France",
                                short_name: "IDF",
                                types: [
                                    "administrative_area_level_1",
                                    "political"
                                ]
                            },
                            {
                                long_name: "France",
                                short_name: "FR",
                                types: [
                                    "country",
                                    "political"
                                ]
                            },
                            {
                                long_name: "75016",
                                short_name: "75016",
                                types: [
                                    "postal_code"
                                ]
                            }
                        ],
                        adr_address: "<span class="street-address">143 Av. de Versailles</span>, <span class="postal-code">75016</span> <span class="locality">Paris</span>, <span class="country-name">France</span>",
                        formatted_address: "143 Av. de Versailles, 75016 Paris, France",
                        geometry: {
                            location: {
                                lat: 48.84202330000001,
                                lng: 2.267862
                            },
                            viewport: {
                                northeast: {
                                    lat: 48.8434585802915,
                                    lng: 2.269258680291502
                                },
                                southwest: {
                                    lat: 48.8407606197085,
                                    lng: 2.266560719708498
                                }
                            }
                        },
                        icon: "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/geocode-71.png",
                        icon_background_color: "#7B9EB0",
                        icon_mask_base_uri: "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
                        name: "143 Av. de Versailles",
                        place_id: "ChIJ8dLLgqN65kcRQ9_G2dBSAe4",
                        plus_code: {
                            compound_code: "R7R9+R4 Paris, France",
                            global_code: "8FW4R7R9+R4"
                        },
                        reference: "ChIJ8dLLgqN65kcRQ9_G2dBSAe4",
                        types: [
                            "street_address"
                        ],
                        url: "https://maps.google.com/?q=143+Av.+de+Versailles,+75016+Paris,+France&ftid=0x47e67aa382cbd2f1:0xee0152d0d9c6df43",
                        utc_offset: 60,
                        vicinity: "Paris"
                    },
                    status: "OK"
                }

## Web-scraping avec Python

- Inspiré par cette page : <https://outscraper.com/how-to-scrape-google-maps-with-python-and-selenium/>
- Installation à faire auparavant :
    - Packages [`selenium`](https://selenium-python.readthedocs.io/api.html#locate-elements-by) et [`bs4`](https://www.crummy.com/software/BeautifulSoup) (BeautifulSoup) pour Python
    - Exécutable [`chromedriver`](https://chromedriver.chromium.org/downloads) (selon votre OS)
- Première étape : configurer le navigateur 
    - ici vous faites cela bien, `chromedriver` est dans le même répertoire que mon notebook

```python
from selenium import webdriver

chromedrive_path = './chromedriver' # chemin vers votre exécutable 
driver = webdriver.Chrome(chromedrive_path)
```

- Création de l'URL à récupérer

```python
base_url = "https://www.google.com/maps/search/"
place_info = "IUT+paris+rives+de+seine"
comp_url = "/@48.8489968,2.3125954,12z"

url = base_url + place_info + comp_url
url
```

- Deuxième étape : récupération du contenu HTML
    - Lors de la première exécution de ce code, une fenêtre va s'ouvrir dans laquelle vous devrez cliquer (a priori sur "Tout accepter")
    - **NE PAS FERMER CETTE FENETRE !**
    - Relancer le code une deuxième fois pour effectivement récupérer le contenu désiré

```python
driver.get(url)
html = driver.page_source
```

- Troisième étape : recherche de ce qui nous intéresse (ici la partie Informations)

```python
from bs4 import BeautifulSoup

soup = BeautifulSoup(html)
results = soup.select("div[aria-label*='Informations']")
results
```

- Si on cherche s'il y a un site web 

```python
results = soup.select("a[aria-label*='Site Web']")
results
```

- Dernière étape : une fois qu'on a récupéré tout ce qu'on souhaite, on ferme correctement le navigateur

```python
driver.close()
```




