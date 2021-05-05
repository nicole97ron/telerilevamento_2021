# R_code_land_cover.r

# inseriamo le library da utilizzare
library(raster)
library(RStoolbox) # classification
library(ggplot2)
library(gridExtra)

# settiamo la working directory
setwd("C:/lab/") 

defor1 <- brick("defor1.jpg")
plotRGB(defor1, r=1, g=2, b=3, stretch="lin")
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
