# R_code_multivariate_analysis.r
 
# inseriamo le library necessarie
library(raster)
library(RStoolbox)
# settiamo la working directory
setwd("C:/lab/")

# utilizziamo la funzione "brick" per caricare un set multiplo di dati (la funzione "raster" carica solo un set alla volta)
p224r63_2011<-brick("p224r63_2011_masked.grd")
p224r63_2011
# in questo modo otteniamo le informazioni riguardanti l'immagine
plot(p224r63_2011)
# plottiamo i valori della banda 1 contro quelli della banda 2
plot(p224r63_2011$B1_sre, p224r63_2011$B2_sre, col="red", pch=19, cex=2)
# pch= point caracter, 19 indica i punti, il colore dei punti sarà rosso, cex indica l'ingrandimento in questo caso x2
# si ottiene un'immagine con punti molto vicini per cui le variabili sono fortemente correlate tra loro
pairs(p224r63_2011)
# la funzione pairs plotta tutte le correlazioni possibili tra tutte le variabili del dataset a due a due
# si ottiene anche l'indice di correlazione vari atra 1 (positivo) e -1 (negativo, poca correlazione)
