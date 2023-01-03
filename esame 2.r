# R_code_esame.r  
# Santa Cruz, Bolivia
# Sito utilizzato per scaricare le immagini: https://eros.usgs.gov/media-gallery/earthshot/santa-cruz-bolivia

# La conversione della fitta foresta ammazzonica in terreni coltivati sta avendo effetti drammatici sull'ambiente. Nello stato di Santa Cruz, in Bolivia, si sta verificando una deforestazione particolarmente intensa e rapida
# Luogo di studio: Santa Cruz, Bolivia
# In questo progetto si vuole osservare la riduzione della vegetazione a causa della deforestazione dal 1986 al 2021

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
At1986 <- brick( "19860702_Cruz-Intro.png" )
At2021 <- brick( "20210819_Cruz-Intro.png" )

# Controllo le informazioni dei due Rasterbrick:
At 1986
#class      : RasterBrick 
# dimensions : 834, 1000, 834000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 834  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : 19860702_Cruz-Intro.png 
# names      : X19860702_Cruz.Intro.1, X19860702_Cruz.Intro.2, X19860702_Cruz.Intro.3, X19860702_Cruz.Intro.4 
# min values :                      0,                      0,                      0,                      0 
# max values :                    255,                    255,                    255,                    255 

At2021
# class      : RasterBrick 
# dimensions : 833, 1000, 833000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 833  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : 20210819_Cruz-Intro.png 
# names      : X20210819_Cruz.Intro.1, X20210819_Cruz.Intro.2, X20210819_Cruz.Intro.3, X20210819_Cruz.Intro.4 
# min values :                      0,                      0,                      0,                      0 
# max values :                    255,                    255,                    255,                    255

# La classe è un RasterBrick: sono 3 bande in formato raster
# Ci sono 834.000 pixel per ogni banda
# Le due immagini sono a 8 bit: 2^8 = 256 -> da 0 a 255 valori

# Funzione plot: visualizzo le 3 bande di ciascuna immagine ei relativi valori di riflettanza nella legenda:
plot(At1986)
plot(At2021)
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
plotRGB( At1986 , r = 1 , g = 2 , b = 3 , stretch = " Lin " , main = " Santa Cruz nel 1986" )
plotRGB( At2021 , r = 1 , g = 2 , b = 3 , stretch = " Lin " , main = " Santa Cruz nel 2021" )
# Verde: foresta boreale e praterie coltivate -> la vegetazione riflette molto il Nir (g=2 -> alto valore di riflettanza)
# Viola: 
# Blu: fiume, stagni sterili

# ------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -

# 2. TIME SERIES ANALYSIS 
# La Time Series Analysis è utile per confrontare due o più immagini nel corso degli anni e capire dove sono avvenuti i cambiamenti principali 

# funzione list.files: creo una lista di file riconosciuta grazie al pattern "RondoniaIntro" che si ripete nel nome
lista <- list.files(pattern="Cruz-Intro")
# funzione lapply: applica la funzione (in questo caso raster) a tutta la lista di file appena creata
# funzione raster: importa singoli strati e crea un oggetto chiamato raster layer
importa <- lapply(lista, raster)
# funzione stack: raggruppa i file appena importati in un unico blocco di file 
cruz <- stack(importa) 

# funzione colorRampPalette: cambio la scala di colori di default proposta dal software con una gradazione di colori che possa marcare le differenze nei due periodi
# ogni colore è un etichetta scritta tra "" e sono diversi caratteri di uno stesso argomento dunque vanno messi in un vettore c 
# (100): argomento che indica i livelli per ciascun colore
cs <- colorRampPalette(c("dark blue","light blue","pink","red"))(100)

# library(rasterVis) 
# funzione levelplot: crea un grafico dove mette a confronto le due immagini in tempi diversi utilizzando un'unica legenda 
levelplot(cruz, col.regions=cs, main="Deforestazione a Santa Cruz", names.attr=c("2021" , "1986"))
# Si nota in rosa e rosso l'aumento delle miniere a cielo aperto e la diminuzione della foresta boreale 

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# 3. INDICI DI VEGETAZIONE - NDVI 

# NDVI = NIR - red / NIR + red 
# - 1 < NDVI < 1 

# associo dei nomi immediati alle bande:
nir1 <- At1986$X19860702_Cruz.Intro.2
red1 <- At1986$X19860702_Cruz.Intro.3
nir2 <- At2021$X20210819_Cruz.Intro.2
red2 <- At2021$X20210819_Cruz.Intro.3

