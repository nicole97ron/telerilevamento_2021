# R_code_esame.r  
# Santa Cruz, Bolivia
# Sito utilizzato per scaricare le immagini: https://eros.usgs.gov/media-gallery/earthshot/santa-cruz-bolivia

# La conversione della fitta foresta ammazzonica in terreni coltivati sta avendo effetti drammatici sull'ambiente. Nello stato di Santa Cruz, in Bolivia, si sta verificando una deforestazione particolarmente intensa e rapida
# Luogo di studio: Santa Cruz, Bolivia
# In questo progetto si vuole osservare la riduzione della vegetazione a causa della deforestazione dal 1989 al 2021

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

# img 1989: Landsat 5
# Banda:
#        1: Swir - 2: Nir - 3: Rosso

# img 2021: Landsat 8
# Banda:
#        1: Swir - 2: Nir - 3: Rosso

# ------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -


# 1. INTRODUZIONE - Caricare le immagini - Visualizzare le immagini e le relative Informazioni associate

# Funzione brick: serve per importare dentro a R l'intera immagine satellitare costituita da tutte le sue singole bande (intero set di bande)
# ogni immagine è composta da 3 bande
# la funzione crea un oggetto che si chiama Rasterbrick: serie di bande in formato raster in un'unica immagine satellitare
At1989 <- brick( "19890811_Cruz-Intro.png" )
At2021 <- brick( "20210819_Cruz-Intro.png" )

# Controllo le informazioni dei due Rasterbrick:
At1989
# class      : RasterBrick 
# dimensions : 833, 1000, 833000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 833  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : 19890811_Cruz-Intro.png 
# names      : X19890811_Cruz.Intro.1, X19890811_Cruz.Intro.2, X19890811_Cruz.Intro.3, X19890811_Cruz.Intro.4 
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
# Ci sono 833.000 pixel per ogni banda
# Le due immagini sono a 8 bit: 2^8 = 256 -> da 0 a 255 valori

# Funzione plot: visualizzo le 3 bande di ciascuna immagine e i relativi valori di riflettanza nella legenda:
plot(At1989)
plot(At2021)
# la legenda riporta i valori interi di riflettanza approssimati in una scala in bit da 0 a 255

# SCHEMA RGB: attraverso lo schema RGB visualizza le due immagini a colori falsi:
# Posso utilizzare solo 3 bande alla volta per visualizzare le immagini intere
# Funzione plotRGB: funzione che permette di visualizzare un oggetto raster multistrato attraverso lo schema RGB
# Monto la banda 1 (Swir) sulla componente Red; la banda 2 (Nir) sulla componente Green; la banda 3(Red) sulla componente Blue;
#      -> r=1, g=2, b=3
# Stretch lineare: prende i valori di riflettanza e li fa variare tra 0 e 1 (estremi) in maniera lineare
#                   serve per mostrare tutte le gradazioni di colore ed evitare uno schiacciamento verso una sola parte del colore
# Funzione par: metto le due immagini del 1989-2021 a confronto in un grafico con una riga e due colonne:
par(mfrow= c(1,2))
plotRGB( At1989,r=1,g=2,b=3,stretch="Lin",main="Santa Cruz nel 1989")
plotRGB( At2021,r=1,g=2,b=3,stretch="Lin",main="Santa Cruz nel 2021")
# Verde: vegetazione -> la vegetazione riflette molto il Nir (g=2 -> alto valore di riflettanza)
# Bianco/viola: aree industrializzate 
# Blu: fiumi\laghi
# ------------------------------------------------- -------------------------------------------------- -------------------------------------------------- -

# 2. TIME SERIES ANALYSIS 
# La Time Series Analysis è utile per confrontare due o più immagini nel corso degli anni e capire quando e dove sono avvenuti i cambiamenti principali 

# funzione list.files: creo una lista di file  grazie al pattern "Cruz-Intro" che si ripete nel nome di ogni immagine che ho scaricato 
lista <- list.files(pattern="Cruz-Intro")
# funzione lapply: applica la funzione (in questo caso raster) a tutta la lista di file appena creata
# funzione raster: importa singoli strati e crea un oggetto chiamato raster layer
importa <- lapply(lista, raster)
# funzione stack: raggruppa i file appena importati in un unico blocco di file 
cruz <- stack(importa) 

