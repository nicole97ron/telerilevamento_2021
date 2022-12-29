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
# funzione lapply: applica la funzione (in questo caso raster) a tutta la lista di file appena creata
# funzione raster: importa singoli strati e crea un oggetto chiamato raster layer
importa <- lapply(lista, raster)
# funzione stack: raggruppa i file appena importati in un unico blocco di file 
athabasca <- stack(importa) 

# funzione colorRampPalette: cambio la scala di colori di default proposta dal software con una gradazione di colori che possa marcare le differenze nei due periodi
# ogni colore è un etichetta scritta tra "" e sono diversi caratteri di uno stesso argomento dunque vanno messi in un vettore c 
# (100): argomento che indica i livelli per ciascun colore
cs <- colorRampPalette(c("dark blue","light blue","pink","red"))(100)

# library(rasterVis) 
# funzione levelplot: crea un grafico dove mette a confronto le due immagini in tempi diversi utilizzando un'unica legenda 
levelplot(athabasca, col.regions=cs, main="Sviluppo delle miniere a cielo aperto nella provincia di Alberta", names.attr=c("2022" , "1986"))
# Si nota in rosa e rosso l'aumento delle miniere a cielo aperto e la diminuzione della foresta boreale 

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------


# 3. INDICI DI VEGETAZIONE - NDVI 

# NDVI = NIR - red / NIR + red 
# - 1 < NDVI < 1 

# associo dei nomi immediati alle bande:
nir1 <- At1986$X19860716_RondoniaIntro.2
red1 <- At1986$X19860716_RondoniaIntro.3
nir2 <- At2022$X20220727_RondoniaIntro.2
red2 <- At2022$X20220727_RondoniaIntro.3

clr <- colorRampPalette(c('dark blue', 'yellow', 'red', 'black'))(100)

# Calcolo il NDVI per l'immagine del 1989:
ndvi1 <- (nir1 - red1) / (nir1 + red1)
plot(ndvi1, col=clr, main="NDVI 1986")
# legenda:
#     rosso: NDVI alto, foresta borale sana e intatta
#     giallo: NDVI basso, aree di deforestazione per l'agricoltura


# Calcolo il NDVI per l'immagine del 2022:
ndvi2 <- (nir2 - red2) / (nir2 + red2)
plot(ndvi2, col=clr, main="NDVI 2022") 
# Legenda:
#    rosso scuro: NDVI alto, foresta borale sana e intatta
#    giallo: NDVI basso, aree di deforestazione per l'agricoltura, si nota un forte aumento di quest'area 

# metto le due immagini risultanti a confronto in un grafico con una riga e due colonne
par(mfrow=c(1,2))
plot(ndvi1, col=clr, main="NDVI 1986")
plot(ndvi2, col=clr, main="NDVI 2022")

# Cambiamento della vegetazione dal 1989 al 2014
# Differenza tra i due NDVI nei due tempi:
cld <- colorRampPalette(c('dark blue', 'white', 'red'))(100)
diffndvi <- ndvi1 - ndvi2
levelplot(diffndvi, col.regions=cld, main="NDVI 1986 - NDVI 2022")
# legenda:
#       rosso: > diff -> aree con la maggior perdita di vegetazione per l'aumento delle zone a scopi agricoli
#       bianco: < diff -> aree con foresta boreale sana e intatta

# 4. VARIABILITA' SPAZIALE - ANALISI DELLE COMPONENTI PRINCIPALI

# La variabilità spaziale è un indice di biodiversità, vado a controllare quanto è eterogenea questa area
# > eterogeneità -> > biodiversità attesa 
# MOVING WINDOW: analizzo la variabilità spaziale tramite una tecnica chiamata moving window, ovvero sull'img originale si fa scorrere una moving window di nxn pixel 
#                e calcola un'operazione (da noi richiesta) per poi riportare il risultato sul pixel centrale 
#                poi la finestra mobile si muove nuovamente di un pixel verso destra e riesegue l'operazione per riportare il risultato sul nuovo pixel centrale
#                in questo modo si crea una nuova mappa finale i cui pixel periferici NON contengono valori, i pixel centrali hanno il risultato da noi calcolato 


# DEVIAZIONE STANDARD: calcolo la ds perchè è correlata con la variabilità siccome racchiude il 68% di tutte le osservazioni
# per calcolarla ci serve solo una banda, dunque bisogna compattare tutte le informazioni relative alle diverse bande in un unico strato

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# ANALISI DELLE COMPONENTI PRINCIPALI
# faccio l'analisi multivariata per ottenere la PC1 e su questa calcolo la deviazione standard