clr <- colorRampPalette(c('dark blue', 'yellow', 'red', 'black'))(100)

# Calcolo il NDVI per l'immagine del 1989:
ndvi1 <- (nir1 - red1) / (nir1 + red1)
plot(ndvi1, col=clr, main="NDVI 1986")
# legenda:
#     rosso: NDVI alto, foresta borale sana e intatta
#     giallo: NDVI basso, aree di deforestazione per l'agricoltura


# Calcolo il NDVI per l'immagine del 2022:
ndvi2 <- (nir2 - red2) / (nir2 + red2)
plot(ndvi2, col=clr, main="NDVI 2021") 
# Legenda:
#    rosso scuro: NDVI alto, foresta borale sana e intatta
#    giallo: NDVI basso, aree di deforestazione per l'agricoltura, si nota un forte aumento di quest'area 

# metto le due immagini risultanti a confronto in un grafico con una riga e due colonne
par(mfrow=c(1,2))
plot(ndvi1, col=clr, main="NDVI 1986")
plot(ndvi2, col=clr, main="NDVI 2021")

# Cambiamento della vegetazione dal 1986 al 2021
# Differenza tra i due NDVI nei due tempi:
cld <- colorRampPalette(c('dark blue', 'white', 'red'))(100)
diffndvi <- ndvi1 - ndvi2
levelplot(diffndvi, col.regions=cld, main="NDVI 1986 - NDVI 2021")
# legenda:
#       rosso: > diff -> aree con la maggior perdita di vegetazione per l'aumento delle zone a scopi agricoli
#       bianco: < diff -> aree con foresta boreale sana e intatta

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# 4. VARIABILITA' SPAZIALE - ANALISI DELLE COMPONENTI PRINCIPALI

# La variabilità spaziale è un indice di biodiversità, vado a controllare quanto è eterogenea questa area
# > eterogeneità -> > biodiversità attesa 
# MOVING WINDOW: analizzo la variabilità spaziale tramite una tecnica chiamata moving window, ovvero sull'img originale si fa scorrere una moving window di nxn pixel 
#                e calcola un'operazione (da noi richiesta) per poi riportare il risultato sul pixel centrale 
#                poi la finestra mobile si muove nuovamente di un pixel verso destra e riesegue l'operazione per riportare il risultato sul nuovo pixel centrale
#                in questo modo si crea una nuova mappa finale i cui pixel periferici NON contengono valori, i pixel centrali hanno il risultato da noi calcolato 


# DEVIAZIONE STANDARD: calcolo la ds perchè è correlata con la variabilità siccome racchiude il 68% di tutte le osservazioni
# per calcolarla ci serve solo una banda, dunque bisogna compattare tutte le informazioni relative alle diverse bande in un unico strato

# ANALISI DELLE COMPONENTI PRINCIPALI
# faccio l'analisi multivariata per ottenere la PC1 e su questa calcolo la deviazione standard

# PCA immagine At1986
# library(RStoolbox)
# funzione rasterPCA: fa l'analisi delle componeneti principali di un det di dati
a1pca <- rasterPCA(At1986) 

# funzione summary: fornisce un sommario del modello, voglio sapere quanta variabilità spiegano le varie PC
summary(a1pca$model)
# Importance of components:
#                        Comp.1      Comp.2      Comp.3        Comp.4
# Standard deviation     53.0975911 15.56760541 6.75401727      0
# Proportion of Variance  0.9073263  0.07799333 0.01468041      0
# Cumulative Proportion   0.9073263  0.98531959 1.00000000      1


# La  prima componente principale (PC1) è quella che spiega il 90,7% dell’informazione originale

a1pca
# $call
# rasterPCA(img = At1986)

# $model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])

# Standard deviations:
#   Comp.1    Comp.2    Comp.3    Comp.4 
# 53.097591 15.567605  6.754017  0.000000 

# 4  variables and  834000 observations.

# $map
# class      : RasterBrick 
# dimensions : 834, 1000, 834000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 834  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      :        PC1,        PC2,        PC3,        PC4 
# min values :  -92.32447, -219.29356,  -67.44852,    0.00000 
# max values :  348.66627,   97.75035,  113.28704,    0.00000 


# attr(,"class")
# [1] "rasterPCA" "RStoolbox"


