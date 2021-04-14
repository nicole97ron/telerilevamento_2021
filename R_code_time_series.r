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
TGr
plot(TGr)

# installare il pacchetto rasterVis
install.packages("rasterVis")
library(rasterVis)

# La funzione "levelplot" permette di creare un plot unico 
levelplot(TGr)
levelplot(TGr$lst_2000)
# con questa funzione si ottiene un grafico che definisce la variazione della temperatura nell'area di riferimento
# ora è possibile provare a modificare la colorRampPallete 
cl <- colorRampPalette(c("blue","light blue","pink","red"))(100)
levelplot(TGr, col.regions=cl)
# dal grafico ottenuto si nota un trend di cambiamneto di temperatura dal 2000 al 2015
levelplot(TGr,col.regions=cl, names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))
# in questo modo rinominiamo i vari layer contenuti nell'immagine
# ora possiamo inserire un titolo al nostro grafico (essendo un testo deve essere inserito tra virgolette)
levelplot(TGr,col.regions=cl, main="LST variation in time",names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))

# Ora utilizziamo i dati contenuti in MELT 
# creiamo un'altra lista tramite la presenza di un pattern comune
# in questo caso il pattern comune è "melt"
meltlist <- list.files(pattern="melt")
meltlist
# ora utilizzo la funzione lapply con la funzione raster applicata alla lista appena creata 
melt_import <- lapply(meltlist,raster)
# a questo punto utilizzo la funzione "stack"
melt <- stack(melt_import)
# faccio uno stack di tutti i file che ho importato 
melt
# ora utilizziamo la funzione levelplot con questi nuovi dati 
levelplot(melt)
# il grafico che otteniamo ci descrive il livello di scioglimeno dei ghiacciai dal 1979 al 2007
# ora utilizziamo una funzione che permette di fare una sottrazzione tra uno strato e un altro
melt_amount <- melt$X2007annual_melt - melt$X1979annual_melt
# ora plottiamo e modifichiamo la colorRampPalette 
clb <- colorRampPalette(c("blue","white","red"))(100)
plot(melt_amount, col=clb)
# le zone rosse che otteniamo nel grafico sono quelle dove dal 2007 al 1979 c'è stato uno scioglimento del ghiaccio maggiore 
# possiamo fare anche un levelplot 
levelplot(melt_amount, col.regions=clb)
 # in questo modo si riescono ad utilizzare un set di dati multitemporali potendoli visualizzare inisieme e notando così le differenze

# installare il pacchetto knitr che serve per fare un report
install.packages("knitr") 
library(knitr) 

