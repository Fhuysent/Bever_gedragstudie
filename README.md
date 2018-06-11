# Bever_gedragstudie

# Opladen van gegevens

De telemetriegegevens worden in het veld ingegeven in MyMaps.
Daarbij wordt een laag per Bever gemaakt
Elke laag krijgt de code van een individuele bever (beginnend bij BE1002)

Elke laag wordt afzonderlijk als .kml uit MyMaps gehaald en opgeslagen onder de map:
/Input/kml
Daarbij krijgt elke file de naam: naambever.kml (vb. BE1002.kml)

# Omzetten van gegevens

De .kml files worden omgezet naar .csv files via het script
KMLOmzettenCSV.R (/Scripts)
Deze schrijft voor elke .kml een .csv weg in de map
/Input/csv (vb. BE1002.csv)
In de verwerkende files worden alle csv's telkens ingelezen en samengevoegd tot 1 dataset

# Bevers op kaart plaatsen

De file Kaartje_bevers.R plaats alle waarnemingen op kaart op basis van gegevens in csv map

# Data-analyse

## Home ranges

De file Home_ranges.Rmd berekent de home ranges op basis van gegevens in csv map

## Aanpassen

Iets veranderen aan deze ReadMe? Doe dit via GitHub zodat iedereen je aanpassingen kan zien.

## Versie

Versie 1.1 gemaakt op 11/06/2018.

## Auteur

* **Frank Huysentruyt** - *Initial work* - 

## Acknowledgments

* Alle medeschrijvers van dit script
