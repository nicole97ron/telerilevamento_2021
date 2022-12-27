# R_code_multivariate_analysis.r
# Analisi multivariata: PCA (dati Landsat, 30m)
# usiamo una PCA per compattare il sistema in un numero inferiore di bande ma conservando la stessa proporzione

# librerie e working directory
library(raster)
library(RStoolbox)
setwd("C:/lab/") 

# bande di Landsat:
# b1: blu
# b2: verde
# b3: rosso 
# b4: NIR 

# funzione brick: carichiamo l'immagine intera costiuita da 7 bande (RasterBrick) 
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# plottiamo l'immagine per vedere le 7 bande
plot(p224r63_2011)
# vediamo le informazioni dell'immagine
p224r63_2011
# class: RasterBrick
# dimensions: 1499, 2967, 4.447.533, 7  (nrow, ncol, ncell, nlayers)
# resolution: 30, 30  (x, y)
# extent: 579765, 668775, -522705, -477735  (xmin, xmax, ymin, ymax)
# crs: +proj=utm +zone=22 +datum=WGS84 +units=m +no_defs 
# source:    
# names: B1_sre, B2_sre, B3_sre, B4_sre, B5_sre, B6_bt, B7_sre 
# min values: 0.000000e+00, 0.000000e+00, 0.000000e+00, 1.196277e-02, 4.116526e-03, 2.951000e+02, 0.000000e+00 
# max values:    0.1249041,    0.2563655,    0.2591587,    0.5592193,    0.4894984,  305.2000000,    0.3692634 

# correliamo la banda del blu e la banda del verde: dobbiamo plottare la banda del blu contro la banda del verde
# banda blu: B1_sre -> asse X
# banda verde: B2_sre -> asse Y
# $: leghiamo le bande all'immagine completa
# col="red": colore del plot e in questo modo i punti sono rossi
# pch=19: point character e in questo modo i punti sono dei cerchietti pieni
# cex=2: aumentiamo la dimensione dei punti
plot(p224r63_2011$B1_sre,p224r63_2011$B2_sre, col="red", pch=19, cex=2) 
# Warning message: In .local(x, y, ...): plot used a sample of 2.2% of the cells. You can use "maxpixels" to increase the sample
# i pixel da plottare sono oltre 4 milioni, dunque il sistema ci dice che plotta solo il 2.2% di questo totale
# in statistica il sistema si chiama multicollinearità: le due bande sono molto correlate tra loro e sono correlate positivamente
# le info del punto sulla X sono molto simili alle info del punto sulla Y
# spesso questa forma di correlazione è usata in modo causale

# plottiamo di nuovo la stessa immagine ma con B2_sre -> asse X e B1_sre -> asse Y 
plot(p224r63_2011$B2_sre,p224r63_2011$B1_sre, col="red", pch=19, cex=2)

# funzione pairs: serve per plottare tutte le correlazione possibili tra tutte le variabili di un dataset
# mette in correlazione a due a due tutte le variabili di un certo dataset
pairs(p224r63_2011)
# sulla diagonale vediamo tutte le bande
# parte sottostante alla diagonale: grafico che mostra la correlazione tra le bande 
# parte sopra alla diagonale: indice di correlazione che varia tra -1 e 1
# ----------------------------------------------------------------------------------------------------------------------

# la PCA è un’analisi piuttosto impattante
# funzione aggregate: ricampioniamo il dato creando un dato più leggero 
# riduciamo la dimensione dell’immagine diminuendone la risoluzione e aumentando la dimensione dei pixel, lo facciamo per tutte e 7 le bande
# fattore 10 lineare: aggreghiamo i pixel del dato iniziale di 10 volte per ottenere un dato con una risoluzione più bassa
# associamo l'oggetto p224r63_2011res (resampled) al risultato della funzione
p224r63_2011res <- aggregate(p224r63_2011, fact=10)
p224r63_2011res 
# class: RasterBrick 
# dimensions: 150, 297, 44550, 7  (nrow, ncol, ncell, nlayers)
# resolution: 300, 300  (x, y)  -> la risoluzione iniziale è diminuita, ora è di 300 m (30x10)

# per vedere la diminuzione della risoluzione nel nuovo dato facciamo un parmfrow
# 2 righe e 1 colonna
# plottiamo con plotRGB le due immagini a diversa risoluzione
# banda NIR (4) sulla componente red, banda rossa (3) sulla componente green, banda verde (2) sulla componente blue
par(mfrow=c(2,1))
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011res, r=4, g=3, b=2, stretch="Lin")
# immagine sopra: immagine dettagliata con risoluzione 30mx30m di pixel
# immagine sotto: immagine molto sgranata con risoluzione 300mx300m di pixel 

# facciamo la PCA della nuova immagine a minor risoluzione (p224r63_2011res) 
# funzione rasterPCA - Principal Component Analysis for Rasters: prende il pacchetto di dati e va a compattarli in un numero minore di bande
# associamo l'oggetto p224r63_2011res_pca al risultato della funzione
p224r63_2011res_pca <- rasterPCA(p224r63_2011res)
# ----------------------------------------------------------------------------------------------------------------------------------------------

