# R_code_vegetation-indices
# carichiamo le librerie
library(raster)
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
