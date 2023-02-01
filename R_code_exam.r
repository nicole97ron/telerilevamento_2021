
# Introduzione

# R_code_esame.r  
# Athabasca Oil Sand - Alberta - Canada
# Sito utilizzato per scaricare le immagini: https://earthobservatory.nasa.gov/world-of-change/Athabasca
# Sepolto sotto la foresta boreale del Canada è una delle più grandi riserve mondiali di petrolio
# Analisi dell'aumentpo delle miniere in Canada dal 1984 al 2016 

# LIBRERIE 
# Imposto le librerie necessarie per le indagini
# funzione install.packages: funzione che installa un pacchetto situato all'esterno del software R 
# funzione library: serve per utilizzare un pacchetto

# install.packages("raster")
library(raster)                # per gestire i dati in formato raster e le funzioni associate 
# install.packages("RStoolbox") 
library(RStoolbox)             # per la classificazione non supervisionata (funzione unsuperClass) - per l'analisi delle componenti principali (funzione rasterPCA)                            
# install.packages("rasterVis")
library(rasterVis)             # per la time series analysis (funzione levelplot) 
# install.packages("ggplot2")
library(ggplot2)               # per la funzione ggRGB e per la funzione ggplot 
# install.packages(gridExtra)
library(gridExtra)             # per la funzione grid.arrange
# install.packages(viris) 
library(viridis)               # per la funzione scale_fill_viridis

# imposto la directory di lavoro
setwd("C:/esame_telerilevamento_2021/") # Windows

# Importa i file tutti insieme (invece che singolarmente) utilizzando la funzione stack
# Funzione list.files: crea un elenco di file per la funzione lapply
clist  <- list.files(pattern="athabasca_tm5") # pattern = è la scritta in comune in ogni file, nel mio caso è columbia
# per ottenere le informazioni sui file
clist
# [1] "athabasca_tm5_19840723.jpg" 
# [2] "athabasca_tm5_19890806.jpg"
# [3] "athabasca_tm5_19940726.jpg" 
# [4] "athabasca_tm5_20000913.jpg"
# [5] "athabasca_tm5_20051005.jpg" 
# [6] "athabasca_tm5_20080725.jpg"
# [7] "athabasca_tm5_20110515.jpg" 
# [8] "athabasca_tm5_20160715.jpg"

# Funzione lapply: applica alla lista dei file una funzione (raster) 
import <- lapply(clist,raster)
# per ottenre le informazioni sui file
import
# [[1]]
# class      : RasterLayer 
# band       : 1  (of  3  bands)
# dimensions : 480, 720, 345600  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 480  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : athabasca_tm5_19840723.jpg 
# names      : athabasca_tm5_19840723 
# values     : 0, 255  (min, max)


# [[2]]
# class      : RasterLayer 
# band       : 1  (of  3  bands)
# dimensions : 480, 720, 345600  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 480  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : athabasca_tm5_19890806.jpg 
# names      : athabasca_tm5_19890806 
# values     : 0, 255  (min, max)


# [[3]]
# class      : RasterLayer 
# band       : 1  (of  3  bands)
# dimensions : 480, 720, 345600  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 480  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : athabasca_tm5_19940726.jpg 
# names      : athabasca_tm5_19940726 
# values     : 0, 255  (min, max)


# [[4]]
# class      : RasterLayer 
# band       : 1  (of  3  bands)
# dimensions : 480, 720, 345600  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 480  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : athabasca_tm5_20000913.jpg 
# names      : athabasca_tm5_20000913 
# values     : 0, 255  (min, max)


# [[5]]
# class      : RasterLayer 
# band       : 1  (of  3  bands)
# dimensions : 480, 720, 345600  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 480  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : athabasca_tm5_20051005.jpg 
# names      : athabasca_tm5_20051005 
# values     : 0, 255  (min, max)


# [[6]]
# class      : RasterLayer 
# band       : 1  (of  3  bands)
# dimensions : 480, 720, 345600  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 480  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : athabasca_tm5_20080725.jpg 
# names      : athabasca_tm5_20080725 
# values     : 0, 255  (min, max)


