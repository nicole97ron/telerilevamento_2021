# R_code_variability.r

# inseriamo le librerie necessarie
library(raster)
library(RStoolbox)

# settiamo la working directory
setwd("C:/lab/")

sent <- brick("sentinel.png")
# assocciamo la funzione ad un oggetto 
# usiamo le virgolette perchè usciamo da R

# plottiamo l'immagine utilizziando la funzione plotRGB
# NIR 1, RED 2, GREEN 3
# r=1, g=2, b=3
# essendo la composizione che vogliamo quella di defoult possiamo anche evitare di inserirla
plotRGB(sent, stretch="lin") 
# otteniamo lo stesso risultato con plotRGB(sent, r=1, g=2, b=3, stretch="lin")
plotRGB(sent, r=2, g=1, b=3, stretch="lin") 
# in questo modo otteniamo un'immagine in cui tutta la vegetazione sarà verde fluorescente

sent
# in questo modo otteniamo il nome delle bande ,names: sentinel.1, sentinel.2, sentinel.3, sentinel.4
# semplifichiamo il nome delle bande, associandole ad un nuovo nome
nir <- sent$sentinel.1
red <- sent$sentinel.2

# calcoliamo l'NDVI (indice di vegetazione)
ndvi <- (nir-red) / (nir+red)
# viasulizziamo l'immagine con la funzione plot
plot(ndvi)
# le parti bianche dell'immagine indicano l'assenza di vegetazione mentre le parti delle praterie sono quelle verde scuro
# modifichiamo la colorRampPalette
cl <- colorRampPalette(c('black','white','red','magenta','green'))(100)
# plottiamo l'ndvi con la nuova palette
plot(ndvi,col=cl)

# DEVIAZIONE STANDARD
# funzione focal
ndvisd3 <- focal(ndvi, w=matrix(1/9, nrow=3, ncol=3), fun=sd)
# w= window ovvero indica una matrice in questo caso formata da 9 pixel con 3 righe e 3 colonne
# sd= standard deviation
# associamo la funzione ad un oggetto
plot(ndvisd3)
# modifichiamo la colorRampPalette
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)
plot(ndvisd3, col=clsd)
# colori rosso e giallo indentificano una variazione maggiore rispetto alle zone verdi e blu

# MEDIA
# mean ndvi with focal
ndvimean3 <- focal(ndvi, w=matrix(1/9, nrow=3, ncol=3), fun=mean)
# viene modificato unicamente fun ovvero l'operazione da calcolare
plot(ndvimean3)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)
plot(ndvimean3, col=clsd)
# si ottiene un immagine con valori molto alti nelle praterie (giallo) mentre valori minori nelle zone di roccia (rosa)

# changing window size
# deviazione standard
ndvisd5 <- focal(ndvi, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
plot(ndvisd5)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)
plot(ndvisd5, col=clsd)

# PCA
# utilizziamo rasterPCA che fa l'analisi delle componenti principali per i raster
sentpca <- rasterPCA(sent)
# associamo un oggetto alla funzione
# visualizziamo l'immagine
plot(sentpca$map)
# passando da una PC a quella successiva diminuisce il numero di informazioni
summary(sentpca$model)
# calcoliamo la proporzione di variabilità spiegata da ogni componente
# Proportion of Variance  0.6736804  0.3225753 0.003744348      0