# funzione colorRampPalette: cambio la scala di colori di default proposta dal software con una gradazione di colori che possa marcare le differenze nei vari periodi
# ogni colore è un etichetta scritta tra "" e sono diversi caratteri di uno stesso argomento dunque vanno messi in un vettore che io chiamo cs 
# (100): argomento che indica i livelli per ciascun colore
cs <- colorRampPalette(c("dark blue","light blue","pink","red"))(100)

# library(rasterVis) 
# funzione levelplot: crea un grafico dove mette a confronto le immagini sviluppate in tempi diversi utilizzando un'unica legenda 
levelplot(cruz,col.regions=cs,main="Deforestazione a Santa Cruz")
# Si nota in rosa e rosso l'aumento delle aree soggette ad urbanizzazione e la conseguete diminuzione della vegetazione

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# 3. INDICI DI VEGETAZIONE - NDVI 

# NDVI = NIR - red / NIR + red 
# - 1 < NDVI < 1 

# associo dei nomi immediati alle bande:
nir1 <- At1989$X19890811_Cruz.Intro.2
red1 <- At1989$X19890811_Cruz.Intro.3
nir2 <- At2021$X20210819_Cruz.Intro.2
red2 <- At2021$X20210819_Cruz.Intro.3

# scelgo una gamma di colori
clr <- colorRampPalette(c('dark blue', 'yellow', 'red', 'black'))(100)

# Calcolo l' NDVI per l'immagine del 1989:
ndvi1 <- (nir1 - red1) / (nir1 + red1)
plot(ndvi1, col=clr, main="NDVI 1989") 
# legenda:
#     rosso scuro : NDVI alto, vegetazione sana
#     giallo: NDVI basso, aree di deforestazione 


# Calcolo il NDVI per l'immagine del 2021:
ndvi2 <- (nir2 - red2) / (nir2 + red2)
plot(ndvi2, col=clr, main="NDVI 2021") 
# Legenda:
#    rosso scuro: NDVI alto, vegetazione sana 
#    giallo: NDVI basso, aree di deforestazione --> si nota un forte aumento di quest'area 

# metto le due immagini risultanti a confronto in un grafico con una riga e due colonne
par(mfrow=c(1,2))
plot(ndvi1, col=clr, main="NDVI 1989")
plot(ndvi2, col=clr, main="NDVI 2021")
# si nota un forte aumento delle aree gialle a cui si associa uno sviluppo di aree industrializzate a sfavore della vegetazione

# Cambiamento della vegetazione dal 1989 al 2021
# Differenza tra i due NDVI nei due tempi:
cld <- colorRampPalette(c('dark blue', 'white', 'red'))(100)
diffndvi <- ndvi1 - ndvi2
levelplot(diffndvi, col.regions=cld, main="NDVI 1989 - NDVI 2021")
# legenda:
#       rosso\rosa: > diff -> aree con la maggior perdita di vegetazione per l'aumento delle zone a scopi agricoli
#       bianco: < diff -> aree con vegetazione rimasta sana e intatta, sono pochissime 

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# 4. VARIABILITA' SPAZIALE - ANALISI DELLE COMPONENTI PRINCIPALI

# La variabilità spaziale è un indice di biodiversità, vado a controllare quanto è eterogenea questa area
# > eterogeneità -> > biodiversità attesa 
# MOVING WINDOW: analizzo la variabilità spaziale tramite una tecnica chiamata moving window, ovvero sull'immagine originale si fa scorrere una moving window di nxn pixel 
#                e calcola un'operazione (da noi richiesta) per poi riportare il risultato sul pixel centrale 
#                poi la finestra mobile si muove nuovamente di un pixel verso destra e riesegue l'operazione per riportare il risultato sul nuovo pixel centrale
#                in questo modo si crea una nuova mappa finale i cui pixel periferici NON contengono valori, i pixel centrali hanno il risultato da noi calcolato 


