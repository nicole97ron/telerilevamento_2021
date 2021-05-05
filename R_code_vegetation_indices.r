# R_code_vegetation-indices
# carichiamo le librerie
library(raster)
library(RStoolbox) # for vegetation indices calculation
library(rasterdiv) # for the worldwide NDVI
library(rasterVis)
# settiamo la working directory
setwd("C:/lab/")
# carichiamo le immagini utilizzando la funzione brick
defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg")
# b1= NIR, b2= red, b3= green

# visualizziamo le due immagini insieme creando un par
par(mfrow=c(2,1))
plotRGB(defor1, r=1, g=2, b=3, stretch="lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="lin")

# different vegetation index
defor1
# in questo modo otteniamo le informazioni relative all'immagine
# calcoliamo l'indice di vegetazione della prima immagine
dvi1 <- defor1$defor1.1 - defor1$defor1.2
# si ottiene una mappa formata da pixel che sono dati dalla differezza tra l'infrarosso e il rosso 
# visualizziamo la mappa con la funzione plot
plot(dvi1)
# questa mappa mostra lo stato di salute della vegetazione
# ora modifchiamo la colorRampPalette
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) 
# visualizziamo l'immagine con i nuovi colori assegnati
plot(dvi1, col=cl)

# facciamo la stessa cosa per la seconda immagine
defor2
# in questo modo visualizziamo il nome delle bande associate a questa immagine
dvi2 <- defor2$defor2.1 - defor2$defor2.2
plot(dvi2)
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) 
# visualizziamo l'immagine con i nuovi colori assegnati
plot(dvi2, col=cl)
# la parte gialla della mappa indica le zone in cui non è più presente vegetazione

# visualizziamo le due immagini assieme con la funzione par
par(mfrow=c(2,1))
plot(dvi1, col=cl, main="DVI at time 1")
plot(dvi2, col=cl, main="DVI at time 2")

# facciamo la differenza tra le due mappe
difdvi <- dvi1 - dvi2
# utilizziamo una colorRampPalette diversa
cld <- colorRampPalette(c('blue','white','red'))(100)
plot(difdvi, col=cld)
# ottengo una mappa in cui dove la differenza è maggiore il colore sarà rosso per cui indica dove c'è stata unaperdita maggiore della vegetazione nel tempo

# ndvi1
# (NIR-RED) / (NIR+ RED)
ndvi1 <- (defor1$defor1.1 - defor1$defor1.2) / (defor1$defor1.1 + defor1$defor1.2)
plot(ndvi1, col=cl)

ndvi2 <- (defor2$defor2.1 - defor2$defor2.2) / (defor2$defor2.1 + defor2$defor2.2)
plot(ndvi2, col=cl)

# for vegetation indices calculation
# spectral indices
# con questa funzioni si calcolano tutti gli indice e vengono inseriti tutti in un'unica immagine
vi1 <- spectralIndices(defor1, green = 3, red = 2, nir = 1)
plot(vi1, col=cl)
# facciamo lo stesso per la seconda immagine
vi2 <- spectralIndices(defor2, green = 3, red = 2, nir = 1)
plot(vi2, col=cl)

# for the worldwide NDVI
plot(copNDVI)
# otteniamo una mappa del NDVI a livello globale
copNDVI <- reclassify(copNDVI, cbind(253:255, NA))
# questa funzione permette di modificare dei valori, in questo caso eliminiamo la parte dell'immagine relativa all'acqua
plot(copNDVI)

#rasterVis package needed
levelplot(copNDVI)