# calcolo la deviazione standard sulla PC1
# lego l'immagine a1pca alla sua mapppa e alla PC1 per definire la prima componenete principale che chiamo pc1a1: 
pc1a1 <- a1pca$map$PC1

# library(raster) 
# funzione focal: funzione generica che calcola la statistica che vogliamo
#                 calcolo la deviazione standard sulla pc1 
# primo argomento: nome dell’immagine
# secondo argomento: w (window) uguale ad una matrice che è la nostra finestra spaziale e normalmente è quadrata (1/n.pixeltot, n.righe, n.colonne)
# terzo argomento: stiamo calcolando la deviazione standard che viene definita sd
# associamo il risultato della funzione all'oggetto pc1sd3a1 (deviazione standard sulla pc1 con una finestra mobile di 3x3 pixel)  
pc1sd3a1 <- focal(pc1a1, w=matrix(1/9, nrow=3, ncol=3), fun=sd)


# library(ggplot2)          -> per plottare con ggplot 
# library(gridExtra)        -> per mettere insieme tanti plot con ggplot
# library(viridis)          -> per i colori, colorare i plot con ggplot in modo automatico, funzione scale_fill_viridis

# plotto la sd della PC1 con ggplot: modo migliore perche individua ogni tipo di discontinuità ecologica e geografica:
# legenda Inferno:
a1 <- ggplot() + geom_raster(pc1sd3a1, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 in 1986 by inferno color scale")
a1
# Legenda:
#    giallo: aumento della sd al passaggio tra suolo e fiume  
#    violetto: bassa sd che individua la città e le strade
#    nero: bassa sd che indica una copertura omogenea di foresta 

# PCA per l'immgine At2021
a2pca <- rasterPCA(At2021) 

summary(a2pca$model)
# Importance of components:
#                              Comp.1      Comp.2      Comp.3     Comp.4
# Standard deviation        111.2409322 19.77289107 12.09263731      0
# Proportion of Variance    0.9583945  0.03027997  0.01132549        0
# Cumulative Proportion     0.9583945  0.98867451  1.00000000        1 
  
# La prima componente principale (PC1) è quella che spiega il 95.8% dell’informazione originale

a2pca
# $call
# rasterPCA(img = At2022)

# $model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])

#  Standard deviations:
#   Comp.1    Comp.2    Comp.3    Comp.4 
# 111.24093  19.77289  12.09264   0.00000 

# 4  variables and  833000 observations.

# $map
# class      : RasterBrick 
# dimensions : 833, 1000, 833000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 833  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      :        PC1,        PC2,        PC3,        PC4 
# min values : -200.29661, -174.53799,  -48.26869,    0.00000 
# max values :   240.8812,   160.0890,   160.1934,     0.0000 


# attr(,"class")
# [1] "rasterPCA" "RStoolbox"


# calcolo la deviazione standard sulla PC1
# lego l'immagine a2pca alla sua mapppa e alla PC1 per definire la prima componenete principale che nomino pc1a2: 
pc1a2 <- a2pca$map$PC1

# funzione focal: calcolo la deviazione standard sulla pc1 tramite la moving windows di 3x3 pixel 
pc1sd3a2 <- focal(pc1a2, w=matrix(1/9, nrow=3, ncol=3), fun=sd)


# library(ggplot2)          -> per plottare con ggplot 
# library(gridExtra)        -> per mettere insieme tanti plot con ggplot
# library(viridis)          -> per i colori, colorare i plot con ggplot in modo automatico, funzione scale_fill_viridis

# plotto la sd della PC1 con ggplot: modo migliore perche individua ogni tipo di discontinuità ecologica e geografica:
# legenda Inferno:
a2 <- ggplot() + geom_raster(pc1sd3a2, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 in 2021 by inferno color scale")
a2

# Legenda
#     giallo: sd alta -> individua il passaggio da foresta a prateria 
#     violetto: sd media -> individua strade e città urbanizzata 
#     nero: sd molto bassa -> copertura omogenea di foresta 


grid.arrange(a1, a2, nrow=1) 
# con le due immagini a confronto si nota la differenza nell'uso del suolo nei due periodi:
# nel 2021:c'è un forte aumento della parte urbanizzata con conseguente riduzione della porzione di foresta naturale 

# ----------------------- -----------------------------------------------------------------------------------------------------------------------------------------


