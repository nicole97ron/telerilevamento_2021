# il mio primo codice in R per il telerilevamento
# la funzione install-packages serve a scaricare ed installare file locali in R
install.packages("raster")
#inserisco le virgolette ogni volta che il file si trova all'esterno di R
# la funzione library, serve a caricare pacchetti aggiuntivi in R
library(raster)
# siccome il pacchetto raster è gia inserito in R non sono più necesserie le virgolette
#la funzione setwd serve per definire la directory di lavoro
setwd("C:/lab/") # Windows
# la funzione brick serve ad importare un'immagine satellitare
# creiamo questa formula per poter associare la funzione ad un dato oggetto
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# le virgolette sono necessarie perchè questo file si trova all'esterno di R
p224r63_2011
#questo numero identifica l'area di studio di riferimento, il primo numero indica la sinusoide e il secondo la riga 
#la funzione "plot" serve a creare dei grafici in R
plot(p224r63_2011)
#colour change, scegliamo una scala di colori dal nero al grigio chiaro
cl <- colorRampPalette(c("black","grey","light grey")) (100)
plot(p224r63_2011, col=cl)
#utilizzo la stessa formula di prima ma cambio i colori
cl <- colorRampPalette(c("blue","red","pink")) (100)
plot(p224r63_2011, col=cl)
# Bande Landsat
# B1: blu
# B2: verde
# B3: rosso
# B4: infrarosso vicino 
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio 
# la funzione "dev.off" ripulisce la finestra grafica
dev.off() 
#la banda del blu è B1_sre 
plot(p224r63_2011$B1_sre)
#con $ leghiamo la banda 1 all'immagine completa
#esercizio: plottare la banda 1 con una scala di colori a libera scelta
plot(p224r63_2011$B1_sre, col=cl)
#ripulisco la finestra grafica
dev.off()
#la funzione "par" serve per settare i parametri grafici
par(mfrow= c(1,2)) #se inserisco prima il numero di colonne par(mfcol...)
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
#mf= multiframe
#c= (1,2) vettore composto da una riga e due colonne
#esercizio: plottare le prime 4 bande di Landsap
par(mfrow=c(4, 1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
# a quadrat of bands...:
par(mfrow=c(2,2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
# esercizio: plottiamo le prime 4 bande in un quadrato 2x2, per ogni banda assegniamo una colorRampPalette associata al sensore della banda
par(mfrow=c(2,2)) 
# B1(blu): colorRampPalette blue
clb <- colorRampPalette(c("dark blue","blue","light blue")) (100)
plot(p224r63_2011$B1_sre, col=clb)
# B2(verde): colorRampPalette green
clg <- colorRampPalette(c("dark green","green","light green")) (100)
plot(p224r63_2011$B2_sre, col=clg)
# B3(rosso): colorRampPalette red
clr <- colorRampPalette(c("dark red","red","pink")) (100)
plot(p224r63_2011$B3_sre, col=clr)
# B4(infrarosso vicino): colorRampPalette basata sui gialli
clnir <- colorRampPalette(c("red","orange","yellow")) (100)
plot(p224r63_2011$B4_sre, col=clnir)