# DEVIAZIONE STANDARD: calcolo la ds perchè è correlata con la variabilità 
# per calcolarla ci serve solo una banda, dunque bisogna compattare tutte le informazioni relative alle diverse bande in un unico strato

# ANALISI DELLE COMPONENTI PRINCIPALI
# faccio l'analisi multivariata per ottenere la PC1 e su questa calcolo la deviazione standard

# PCA immagine At1989
# library(RStoolbox)
# funzione rasterPCA: fa l'analisi delle componeneti principali di un det di dati
a1pca <- rasterPCA(At1989) 

# funzione summary: fornisce un sommario del modello, voglio sapere quanta variabilità spiegano le varie PC
summary(a1pca$model)
# Importance of components:
#                            Comp.1      Comp.2     Comp.3 Comp.4
# Standard deviation     63.0442687 13.64672392 7.12421155      0
# Proportion of Variance  0.9437294  0.04421942 0.01205119      0
# Cumulative Proportion   0.9437294  0.98794881 1.00000000      1


# La  prima componente principale (PC1) è quella che spiega il 94,3% dell’informazione originale

a1pca
# $call
# rasterPCA(img = At1989)

# $model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])

# Standard deviations:
#    Comp.1    Comp.2    Comp.3    Comp.4 
# 63.044269 13.646724  7.124212  0.000000 

# 4  variables and  833000 observations.

