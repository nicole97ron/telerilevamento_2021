# R_code_land_cover.r

# inseriamo le library da utilizzare
library(raster)
library(RStoolbox) # classification
library(ggplot2)
library(gridExtra)

# settiamo la working directory
setwd("C:/lab/") 

# NR 1, RED 2, GREEN 3
# questi sono i numeri associati alle bande

defor1 <- brick("defor1.jpg")
plotRGB(defor1, r=1, g=2, b=3, stretch="lin")
# con la funzione "ggRGB" si ottiene un'immagine contenente le coordinate x e y, che non sono però riferite ad un reale sistema di riferimento
ggRGB(defor1, r=1, g=2, b=3, stretch="lin")

# facciamo la stessa operazione per la seconda immagine
defor2 <- brick("defor2.jpg")
plotRGB(defor2, r=1, g=2, b=3, stretch="lin")
ggRGB(defor2, r=1, g=2, b=3, stretch="lin")

# possiamo visuliazzare le due immagini una accanto all'altra con la funzione par
par(mfrow=c(1,2))
plotRGB(defor1, r=1, g=2, b=3, stretch="lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="lin")

# per visualizzare contemporaneamente le immagini ggRGb si utilizza la funzione "grid.arrange"
# associamo ad ogni plot un nome
p1 <- ggRGB(defor1, r=1, g=2, b=3, stretch="lin")
p2 <- ggRGB(defor2, r=1, g=2, b=3, stretch="lin")
grid.arrange(p1, p2, nrow=2)
# questa funzione unisce varie immagini all'interno di un grafico 

# unsupervised classification
# associamo un nome alla funzione unsuperclass riferita all'immagine defor1
d1c <- unsuperClass(defor1, nClasses=2)
# si scelgono due classi, una riguarda la foresta e l'altra l'agricolo
# ora visualizziamo la mappa tramite la funzione plot 
plot(d1c$map)
# classe 1 è associata alla parte agricola e la classe 2 è associata alla foresta (si potrebbe ottenere anche il risultato opposto)

# creiamo la seconda mappa 
d2c <- unsuperClass(defor2, nClasses=2)
plot(d2c$map)
# classe 1: agricolo, classe 2: foresta

# classifichiamo l'immagine defor 2 utilizzando 3 classi
d2c3 <- unsuperClass(defor2, nClasses=3)
plot(d2c3$map)
# otteniamo una mappa in cui la porzione agricola è stata ulteriormente suddivisa 

# calcoliamo la porzione di foresta persa
freq(d1c$map)
# la funzione "freq" permette di valutare la frequenza dei pixel di una data classe 
#  value  count
# [1,]     1  35281
# [2,]     2 306011
# somma
s1 <- 35281 + 306011
# calcoliamo la proporzione
prop1 <- freq(d1c$map)/ s1
prop1
# value             count
# [1,] 2.930042e-06 0.1033748, prop agriculture
# [2,] 5.860085e-06 0.8966252, propr forest

# facciamo lo stesso per la seconda mappa
s2 <- 342726
prop2 <- freq(d2c$map) / s2
prop2
#      value       count
# [1,] 2.917783e-06 0.5213932, prop forest
# [2,] 5.835565e-06 0.4786068, prop agriculture

# generiamo un dataframe
cover <- c("Forest","Agriculture")
# forest e agriculture sono le componenti di cover 
# essendo la colonna cover composta da due componenti si deve inserire la c
percent_1992 <- c(89.66, 10.34)
percent_2006 <- c(52.14, 47.86)
# la funzione "data.frame" permette di creare un dataframe in R
percentages <- data.frame(cover, percent_1992, percent_2006)
# associamo la funzione ad un nome
percentages

# creiamo un grafico
# utilizziamo la funzione ggplot
ggplot(percentages, aes(x=cover, y=percent_1992, color=cover)) + geom_bar(stat="identity", fill="white")
# aes= aestetics, in questa parte della funzione si inseriscono le colonne e il colore (quali oggetti si vogliono discriminare nel grafico)
# geom_bar, definisce la geometria, in questo caso sono delle barre
# stat, definisce il tipo di dato, in questo caso sono dati grezzi quindi "identity"
# fill, definisce il colore interno 
# facciamo la stessa operazione per il plot del 2006
ggplot(percentages, aes(x=cover, y=percent_2006, color=cover)) + geom_bar(stat="identity", fill="white")

# creiamo un unico grafico
# associamo i plot ad un nome
p1 <- ggplot(percentages, aes(x=cover, y=percent_1992, color=cover)) + geom_bar(stat="identity", fill="white")
p2 <- ggplot(percentages, aes(x=cover, y=percent_2006, color=cover)) + geom_bar(stat="identity", fill="white")
grid.arrange(p1, p2, nrow=1)
                                                                              
