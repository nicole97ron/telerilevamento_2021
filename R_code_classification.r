# R_code_classification

# settiamo la working directory 
setwd("C:/lab/")
# scarichiamo l'immagine che rappresenta i diversi livelli energetici di una parte all'interno del Sole
# salviamo l'immmagine nella cartella lab
# utilizziamo la funzione brick che permette di caricare il pacchetto di dati in R
library(raster)
# questa è la libreria che ci serve per importare il dato
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
# con la freccia associamo la funzione ad un nome
so
# con questa funzione otteniamo tutti i parametri
# visualizziamo i tre livelli con la funzione plot
plotRGB(so, 1, 2, 3, stretch="lin")

# Unsuperviesd classification
library(RStoolbox)
# la funzione unsuperclass serve per procedere con la classificazione
soc <- unsuperClass(so, nClasses=3)
# inseriamo il nome dell'immagine e il numero di classi 
# associamo la funzione ad un oggetto, ovvero "soc"
plot(soc$map)
# con questa funzione si ottengono classificazioni e quindi immagini differenti
# per ottenere una classificazione univoca si usa la funzione "set.seed"
set.seed(42)

# Unsupervised Classification with 20 classes
son <- unsuperClass(so, nClasses=20)
plot(son$map)

# Dowload an Image from
# https://www.esa.int/ESA_Multimedia/Missions/Solar_Orbiter/(result_type)/images
# scarichiamo l'immagine e salviamo nella cartella lab
# rinominiamola come "sun"
# facciamo la classificazione
sun <- brick("sun.png")
sunc <- unsuperClass(sun, nClasses=3)
plot(sunc$map)
