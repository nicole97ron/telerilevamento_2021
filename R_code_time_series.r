# TIME SERIES ANALYSIS
# Analizziamo l'incremento della temperatura in Groenlandia

# install.packages("raster")
library(raster)
# percorso Windows per lavorare con la cartella greenland che si trova dentro la cartella lab
setwd("C:/lab/greenland")

lst_2000 <- raster("lst_2000.tif")
# Con questa funzione associamo l'azione raster all'oggetto lst_2000
# In questo modo importiamo il primo dataset relativo al 2000
plot(lst_2000)
# Ora importiamo il dato relativo al 2005
lst_2005 <- raster("lst_2005.tif")
plot(lst_2005) 
# Ora importiamo il dato relativo al 2010
lst_2010 <- raster("lst_2010.tif")
plot(lst_2010) 
# Ora importiamo il dato relativo al 2015
lst_2015 <- raster("lst_2015.tif")
plot(lst_2015) 
# ESERCIZIO: creare un multiframe composto da 2 righe e 2 colonne
par(mfrow=c(2,2))
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)

# FUNZIONE LAPPLY
# la funzione "lapply" permette di applicare una funzione ad una lista di file 
# la funzione "list.files" permette di creare una lista di file 
# il pattern è l'elemento che hanno in comune i vari file
rlist <- list.files(pattern="lst")
rlist
# in questo caso tutti i file sono denominati con il termine "lst"
import <- lapply(rlist,raster)
# in questo caso la funzione da applicare alla lista di file è la funzione "raster"
import
# la funzione "stack" crea un gruppo di file raster defintio "rasterstack"
TGr <- stack(import)
plot(TGr)
plotRGB(TGr, 1, 2, 3, stretch="Lin")