# [[7]]
# class      : RasterLayer 
# band       : 1  (of  3  bands)
# dimensions : 480, 720, 345600  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 480  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : athabasca_tm5_20110515.jpg 
# names      : athabasca_tm5_20110515 
# values     : 0, 255  (min, max)


# [[8]]
# class      : RasterLayer 
# band       : 1  (of  3  bands)
# dimensions : 480, 720, 345600  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 480  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : athabasca_tm5_20160715.jpg 
# names      : athabasca_tm5_20160715 
# values     : 0, 255  (min, max)


# Funzione stack: raggruppa e rinomina, in un unico pacchetto, i file raster separati
AOS <- stack(import)
# Funzione per avere le info sul file
AOS
# class      : RasterStack 
# dimensions : 480, 720, 345600, 8  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 480  (xmin, xmax, ymin, ymax)
# crs        : NA 
# names      : athabasca_tm5_19840723, athabasca_tm5_19890806, athabasca_tm5_19940726, athabasca_tm5_20000913, athabasca_tm5_20051005, athabasca_tm5_20080725, athabasca_tm5_20110515, athabasca_tm5_20160715 
# min values :                      0,                      0,                      0,                      0,                      0,                      0,                      0,                      0 
# max values :                    255,                    255,                    255,                    255,                    255,                    255,                    255,                    255 

# Funzione plot: del singolo file
plot(AOS)
# Funzione plotRGB: crea plot con immagini sovrapposte
plotRGB(AOS,3,2,1,stretch="hist")
# Funzione ggr: plotta file raster in differenti scale di grigio, migliorando la qualità dell'immagine e aggiungengo le coordinate spaziali sugli assi x e y
ggRGB(AOS,r=3,g=2,b=1,stretch="hist") # "hist": amplia i valori e aumenta i dettagli

# Funzione levelplot: disegna più grafici di colore falso con una singola legenda
levelplot(AOS)
# Cambio di colori a piacimento (colorRampPalette si può usare solo su immagine singole, non su RGB)
cs <- colorRampPalette(c("dark blue","light blue","pink","red"))(100)
# Nuovo levelplot col cambio di colori, nome e titolo
levelplot(AOS,col.regions=cls,main="Sviluppo delle miniere")

#.......................................................................................................................................................................

# MULTIVARIATE ANALYSIS

# 1. Le coppie di funzioni producono una matrice di scatterplot.

# Traccia le correlazioni tra le 3 bande del mio stack.
# I valori di correlazione degli indici vanno da 0 a 1: 1= correlazione, 0 = nessuna correlazione
# Plot di tutte le correlazioni tra bande di un dataset (matrice di scatterplot di dati, non immagini)
# La tabella riporta in diagonale le bande (sono le variabili)
pairs(AOS,main="Comparation with the function pairs")
# Result= 0.81
# Indice di correlazione: più le bande sono correlate e maggiore sarà la dimensione dei caratteri

# Importazione delle singole immagini per effettuare comparazioni
# Funzione: brick, importa i singoli file per avere dati e immagini a 3 bande
# Non utilizzo la funzione raster perchè successivamente farò l'analisi della PCA nella quale servono almeno 2 bande 
AT1984 <- brick("athabasca_tm5_19840723.jpg")
AT1989 <- brick("athabasca_tm5_19890806.jpg")
AT1994 <- brick("athabasca_tm5_19940726.jpg")
AT2000 <- brick("athabasca_tm5_20000913.jpg")
AT2005 <- brick("athabasca_tm5_20051005.jpg")
AT2008 <- brick("athabasca_tm5_20080725.jpg")
AT2011 <- brick("athabasca_tm5_20110515.jpg")
AT2016 <- brick("athabasca_tm5_20160715.jpg")

par(mfrow=c(3,3))
plotRGB(AT1984, r=1, g=2, b=3, stretch="lin")
plotRGB(AT1989, r=1, g=2, b=3, stretch="lin")
plotRGB(AT1994, r=1, g=2, b=3, stretch="lin")
plotRGB(AT2000, r=1, g=2, b=3, stretch="lin")
plotRGB(AT2005, r=1, g=2, b=3, stretch="lin")
plotRGB(AT2008, r=1, g=2, b=3, stretch="lin")
plotRGB(AT2011, r=1, g=2, b=3, stretch="lin")
plotRGB(AT2016, r=1, g=2, b=3, stretch="lin")