# PCA immagine At1986
# library(RStoolbox)
# funzione rasterPCA: fa l'analisi delle componeneti principali di un det di dati
a1pca <- rasterPCA(At1986) 

# funzione summary: fornisce un sommario del modello, voglio sapere quanta variabilità spiegano le varie PC
summary(a1pca$model)
# Importance of components:
#                           Comp.1      Comp.2     Comp.3 Comp.4
# Standard deviation     45.1888166 10.34733841 5.21745568      0
# Proportion of Variance  0.9382952  0.04919658 0.01250821      0
# Cumulative Proportion   0.9382952  0.98749179 1.00000000      1

# La  prima componente principale (PC1) è quella che spiega il 93,8% dell’informazione originale

a1pca
# $call
# rasterPCA(img = At1986)

# $model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])

# Standard deviations:
#   Comp.1    Comp.2    Comp.3    Comp.4 
# 45.188817 10.347338  5.217456  0.000000 

# 4  variables and  901000 observations.

# $map
# class      : RasterBrick 
# dimensions : 901, 1000, 901000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 901  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      :        PC1,        PC2,        PC3,        PC4 
# min values :  -96.35116, -144.62571, -107.14637,    0.00000 
# max values :   343.7579,   214.1922,   112.5851,     0.0000 


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
#    giallo: aumento della sd al passaggio tra suolo e fiume e anche al passaggio tra foresta e prateria 
#    violetto: bassa sd che individua la città, le miniere e le strade
#    nero: bassa sd che indica una copertura omogenea di foresta boreale e una copertura omogenea di prateria coltivata 


# PCA per l'immgine At2022
a2pca <- rasterPCA(At2022) 

summary(a2pca$model)
# Importance of components:
#                           Comp.1      Comp.2      Comp.3 Comp.4
# Standard deviation     109.6200950 14.22142803 5.550324868      0
# Proportion of Variance   0.9809745  0.01651064 0.002514862      0
# Cumulative Proportion    0.9809745  0.99748514 1.000000000      1


# La prima componente principale (PC1) è quella che spiega il 78.8% dell’informazione originale

a2pca
# $call
# rasterPCA(img = At2022)

# $model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])

# Standard deviations:
#    Comp.1     Comp.2     Comp.3     Comp.4 
# 109.620095  14.221428   5.550325   0.000000 

# 4  variables and  901000 observations.

