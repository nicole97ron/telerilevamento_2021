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
