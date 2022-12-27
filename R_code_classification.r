# R_code_classification.r 
# CLASSIFICAZIONE: processo che accorpa pixel con valori simili, una volta che questi pixel sono stati accorpati rappresentano una classe

# settiamo la working directory
setwd("C:/lab/")
# impostiamo le librerie che ci servono
library(raster)
library(RStoolbox) 

# funzione brick: inseriamo l'immagine RGB con 3 livelli (pacchetto di dati) 
# associamo l'oggetto so (solar orbiter) al risultato della funzione
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
# vediamo le informazioni relative alle 3 bande
so
# calss: RasterBrick 
# values: 0 , 255 → immagine a 8 bit → 2^8 = 256 valori 

# visualizziamo i 3 livelli dell'immagine RGB
# funzione plotRGB: ci serve per visualizzare i 3 livelli dell'immagine RGB
# X = oggetto
# banda 1 sulla componenete red, banda 2 sulla componente green, banda 3 sulla componente blue
# stretch lineare
plotRGB(so, 1, 2, 3, stretch="Lin")
# vediamo diversi livelli energitici, da alti (colore acceso) a bassi (grigio/nero) 

# classifichiamo l'immagine per individuare le 3 classi
# classificazione non supervisionata: si lascia al software la possibilità di definire il training set sulla base delle riflettanze dei pixel
# training set: il software cattura pochi pixel all’interno dell’immagine per creare un set di controllo e poi si classifica l'intera immagine
# maximum likelihood: per ogni pixel si calcola la distanza nello spazio multispettrale, in base a questa si associa il pixel ad una determinata classe 
# per la classificazione serve la library(RStoolbox) -> libreria che contiene la funzione unsuperClass
# library(RStoolbox) 

# funzione unsuperClass: opera la classificazione non supervisionata (dentro al pacchetto RStoolbox) 
# so: inserimento dell'immagine 
# nClasses=3: numero di classi sulla base dell'immagine 
# associamo l'oggetto soc (solar orbiter classified) al risultato della funzione
soc <- unsuperClass(so, nClasses=3)

# funzione unsuperClass: ha creato l'immaigine classificata (soc) formata da più pezzi: modello + mappa 
# facciamo un plot dell'immagine classificata (soc) e in particolare della mappa
# $: leghiamo l'immagine classificata (soc) alla sua mappa (map)
plot(soc$map)
# 3 classi: classe 1: bianca; classe 2: gialla; classe 3: verde
# queste classi corrispondono ai diversi livelli di energia (alto - medio - basso)

# la mia mappa finale è diversa dalle altre -> i pixel selezionati in entrata per il training set sono diversi di volta in volta
# funzione set.seed: serve per fare una classificazione che sia sempre la stessa (usa sempre le stesse repliche per fare il modello) 
set.seed(42)

# esercitazione: Unsupervised Classification with 20 classes
set.seed(42)
soc20 <- unsuperClass(so, nClasses=20)
plot(soc20$map)

# esercitazione: download an image from: https://www.esa.int/ESA_Multimedia/Missions/Solar_Orbiter/(result_type)/images
# funzione brick: importiamo l'immagine dentro R
sun <- brick("sun.png")
# classificazione dell'immaigne sun - Unsupervised classification
# 3 classi 
set.seed(42)
sunc <- unsuperClass(sun, nClasses=3)
# plottiamo la mappa dell'immagine sun classificata 
plot(sunc$map)
# -----------------------------------------------------------------------------------------------------------------------------

# Grand Canyon 
# richiamiamo le library
library(raster)
library(RStoolbox)
# settiamo la working directory
setwd("C:/lab/")
gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg")
#visualizziamo l'immagine con la funzione plotRGB
plotRGB(gc, r=1, g=2, b=3, stretch="lin")
# modifichiamo lo stretch
plotRGB(gc, r=1, g=2, b=3, stretch="hist")
# ora procediamo con la classificazione dell'immagine tramite la funzione unsuperclass
gcc2 <- unsuperClass(gc, nClasses=2)
gcc2 
# in questo modo otteniamo informazioni sulla mappa
# ora visualizziamo l'immagine classificata in due classi
plot(gcc2$map)
# ora classifichiamo l'immagine con 4 classi
gcc4 <- unsuperClass(gc, nClasses=4)
plot(gcc4$map)
