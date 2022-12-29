# R_code_esame.r  
# Rondonia, Brasile 
# Sito utilizzato per scaricare le immagini: https://eros.usgs.gov/image-gallery/earthshot/athabasca-oil-sands-alberta-canada

# La conversione delle foreste pluviali tropicali in pascoli e terreni coltivati sta avendo effetti drammatici sull'ambiente. Nello stato di Rondônia, in Brasile, si sta verificando una deforestazione particolarmente intensa e rapida
# Luogo di studio: Rondonia
# In questo progetto si vuole osservare la riduzione della vegetazione a causa della deforestazione dal 1975 al 2022

# LIBRERIA
# Imposto le librerie necessarie per le indagini
# funzione install.packages: funzione che installa un pacchetto situato all'esterno del software R
# funzione library: serve per utilizzare un pacchetto

# install.packages("raster")
library( raster )                 # per gestire i dati in formato raster e le funzioni associate
# install.packages("RStoolbox")
library( RStoolbox )              # per la classificazione non supervisionata (funzione unsuperClass) - per l'analisi delle componenti principali (funzione rasterPCA)                            
# install.packages("rasterVis")
library( rasterVis )              # per la time series analysis (funzione levelplot)
# installa.pacchetti("ggplot2")
library( ggplot2 )                # per la funzione ggRGB e per la funzione ggplot
# installa.pacchetti(grigliaExtra)
library( gridExtra )              # per la funzione grid.arrange
# installa.pacchetti(viris)
library( viridis )                # per la funzione scale_fill_viridis

# Impostare la directory di lavoro - percorso Windows
setwd("C:/esame_telerilevamento_2022/")

# 1. INTRODUZIONE - Caricare le immagini - Visualizzare le immagini e le relative Informazioni associate

# Funzione brick: serve per importare dentro a R l'intera immagine satellitare costituita da tutte le sue singole bande (intero set di bande)
# ogni immagine è composta da 3 bande
# la funzione crea un oggetto che si chiama Rasterbrick: serie di bande in formato raster in un'unica immagine satellitare
At1986 <- brick( "19860716_RondoniaIntro.png" )
At2022 <- brick( "20220727_RondoniaIntro.png" )

# Controllo le informazioni dei due Rasterbrick:
# At 1986
class      : RasterBrick 
dimensions : 901, 1000, 901000, 4  (nrow, ncol, ncell, nlayers)
resolution : 1, 1  (x, y)
extent     : 0, 1000, 0, 901  (xmin, xmax, ymin, ymax)
crs        : NA 
source     : 19860716_RondoniaIntro.png 
names      : X19860716_RondoniaIntro.1, X19860716_RondoniaIntro.2, X19860716_RondoniaIntro.3, X19860716_RondoniaIntro.4 
min values :                         0,                         0,                         0,                         0 
max values :                       255,                       255,                       255,                       255 

# At 2022
class      : RasterBrick 
dimensions : 901, 1000, 901000, 4  (nrow, ncol, ncell, nlayers)
resolution : 1, 1  (x, y)
extent     : 0, 1000, 0, 901  (xmin, xmax, ymin, ymax)
crs        : NA 
source     : 20220727_RondoniaIntro.png 
names      : X20220727_RondoniaIntro.1, X20220727_RondoniaIntro.2, X20220727_RondoniaIntro.3, X20220727_RondoniaIntro.4 
min values :                         0,                         0,                         0,                         0 
max values :                       255,                       255,                       255,                       255 


# La classe è un RasterBrick: sono 3 bande in formato raster
# Ci sono 990.000 pixel per ogni banda
# Le due immagini sono a 8 bit: 2^8 = 256 -> da 0 a 255 valori

# Funzione plot: visualizzo le 3 bande di ciascuna immagine ei relativi valori di riflettanza nella legenda:
plot(At1986)
plot(At2022)
# la legenda riporta i valori interi di riflettanza approssimati in una scala in bit da 0 a 255

# SCHEMA RGB: attraverso lo schema RGB visualizza le due immagini a colori falsi:
# Posso utilizzare solo 3 bande alla volta per visualizzare le immagini intere
# Funzione plotRGB: funzione che permette di visualizzare un oggetto raster multistrato attraverso lo schema RGB
# Monto la banda 1 (Swir) sulla componente Red; la banda 2 (Nir) sulla componente Green; la banda 3(Red) sulla componente Blue;
#      -> r=1, g=2, b=3
# Stretch lineare: prende i valori di riflettanza e li fa variare tra 0 e 1 (estremi) in maniera lineare
#                   serve per mostrare tutte le gradazioni di colore ed evitare uno schiacciamento verso una sola parte del colore
# Funzione par: metto le due immagini del 1989-2014 a confronto in un grafico con una riga e due colonne:
par( mfrow = c( 1 , 2 ))
plotRGB( At1986 , r = 1 , g = 2 , b = 3 , stretch = " Lin " , main = " Rodonia nel 1986" )
plotRGB( At2022 , r = 1 , g = 2 , b = 3 , stretch = " Lin " , main = " Rodonia nel 2022 " )
# Verde: foresta boreale e praterie coltivate -> la vegetazione riflette molto il Nir (g=2 -> alto valore di riflettanza)
# Viola: miniere, molto aumentate come superficie nel 2014
# Blu: fiume, stagni sterili

# ------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -

# 2. TIME SERIES ANALYSIS 
# La Time Series Analysis è utile per confrontare due o più immagini nel corso degli anni e capire dove sono avvenuti i cambiamenti principali 

# funzione list.files: creo una lista di file riconosciuta grazie al pattern "RondoniaIntro" che si ripete nel nome
lista <- list.files(pattern="RondoniaIntro")



