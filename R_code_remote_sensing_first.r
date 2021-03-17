# il mio primo codice in R per il telerilevamento
# la funzione install.packages serve 
install.packages("raster")
# tutte le volte che esco da R per prendere qualcosa e torno dentro R devo aggiungere le virgolette 
# la funzione library, 
library(raster)
# siccome il pacchetto raster è gia inserito in R non sono più necesserie le virgolette
#
setwd("C:/lab/") # Windows
# la funzione brick serve ad importare un'immagine satellitare
# creiamo questa formula per poter associare la funzione ad un dato oggetto
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# le virgolette sono necessarie perchè questo file si trova all'esterno di R
p224r63_2011
# la funzione "plot" serve ad 
plot(p224r63_2011)
#colour change, scegliamo una scala di colori dal nero al grigio chiaro
cl <- colorRampPalette(c("black","grey","light grey")) (100)
plot(p224r63_2011, col=cl)
#colour change --> new
cl <- colorRampPalette(c("blue","red","pink")) (100)
plot(p224r63_2011, col=cl)
