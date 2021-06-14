#R_code_no2.r 
library(Rstoolbox)
#1 Settiamo la working directory
setwd("C:/lab/EN/")

#2  importiamo il primo set (EN01)
library(raster)
EN01 <- raster("EN_0001.png")

#3 plottiamo l'immagine con la Colorramppalette preferita
cls <- colorRampPalette(c("red","pink","orange","yellow")) (200)
plot(EN01, col=cls)

#4 Importiamo l'ultima immagine e la plottiamo
EN13 <- raster("EN_0013.png")
cls <- colorRampPalette(c("red","pink","orange","yellow")) (200)
plot(EN13, col=cls)

# 5 facciamo la differenza tra le due immagini e la plottiamo 
ENdif <- EN13 - EN01
plot(ENdif, col=cls)
# le zone gialle sono quelle che indicano la massima differenziazione tra le due immagini
     
# 6 ora plottiamo tutto assieme 
par(mfrow=c(3,1))
plot(EN01, col=cls, main="NO2 in January")
plot(EN13, col=cls, main="NO2 in March")
plot(ENdif, col=cls, main="Difference (January - March)")

# 7 importiamo l'intero set di bande
rlist <- list.files(pattern="EN")
import <- lapply(rlist,raster)
import
EN <- stack(import)
plot(EN, col=cls)

# 8. Replicate the plot of images 1 and 13 using the stack
par(mfrow=c(2,1))
plot(EN$EN_0001, col=cls)
plot(EN$EN_0013, col=cls)
 
# 9. facciamo una PCA sulle 13 immagini

