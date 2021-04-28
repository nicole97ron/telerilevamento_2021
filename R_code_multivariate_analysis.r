# R_code_multivariate_analysis.r
 
# inseriamo le library necessarie
library(raster)
library(RStoolbox)
# settiamo la working directory
setwd("C:/lab/")

# utilizziamo la funzione "brick" per caricare un set multiplo di dati (la funzione "raster" carica solo un set alla volta)
p224r63_2011<-brick("p224r63_2011_masked.grd")
p224r63_2011
# in questo modo otteniamo le informazioni riguardanti l'immagine, è formata da 7 bande
plot(p224r63_2011)
# plottiamo i valori della banda 1 contro quelli della banda 2
plot(p224r63_2011$B1_sre, p224r63_2011$B2_sre, col="red", pch=19, cex=2)
# pch= point caracter, 19 indica i punti, il colore dei punti sarà rosso, cex indica l'ingrandimento in questo caso x2
# si ottiene un'immagine con punti molto vicini per cui le variabili sono fortemente correlate tra loro
pairs(p224r63_2011)
# la funzione pairs plotta tutte le correlazioni possibili tra tutte le variabili del dataset a due a due
# si ottiene anche l'indice di correlazione di Pearson che varia tra 1 (positivo) e -1 (negativo, poca correlazione)

# essendo la PCA un'analisi ingombrante, ricampioniamo il dato
# utilizziamo la funzione "aggregate" per cui aggreghiamo i pixel con una risoluzione più bassa
# per ogni banda ci sono più di 4 milioni di pixel con dimensioni 30mx30m
p224r63_2011res <- aggregate(p224r63_2011, fact=10)
# res= resampling= ricampionamento
# fact indica il fattore di ricampionamento ovvero di quante volte si vogliono aumentare i pixel per irdurre la risoluzione
p224r63_2011res
# otteniamo un'immagine con pixel di 300mx300m

# ora visualizziamo l'immagine ricampionata con la funzione plot
par(mfrow=c(2,1))
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="lin")
plotRGB(p224r63_2011res, r=4, g=3, b=2, stretch="lin")

# PCA= Principal Component Analysis, si usa per ridurre il set di variabili utilizzate
p224r63_2011res_pca <- rasterPCA(p224r63_2011res)
# la funzione rasterPCA
p224r63_2011res_pca
# funzione summary è una funzione base che permette di ottenere un sommario del modello
summary(p224r63_2011res_pca$model)
# otteniamo che la prima componenete spiega più del 98% della variabilità
# visualizziamo l'immagine con la funzione plot
plot(p224r63_2011res_pca$map)
#  notiamo che la prima immagine ovvero la prima componente è quella maggiormente rappresentativa
plotRGB(p224r63_2011res_pca$map, r=1, g=2, b=3, stretch="lin")
# in questo modo otteniamo un'immagine ottenuta dalla PCA in cui riduciamo la correlazione tra le variabili