# $map
# class      : RasterBrick 
# dimensions : 901, 1000, 901000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 901  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      :        PC1,        PC2,        PC3,        PC4 
# min values : -158.43858, -237.05223,  -84.81647,    0.00000 
# max values :  282.67540,  117.91672,   79.39467,    0.00000 


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
a2 <- ggplot() + geom_raster(pc1sd3a2, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 in 2022 by inferno color scale")
a2

# Legenda
#     giallo: sd alta -> individua il passaggio da foresta a prateria 
#     violetto: sd media -> individua strade, miniere e la parte urbana a sud
#     nero: sd molto bassa -> copertura omogenea di foresta boreale e di prateria coltivata 


grid.arrange(a1, a2, nrow=1) 
# con le due immagini a confronto si nota la differenza nell'uso del suolo nei due periodi:
#       nel 2014: c'è l'aumento della superficie delle miniere e l'aumento delle strade rispetto al 1989 con perdita di copertura forestale

# ----------------------- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 5. GENERAZIONE DI MAPPE DI LAND COVER E CAMBIAMENTO DEL PAESAGGIO 


# Unsupervised classification  -> processo che accorpa pixel con valori simili, una volta che questi pixel sono stati accorpati rappresentano una classe
# Come si comportano i pixel nello spazio multispettrale definito dalle bande come assi
# Il Software crea un Training Set: prende un certo n. di pixel come campione e misura le riflettanze nelle varie bande
# Dopodichè classifica tutti gli altri pixel dell'immagine in funzione del training set (precedentemente creato) e forma le classi
# Maximum Likelihood: si prende pixel per pixel e il software misura la distanza che ogni pixel ha (nello spazio multispettrale) dai pixel del training set 
#                     in base alla distanza più breve li inserisce nelle varie classi e infine associa ogni classe ad una label 
# library(RStoolbox) 
# funzione unsuperClass: opera la classificazione non supervisionata
# funzione set.seed: serve per fare una classificazione che sia sempre la stessa (usa sempre le stesse repliche per fare il modello) 
set.seed(42)

# Classificazione NON supervisionata per l'immagine del 1989 
# 5 classi: però mi interessa solo: classe vegetazione - classe miniere - classe acqua
p1c <- unsuperClass(At1986, nClasses=5)

# controllo le informazioni
p1c
# unsuperClass results

# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 901, 1000, 901000  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 901  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : r_tmp_2022-12-29_130547_10844_66214.grd 
# names      : layer 
# values     : 1, 5  (min, max)


# facciamo il plot totale, sia di d1c che della sua mappa all'interno
plot(p1c$map)
# Classe 1: veg
# Classe 2: pascoli e aree coltivate
# Classe 3: acqua
# Classe 4: veg
# Classe 5: veg

# Frequencies p1c$map 
# ci chiediamo quanta % di foresta è stata persa 
# qual è la frequenza delle 5 classi  
# funzione freq: funzione generale che genera tavole di frequenza e va a calcolarla
freq(p1c$map)
#      value  count
# [1,]     1  17947 -> n. pixel vegetazione
# [2,]     2 468140 -> n. pixel pascoli e aree coltivate 
# [3,]     3  40825 -> n. pixel acqua
# [4,]     4  43205 -> n. pixel vegetazione
# [5,]     5 330883 -> n. pixel vegetazione

# calcoliamo la proporzione dei pixel per l'immagine p1c (consiste nella %)
# facciamo la somma dei valori di pixel e la chiamiamo s1
s1 <- 17947 +  468140 +  40825 + 43205 + 330883
prop1 <- freq(p1c$map) / s1 
prop1
#              value      count
# [1,] 1.109878e-06 0.01991898 -> 1,99% vegetazione
# [2,] 2.219756e-06 0.51957825 -> 51,9% pascoli e aree coltivate
# [3,] 3.329634e-06 0.04531077 -> 4,5% acqua
# [4,] 4.439512e-06 0.04795228 -> 4,8% vegetazione 
# [5,] 5.549390e-06 0.36723973 -> 36,7% vegetazione

# Classificazione NON supervisionata per l'immagine del 2022
# 5 classi:
set.seed(42)
p2c <- unsuperClass(At2022, nClasses=5)

p2c
# unsuperClass results

# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 901, 1000, 901000  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 901  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 5  (min, max)


plot(p2c$map)
# Classe 1: Acqua
# Classe 2: Miniere         
# Classe 3: veg
# Classe 4: ?
# Classe 5: Veg


# Frequencies p2c$map 
freq(p2c$map)
#     value  count
# [1,]     1 175609 -> n. pixel vegetazione
# [2,]     2 143620 -> n. pixel pascoli e terreni coltivati
# [3,]     3 383386 -> n. pixel acqua
# [4,]     4  90247 -> n. pixel vegetazione
# [5,]     5 108138 -> n. pixel veegtazione
  


# facciamo la somma dei valori di pixel e la chiamiamo s2
s2 <- 175609 + 143620 + 383386 + 90247 + 108138
prop2 <- freq(p2c$map) / s2
prop2 
#           value     count
# [1,] 1.109878e-06 0.1949046 -> 19,5%
# [2,] 2.219756e-06 0.1594007 -> 15,9%
# [3,] 3.329634e-06 0.4255117 -> 42,5%
# [4,] 4.439512e-06 0.1001632 -> 10,0%
# [5,] 5.549390e-06 0.1200200 -> 12,0%


# Metto a confronto le due immagini classificate in un grafico con una riga e due colonne: 
par(mfrow=c(1,2))
plot(p1c$map)
plot(p2c$map)

# DataFrame 
# creo una tabella con 3 colonne
# prima colonna -> copertura: prateria coltivata - foresta boreale - miniere 
# seconda colonna -> % di classi dell'immagine p1c ->  percent_1986
# terza colonna -> % di classi dell'immagine p2c -> percent_2022

copertura <- c("Vegetazione","Aree coltivate","Acqua")
percent_1986 <- c(44, 51.9, 4.5) 
percent_2022 <- c(41.5, 42.5, 15.9) 

# creiamo il dataframe
# funzione data.frame: crea una tabella
# argomenti della funzione: sono le 3 colonne che ho appena creato
percentage <- data.frame(copertura, percent_1989, percent_2014)
percentage
#   copertura    percent_1989    percent_2014
# 1 Vegetazione         95.0         81.3
# 2     Miniere          1.7         11.3
# 3       Acqua          3.2          4.4


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


# p2c -> creo il grafico per l'immagine del 2014 (At2014)  
# funzione ggplot 
p2 <- ggplot(percentage, aes(x=copertura, y=percent_2014, color=copertura))  +  geom_bar(stat="identity", fill="white") + ylim(0, 95)
p2

# funzione grid.arrange: mette insieme dei vari plot di ggplot con le immagini
# library(gridExtra) for grid.arrange
# argomenti: p1, p2, numero di righe = 1  
grid.arrange(p1, p2, nrow=1)
# Le miniere sono aumentate nel tempo come percentuale, mentre è diminuita la % di vegetazione