# $map
# class      : RasterBrick 
# dimensions : 833, 1000, 833000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 833  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      :        PC1,        PC2,        PC3,        PC4 
# min values : -100.22022, -203.56056,  -76.41799,    0.00000 
# max values :   340.6138,   117.7007,   162.0119,     0.0000 


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
a1 <- ggplot() + geom_raster(pc1sd3a1, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 in 1989 by inferno color scale")
a1
# Legenda:
#    giallo: aumento della sd al passaggio tra suolo e acqua  
#    viola: bassa sd che individua la città e le strade
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
# nel 2021:c'è un forte aumento della parte urbanizzata con conseguente riduzione della porzione di vegetazione

# ----------------------- -----------------------------------------------------------------------------------------------------------------------------------------

# 5. GENERAZIONE DI MAPPE DI LAND COVER E CAMBIAMENTO DEL PAESAGGIO 


# Unsupervised classification  -> processo che accorpa pixel con valori simili, una volta che questi pixel sono stati accorpati rappresentano una classe
# Il Software crea un Training Set: prende un certo n. di pixel come campione e misura le riflettanze nelle varie bande
# Dopodichè classifica tutti gli altri pixel dell'immagine in funzione del training set (precedentemente creato) e forma le classi
# Maximum Likelihood: si prende pixel per pixel e il software misura la distanza che ogni pixel ha (nello spazio multispettrale) dai pixel del training set 
#                     in base alla distanza più breve li inserisce nelle varie classi e infine associa ogni classe ad una label 
# library(RStoolbox) 
# funzione unsuperClass: opera la classificazione non supervisionata
# funzione set.seed: serve per fare una classificazione che sia sempre la stessa (usa sempre le stesse repliche per fare il modello) 
set.seed(42)

# Classificazione NON supervisionata per l'immagine del 1989
# 3 classi: classe Vegetazione - classe Aree industrializzate - classe Acqua
p1c <- unsuperClass(At1989, nClasses=3)

# controllo le informazioni

# unsuperClass results
p1c
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 833, 1000, 833000  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 833  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 3  (min, max)


# facciamo il plot totale, sia di p1c che della sua mappa all'interno
plot(p1c$map)
# Classe 1: vegetazione
# Classe 2: acqua
# Classe 3: aree industrializzate

# Frequencies p1c$map 
# ci chiediamo quanta % di foresta è stata persa 
# qual è la frequenza delle 3 classi  
# funzione freq: funzione generale che genera tavole di frequenza e va a calcolarla
freq(p1c$map)
#      value  count
# [1,]     1 696499
# [2,]     2  38391
# [3,]     3  98110
    

# calcoliamo la proporzione dei pixel per l'immagine p1c (consiste nella %)
# facciamo la somma dei valori di pixel e la chiamiamo s1
s1 <- 696499 + 38391 + 98110 
s1
# 833000
prop1 <- freq(p1c$map) / s1 
prop1
#            value      count
# [1,] 1.200480e-06 0.83613325 -> 83,6% vegetazione
# [2,] 2.400960e-06 0.04608764 -> 4,6% acqua
# [3,] 3.601441e-06 0.11777911 -> 11,8% aree industrializzate 


# Classificazione NON supervisionata per l'immagine del 2021
# 5 classi:
set.seed(42)
p2c <- unsuperClass(At2021, nClasses=3)

p2c
# unsuperClass results

# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 833, 1000, 833000  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 833  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 3 (min, max)



plot(p2c$map)
# Classe 1: aree industrializzate 
# Classe 2: acqua
# Classe 3: vegetazione

# Frequencies p2c$map 
freq(p2c$map)
#      value  count
# [1,]     1 289074
# [2,]     2 284784
# [3,]     3 259142
  
# facciamo la somma dei valori di pixel e la chiamiamo s2
s2 <- 289074 + 284784 + 259142
s2
# 833000
prop2 <- freq(p2c$map) / s2
prop2 

#           value     count
# [1,] 1.200480e-06 0.3470276 -> 34,7% aree industrializzate
# [2,] 2.400960e-06 0.3418776 -> 34,2% acqua
# [3,] 3.601441e-06 0.3110948 -> 31,1% vegetazione


# Metto a confronto le due immagini classificate in un grafico con una riga e due colonne: 
par(mfrow=c(1,2))
plot(p1c$map)
plot(p2c$map)

# DataFrame 
# creo una tabella con 2 colonne
# copertura: vegetazione - aree industrializzate 
# prima colonna -> % di classi dell'immagine p1c ->  percent_1986
# seconda colonna -> % di classi dell'immagine p2c -> percent_2021

copertura <- c("Veg","Ind")
percent_1989 <- c(83.6, 11.8 ) 
percent_2021 <- c(31.1, 34.7) 

# creiamo il dataframe
# funzione data.frame: crea una tabella
# argomenti della funzione: sono le 3 colonne che ho appena creato
percentage <- data.frame(copertura, percent_1989, percent_2021)
percentage
#              copertura percent_1989 percent_2021
# 1           Vegetazione         83.6         31.1
# 2 Aree industrializzate         11.8         34.7


# plotto il Dataframe con ggplot
# p1c -> creo il grafico per l'immagine del 1989 (At1989)
# library(ggplot2) 
# funzione ggplot
#         (nome del dataframe, aes(x=prima colonna, y=seconda colonna, color=copertura))
#          +
#         geom_bar(stat="identity", fill="white")

# color: si riferisce a quali oggetti vogliamo discriminare/distinguere nel grafico e nel nostro caso vogliamo discriminare le tre classi (copertura) 
# geom_bar: tipo di geometria del grafico perchè dobbiamo fare delle barre
# stat: indica il tipo di dati che utilizziamo e sono dati grezzi quindi si chiamano "identity" 
# fill: colore delle barre all'interno e mettiamo "white" 

p1 <- ggplot(percentage, aes(x=copertura, y=percent_1989, color=copertura))  +  geom_bar(stat="identity", fill="white") + ylim(0, 95)
p1


# p2c -> creo il grafico per l'immagine del 2021 (At2021)  
# funzione ggplot 
p2 <- ggplot(percentage, aes(x=copertura, y=percent_2021, color=copertura))  +  geom_bar(stat="identity", fill="white") + ylim(0, 95)
p2

# funzione grid.arrange: mette insieme dei vari plot di ggplot con le immagini
# library(gridExtra) for grid.arrange
# argomenti: p1, p2, numero di righe = 1  
grid.arrange(p1, p2, nrow=1)
# Le aree industriliazzate sono aumentate nel tempo come percentuale, mentre è diminuita la % di vegetazione

