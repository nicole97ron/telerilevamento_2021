# R_code_variability.r

# inseriamo le librerie necessarie
library(raster)
library(RStoolbox)
library(ggplot2) #for ggplot plotting
library(gridExtra)# for plotting ggplots together
# install.packages("viridis")
library(viridis) # per la gestione dei colori, colora i plot con ggplot in modo automatico


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
#                            Comp.1      Comp.2      Comp.3     Comp.4
# Standard deviation     77.3362848   53.5145531   5.765599616     0
# Proportion of Variance  0.6736804   0.3225753   0.003744348      0
# Cumulative Proportion   0.6736804   0.9962557   1.000000000      1

# la prima componente principale (PC1) è quella che spiega lo 0,6736 quindi circa il 67% dell’informazione originale
# a partire da questa immagine della PCA facciamo il calcolo della variabilità
# significa che calcoliamo la deviazione standard sulla PC1
# definiamo la banda con la quale vogliamo lavorare -> banda PC1
# leghiamo l'immagine sentpca alla sua mapppa e alla PC1
pc1 <- sentpca$map$PC1
# funzione focal: calcoliamo la deviazione standard sulla pc1
pc1sd5 <- focal(pc1, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
# plottiamo l'immagine pc1sd5
plot(pc1sd5, col=clsd)

# SOURCE TEST
# scarichiamo una partre di codice: source_test_lezione.r
# nel codice si calcola la deviazione standard sulla PC1 di 7x7 pixel (49 pixel possibili dentro la moving window)
# funzione source: esce da R, prende un pezzo di codice e poi lo inserisce all’interno di R, dobbiamo usare le ""
source("source_test_lezione.r")
# in questo modo otteniamo l'immagine relativa al calcolo della deviazione standard

# scarichiamo un pezzo di codice da Virtuale: source_ggplot.r
# funzione source: inseriamo in R il pezzo di codice scaricato
source("source_ggplot.r.txt")

# plottiamo con ggplot i dati
# creiamo una nuova finestra con ggplot 
# definiamo una geometria in questo caso raster
# inseriamo il nome dell'immagine
# definiamo le estetiche ovvero ciò che viene plottato, in questo caso x e y e tutti i valori al loro interno
# fill indica i valori di riempimento, in questo caso layer
# mapping definisce cosa si vuole mappare
ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer))
# otteniamo una mappa in cui siamo in grado di valutare zone che presentano discontinuità a livello ecologico, geografico e geologico

# con la funzione scale_fill_viridis utilizziamo una delle legende contenute in viridis
# The package contains eight color scales: “viridis”, the primary choice, and five alternatives with similar properties - “magma”, “plasma”, “inferno”, “civids”, “mako”, and “rocket” -, and a rainbow color map - “turbo”.
# utilizziamo la legenda di defoult 
# inseriamo il titolo con la funzione ggtitle
ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis() + ggtitle("Standard deviation of PC1 by viridis color scale") 

# utilizziamo la legenda "magma" di viridis e modifichiamo il titolo
ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="magma") + ggtitle("Standard deviation of PC1 by magma color scale") 

# ora utilizziamo la legenda "inferno" di viridis
ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 by inferno color scale")

# ora possiamo inseriere tutte le mappe di ggplot in una unica finestra con la funzione grid.arrange
# associamo ogni plot ad un oggetto
p1 <- ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis() + ggtitle("Standard deviation of PC1 by viridis color scale")
p2 <- ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="magma") + ggtitle("Standard deviation of PC1 by magma color scale")
p3 <- ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 by inferno color scale")
# inseriamo i grafici su di un'unica riga
grid.arrange(p1, p2, p3, nrow=1)