# ora applichiamo l'algebra applicata alle matrici 
#utilizzo raster perchè non mi interessa ad avere le 3 bande divise ma una immagine con un'unica banda 
AT1984R <- raster("athabasca_tm5_19840723.jpg")
AT2016R <- raster("athabasca_tm5_20160715.jpg")
#vogliamo fare la sottrazione tra il primo e l'ultimo dato 
# $ il dollaro mi lega il file originale al file interno 
AthabascaM <- AT2016R - AT1984R
# creo una nuoca colour and palette 
clb <- colorRampPalette(c("blue","white","red"))(100)
plot(AthabascaM, col=clb) # zone rosse dove c'è un aumento delle miniere 
# usiamo level per avere una gamma di colori più dettagliata 
levelplot(AthabascaM, col.regions=clb, main="Aumento delle miniere dal 1984 al 2016")


# 2. ANALISI DELLE COMPONENTI PRINCIPALI 

# PCA delle miniere del 1989
Athabasca1989_pca <- rasterPCA(AT1989)
summary(Athabasca1989_pca$model)
# Importance of components:
#                            Comp.1    Comp.2      Comp.3
# Standard deviation     42.7757491 6.0423297 4.049529213
# Proportion of Variance  0.9718972 0.0193925 0.008710321
# Cumulative Proportion   0.9718972 0.9912897 1.000000000

plotRGB(Athabasca1989_pca$map,r=1,g=2,b=3,stretch="Hist")
plot(Athabasca1989_pca$model) # per vedere il grafico

# PCA delle miniere del 1994
Athabasca1994_pca <- rasterPCA(AT1994)
summary(Athabasca1994_pca$model)
# Importance of components:
#                           Comp.1      Comp.2      Comp.3
# Standard deviation     63.2437389 16.47561105 5.813665012
# Proportion of Variance  0.9290956  0.06305338 0.007851007
# Cumulative Proportion   0.9290956  0.99214899 1.000000000

plotRGB(Athabasca1994_pca$map,r=1,g=2,b=3,stretch="Hist")
plot(Athabasca1994_pca$model) # per vedere il grafico

# PCA del ghiacciaio Columbia 2000
Athabasca2000_pca <- rasterPCA(AT2000)
summary(Athabasca2000_pca$model)
# Importance of components:
#                            Comp.1     Comp.2     Comp.3
# Standard deviation     51.5600650 7.16316327 5.86607304
# Proportion of Variance  0.9687622 0.01869821 0.01253964
# Cumulative Proportion   0.9687622 0.98746036 1.00000000

plotRGB(Athabasca2000_pca$map,r=1,g=2,b=3,stretch="Hist")
plot(Athabasca2000_pca$model) # per vedere il grafico

# PCA delle miniere del 2005
Athabasca2005_pca <- rasterPCA(AT2005)
summary(Athabasca2005_pca$model)
# Importance of components:
#                            Comp.1      Comp.2      Comp.3
# Standard deviation     62.6774356 10.90915332 5.031464357
# Proportion of Variance  0.9645635  0.02922069 0.006215802
# Cumulative Proportion   0.9645635  0.99378420 1.000000000

plotRGB(Athabasca2005_pca$map,r=1,g=2,b=3, stretch="Hist")
plot(Athabasca2005_pca$model) # per vedere il grafico

# PCA delle miniere del 2008
Athabasca2008_pca <- rasterPCA(AT2008)
summary(Athabasca2008_pca$model)
# tance of components:
#                          Comp.1     Comp.2      Comp.3
# andard deviation     73.2133114 8.88165609 4.771771472
Proportion of Variance  0.9813884 0.01444271 0.004168887
Cumulative Proportion   0.9813884 0.99583111 1.000000000


plotRGB(Columbia2013_pca$map,r=1,g=2,b=3, stretch="Hist")
plot(Columbia2013_pca$model) # per vedere il grafico


#....................................................................................................................................................................

# NDVI - INDICI DI VEGETAZIONE 
# NDVI = NIR - rosso / NIR + rosso
# - 1 < NDVI < 1





