# Codice R completo - Telerilevamento Geo-Ecologico

# ------------------------------------------------

# Sommario:

# 1. Primo codice telerilevamento
# 2. Serie temporali del codice R
# 3. Dati Copernico codice R
# 4. Codice R knitr
# 5. Analisi multivariata del codice R
# 6. Classificazione del codice R
# 7. Codice R ggplot2
# 8. Indici di vegetazione del codice R
# 9. Copertura del suolo del codice R
# 10. Variabilità del codice R
# 11. Firme spettrali del codice R


# ------------------------------------------------

# 1. Primo codice telerilevamento

# Il mio primo codice in R per il telerilevamento!!!
# Il mio primo codice in R per il telerilevamento!

# install.packages("raster")
libreria ( raster )

setwd( " ~/lab/ " ) # Linux
# setwd("C:/lab/") # Windows
# setwd("/Utenti/nome/Desktop/lab/") # Mac

p224r63_2011  <- mattone( " p224r63_2011_masked.grd " )
p224r63_2011

trama ( p224r63_2011 )

# cambio colore
cl  <- colorRampPalette(c( " nero " , " grigio " , " grigio chiaro " )) ( 100 )
plot( p224r63_2011 , col = cl )

# ### GIORNO 2

# cambio colore -> nuovo
cl  <- colorRampPalette(c( " blu " , " verde " , " grigio " , " rosso " , " magenta " , " giallo " )) ( 100 )
plot( p224r63_2011 , col = cl )

cls  <- colorRampPalette(c( " rosso " , " rosa " , " arancione " , " viola " )) ( 200 )
plot( p224r63_2011 , col = cls )                       

# ### GIORNO 3
# Bande Landsat
# B1: blu
# B2: verde
# B3: rosso
# B4: infrarosso vicino
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio

# dev.off pulirà il grafico corrente
dev.off()

trama ( p224r63_2011 $ B1_sre )

cls  <- colorRampPalette(c( " rosso " , " rosa " , " arancione " , " viola " )) ( 200 )
plot( p224r63_2011 $ B1_sre , col = cls )

dev.off()


trama ( p224r63_2011 $ B1_sre )
trama ( p224r63_2011 $ B2_sre )

# 1 riga, 2 colonne
par( mfrow = c( 1 , 2 ))
trama ( p224r63_2011 $ B1_sre )
trama ( p224r63_2011 $ B2_sre )

# 2 righe, 1 colonne
par( mfrow = c( 2 , 1 )) # se si utilizzano prima le colonne: par(mfcol....)
trama ( p224r63_2011 $ B1_sre )
trama ( p224r63_2011 $ B2_sre )

# traccia le prime quattro bande di Landsat
par( mfrow = c( 4 , 1 ))
trama ( p224r63_2011 $ B1_sre )
trama ( p224r63_2011 $ B2_sre )
trama ( p224r63_2011 $ B3_sre )
trama ( p224r63_2011 $ B4_sre )

# un quadrato di bande...:
par( mfrow = c( 2 , 2 ))
trama ( p224r63_2011 $ B1_sre )
trama ( p224r63_2011 $ B2_sre )
trama ( p224r63_2011 $ B3_sre )
trama ( p224r63_2011 $ B4_sre )

# un quadrato di bande...:
par( mfrow = c( 2 , 2 ))

clb  <- colorRampPalette(c( " blu scuro " , " blu " , " azzurro " )) ( 100 )
plot( p224r63_2011 $ B1_sre , col = clb )

clg  <- colorRampPalette(c( " verde scuro " , " verde " , " verde chiaro " )) ( 100 )
plot( p224r63_2011 $ B2_sre , col = clg )

clr  <- colorRampPalette(c( " rosso scuro " , " rosso " , " rosa " )) ( 100 )
plot( p224r63_2011 $ B3_sre , col = clr )

clnir  <- colorRampPalette(c( " rosso " , " arancione " , " giallo " )) ( 100 )
plot( p224r63_2011 $ B4_sre , col = clnir )

# Visualizzazione dei dati tramite plottaggio RGB


# Bande Landsat
# B1: blu
# B2: verde
# B3: rosso
# B4: infrarosso vicino
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio

plotRGB( p224r63_2011 , r = 3 , g = 2 , b = 1 , tratto = " Lin " )
plotRGB( p224r63_2011 , r = 4 , g = 3 , b = 2 , tratto = " Lin " )
plotRGB( p224r63_2011 , r = 3 , g = 4 , b = 2 , stretch = " Lin " )
plotRGB( p224r63_2011 , r = 3 , g = 2 , b = 4 , tratto = " Lin " )

# Esercizio: montare un multiframe 2x2
par( mfrow = c( 2 , 2 ))
plotRGB( p224r63_2011 , r = 3 , g = 2 , b = 1 , tratto = " Lin " )
plotRGB( p224r63_2011 , r = 4 , g = 3 , b = 2 , tratto = " Lin " )
plotRGB( p224r63_2011 , r = 3 , g = 4 , b = 2 , stretch = " Lin " )
plotRGB( p224r63_2011 , r = 3 , g = 2 , b = 4 , tratto = " Lin " )

pdf( " il_mio_primo_pdf_con_R.pdf " )
par( mfrow = c( 2 , 2 ))
plotRGB( p224r63_2011 , r = 3 , g = 2 , b = 1 , tratto = " Lin " )
plotRGB( p224r63_2011 , r = 4 , g = 3 , b = 2 , tratto = " Lin " )
plotRGB( p224r63_2011 , r = 3 , g = 4 , b = 2 , stretch = " Lin " )
plotRGB( p224r63_2011 , r = 3 , g = 2 , b = 4 , tratto = " Lin " )
dev.off()

# Insieme multitemporale
p224r63_1988  <- mattone( " p224r63_1988_masked.grd " )
p224r63_1988

# Bande Landsat
# B1: blu
# B2: verde
# B3: rosso
# B4: infrarosso vicino
# B5: infrarosso medio
# B6: infrarosso termico
# B7: infrarosso medio

trama ( p224r63_1988 )
plotRGB( p224r63_1988 , r = 3 , g = 2 , b = 1 , stretch = " Lin " )
plotRGB( p224r63_1988 , r = 4 , g = 3 , b = 2 , stretch = " Lin " )

# Hist
pdf( " multitemp.pdf " )
par( mfrow = c( 2 , 2 ))
plotRGB( p224r63_1988 , r = 4 , g = 3 , b = 2 , stretch = " Lin " )
plotRGB( p224r63_2011 , r = 4 , g = 3 , b = 2 , tratto = " Lin " )
plotRGB( p224r63_1988 , r = 4 , g = 3 , b = 2 , stretch = " hist " )
plotRGB( p224r63_2011 , r = 4 , g = 3 , b = 2 , stretch = " hist " )
dev.off()

plotRGB( p224r63_2011 , r = 3 , g = 4 , b = 2 , stretch = " Lin " )
plotRGB( p224r63_2011 , r = 3 , g = 4 , b = 2 , stretch = " hist " )


# par colori naturali, colori sbiaditi e falsi colori con estensione dell'istogramma
par( mfrow = c( 3 , 1 ))
plotRGB( p224r63_2011 , r = 3 , g = 2 , b = 1 , tratto = " Lin " )
plotRGB( p224r63_2011 , r = 3 , g = 4 , b = 2 , stretch = " Lin " )
plotRGB( p224r63_2011 , r = 3 , g = 4 , b = 2 , stretch = " hist " )

# ------------------------------------------------

# 2. Serie temporali del codice R

# Analisi delle serie temporali
# Aumento della temperatura in Groenlandia
# Dati e codice di Emanuela Cosma

# install.packages("raster")
# install.packages("rasterVis")
libreria ( raster )
libreria ( rasterVis )

# libreria(rgdal)

setwd( " ~/lab/groenlandia " ) # Linux
# setwd("C:/lab/groenlandia") # Windows
# setwd("/Utenti/nome/Desktop/lab/groenlandia") # Mac

lst_2000  <- raster( " lst_2000.tif " )
lst_2005  <- raster( " lst_2005.tif " )
lst_2010  <- raster( " lst_2010.tif " )
lst_2015  <- raster( " lst_2015.tif " )

# par
par( mfrow = c( 2 , 2 ))
trama( lst_2000 )
trama ( lst_2005 )
trama( lst_2010 )
trama ( lst_2015 )

# elenca f file:
rlist  <- list.files( pattern = " lst " )
elenco

import  <- lapply( rlist , raster )
importare

TGr  <- stack( import )
TGr
trama( TGr )

plotRGB( TGr , 1 , 2 , 3 , stretch = " Lin " )
plotRGB( TGr , 2 , 3 , 4 , stretch = " Lin " )
plotRGB( TGr , 4 , 3 , 2 , stretch = " Lin " )

diagramma di livello ( TGr )
cl  <- colorRampPalette(c( " blue " , " light blue " , " pink " , " red " )) ( 100 )
levelplot( TGr , col.regions = cl )

levelplot( TGr , col.regions = cl , names.attr = c( " Luglio 2000 " , " Luglio 2005 " , " Luglio 2010 " , " Luglio 2015 " ))

levelplot( TGr , col.regions = cl , main = " Variazione LST nel tempo " ,
          nomi.attr = c( " luglio 2000 " , " luglio 2005 " , " luglio 2010 " , " luglio 2015 " ))

# Sciogliere
meltlist  <- list.files( pattern = " melt " )
melt_import  <- lapply ( meltlist , raster )
melt  <- stack( melt_import )
sciogliersi

levelplot ( melt )

melt_amount  <-  melt $ X2007annual_melt  -  melt $ X1979annual_melt

clb  <- colorRampPalette(c( " blue " , " white " , " red " )) ( 100 )
plot( melt_amount , col = clb )

levelplot( melt_amount , col.regions = clb )

# ------------------------------------------------

# 3. Dati Copernico codice R

# R_codice_copernico.r
# Visualizzazione dei dati di Copernico

# install.packages("ncdf4")
libreria ( raster )
libreria ( ncdf4 )

setwd( " ~/lab/ " ) # Linux
# setwd("C:/lab/") # Windows
# setwd("/Utenti/nome/Desktop/lab/") # Mac

albedo  <- raster( " c_gls_ALBH_202006130000_GLOBE_PROBAV_V1.5.1.nc " )

cl  <- colorRampPalette(c( ' azzurro ' , ' verde ' , ' rosso ' , ' giallo ' ))( 100 ) # 
plot( albed0 , col = cl )

# ricampionamento
albedores  <- aggregato( albedo , fact = 100 )
plot( albedores , col = cl )


# ------------------------------------------------

# 4. Codice R knitr

# a partire dalla cartella del codice in cui è inserito framed.sty!

richiedere ( magliaia )
stitch( " ~/Downloads/R_code_temp.r " , template = system.file( " misc " , " knitr-template.Rnw " , package = " knitr " ))

# ------------------------------------------------

# 5. Analisi multivariata del codice R

# R_code_multivariate_analysis.r

libreria ( raster )
libreria ( RStoolbox )

setwd( " ~/lab/ " ) # Linux
# setwd("C:/lab/") # Windows
# setwd("/Utenti/nome/Desktop/lab/") # Mac

p224r63_2011  <- mattone( " p224r63_2011_masked.grd " )

trama ( p224r63_2011 )

p224r63_2011

plot( p224r63_2011 $ B1_sre , p224r63_2011 $ B2_sre , col = " rosso " , pch = 19 , cex = 2 )
plot( p224r63_2011 $ B2_sre , p224r63_2011 $ B1_sre , col = " rosso " , pch = 19 , cex = 2 )

coppie ( p224r63_2011 )

# celle aggregate: ricampionamento (ricampionamento)
p224r63_2011res  <- aggregato ( p224r63_2011 , fact = 10 )

par( mfrow = c( 2 , 1 ))
plotRGB( p224r63_2011 , r = 4 , g = 3 , b = 2 , stretch = " lin " )
plotRGB( p224r63_2011res , r = 4 , g = 3 , b = 2 , stretch = " lin " )

p224r63_2011res_pca  <- rasterPCA( p224r63_2011res )

sommario ( p224r63_2011res_pca $ modello )

# dev.off()
plotRGB( p224r63_2011res_pca $ map , r = 1 , g = 2 , b = 3 , stretch = " lin " )

# aggiungi dagli studenti:
str( p224r63_2011res_pca )

# ------------------------------------------------

# 6. Classificazione del codice R

# Classificazione_codice_R.r

libreria ( raster )
libreria ( RStoolbox )

setwd( " ~/lab/ " ) # Linux
# setwd("C:/lab/") # Windows
# setwd("/Utenti/nome/Desktop/lab/") # Mac

quindi  <- brick( " Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg " )
così

plotRGB( così , 1 , 2 , 3 , stretch = " lin " )

soc  <- unsuperClass( quindi , nClasses = 3 )
trama ( soc $ mappa )

soc20  <- unsuperClass( quindi , nClasses = 20 )
plot( soc20 $ map , col = cl )

cl  <- colorRampPalette(c( ' giallo ' , ' nero ' , ' rosso ' ))( 100 )
plot( soc20 $ map , col = cl )

# Scarica i dati di Solar Orbiter e procedi oltre!

# Grand Canyon
# https://landsat.visibleearth.nasa.gov/view.php?id=80948

# Quando John Wesley Powell guidò una spedizione lungo il fiume Colorado e attraverso il Grand Canyon nel 1869, si trovò di fronte a un paesaggio scoraggiante. Nel suo punto più alto, la gola serpentina si tuffava 1.829 metri (6.000 piedi) dal bordo al fondo del fiume, rendendolo uno dei canyon più profondi degli Stati Uniti. In soli 6 milioni di anni, l'acqua ha scavato strati di roccia che collettivamente hanno rappresentato più di 2 miliardi di anni di storia geologica, quasi la metà del tempo in cui la Terra è esistita.

gc  <- mattone( " dolansprings_oli_2013088_canyon_lrg.jpg " )

plotRGB( gc , r = 1 , g = 2 , b = 3 , stretch = " lin " )
plotRGB( gc , r = 1 , g = 2 , b = 3 , stretch = " hist " )

gcc2  <- unsuperClass( gc , nClasses = 2 )
gcc2
trama ( gcc2 $ mappa )

gcc4  <- unsuperClass( gc , nClasses = 4 )
trama ( gcc4 $ mappa )

# ------------------------------------------------

# 7. Codice R ggplot2

libreria ( raster )
libreria ( RStoolbox )
libreria ( ggplot2 )
libreria( gridExtra )

setwd( " ~/lab/ " )

p224r63  <- mattone( " p224r63_2011_masked.grd " )

ggRGB( p224r63 , 3 , 2 , 1 , tratto = " lin " )
ggRGB( p224r63 , 4 , 3 , 2 , tratto = " lin " )

p1  <- ggRGB( p224r63 , 3 , 2 , 1 , stretch = " lin " )
p2  <- ggRGB( p224r63 , 4 , 3 , 2 , stretch = " lin " )

grid.arrange( p1 , p2 , nrow  =  2 ) # richiede gridExtra

# ------------------------------------------------

# 8. Indici di vegetazione del codice R

# R_code_vegetation_indices.r

libreria( raster ) # require(raster)
library( RStoolbox ) # per il calcolo degli indici di vegetazione
# install.packages("rasterdiv")
library( rasterdiv ) # per NDVI . mondiale
# install.packages("rasterVis")
libreria ( rasterVis )


setwd( " ~/lab/ " ) # Linux
# setwd("C:/lab/") # Windows
# setwd("/Utenti/nome/Desktop/lab/") # Mac

defor1  <- mattone( " defor1.jpg " )
defor2  <- mattone( " defor2.jpg " )

# b1 = NIR, b2 = rosso, b3 = verde

par( mfrow = c( 2 , 1 ))
plotRGB( defor1 , r = 1 , g = 2 , b = 3 , stretch = " lin " )
plotRGB( defor2 , r = 1 , g = 2 , b = 3 , stretch = " lin " )

defor1

# differenza di indice di vegetazione

# volta 1
dvi1  <-  defor1 $ defor1.1  -  defor1 $ defor1.2

# dev.off()
trama ( dvi1 )

cl  <- colorRampPalette(c( ' darkblue ' , ' yellow ' , ' red ' , ' black ' ))( 100 ) # specificando uno schema di colori

plot( dvi1 , col = cl , main = " DVI al tempo 1 " )

# tempo 2
dvi2  <-  defor2 $ defor2.1  -  defor2 $ defor2.2

plot( dvi2 , col = cl , main = " DVI al tempo 2 " )

par( mfrow = c( 2 , 1 ))
plot( dvi1 , col = cl , main = " DVI al tempo 1 " )
plot( dvi2 , col = cl , main = " DVI al tempo 2 " )

difdvi  <-  dvi1  -  dvi2

# dev.off()
cld  <- colorRampPalette(c( ' blue ' , ' white ' , ' red ' ))( 100 )
plot( difdvi , col = cld )


# ndvi
# (NIR-ROSSO) / (NIR+ROSSO)
ndvi1  <- ( defor1 $ defor1.1  -  defor1 $ defor1.2 ) / ( defor1 $ defor1.1  +  defor1 $ defor1.2 )
plot( ndvi1 , col = cl )

# ndvi1 <- dvi1 / (defor1$defor1.1 + defor1$defor1.2)
# plot(ndvi1, col=cl)

ndvi2  <- ( defor2 $ defor2.1  -  defor2 $ defor2.2 ) / ( defor2 $ defor2.1  +  defor2 $ defor2.2 )
plot( ndvi2 , col = cl )

# ndvi1 <- dvi2 / (defor2$defor2.1 + defor1$defor2.2)
# plot(ndvi2, col=cl)

difndvi  <-  ndvi1  -  ndvi2

# dev.off()
cld  <- colorRampPalette(c( ' blue ' , ' white ' , ' red ' ))( 100 )
plot( difndvi , col = cld )


# RStoolbox::spectralIndices
vi1  <- spectralIndices( defor1 , green  =  3 , red  =  2 , nir  =  1 )
plot( vi1 , col = cl )

vi2  <- spectralIndices( defor2 , green  =  3 , red  =  2 , nir  =  1 )
plot( vi2 , col = cl )

# NDVI . mondiale
trama( copNDVI )


# I pixel con i valori 253, 254 e 255 (acqua) verranno impostati come NA.
copNDVI  <- reclassify ( copNDVI , cbind( 253 : 255 , NA ))
trama( copNDVI )

# pacchetto rasterVis necessario:
levelplot ( copNDVI )

# ------------------------------------------------

# 9. Copertura del suolo del codice R

# R_code_land_cover.r

libreria ( raster )
libreria( RStoolbox ) # classificazione
# install.packages("ggplot2")
libreria ( ggplot2 )
# install.packages("gridExtra")
library( gridExtra ) # per il plottaggio grid.arrange

setwd( " ~/lab/ " ) # Linux
# setwd("C:/lab/") # Windows
# setwd("/Utenti/nome/Desktop/lab/") # Mac

# NIR 1, ROSSO 2, VERDE 3

defor1  <- mattone( " defor1.jpg " )
plotRGB( defor1 , r = 1 , g = 2 , b = 3 , stretch = " lin " )
ggRGB( defor1 , r = 1 , g = 2 , b = 3 , stretch = " lin " )

defor2  <- mattone( " defor2.jpg " )
plotRGB( defor2 , r = 1 , g = 2 , b = 3 , stretch = " lin " )
ggRGB( defor2 , r = 1 , g = 2 , b = 3 , stretch = " lin " )

par( mfrow = c( 1 , 2 ))
plotRGB( defor1 , r = 1 , g = 2 , b = 3 , stretch = " lin " )
plotRGB( defor2 , r = 1 , g = 2 , b = 3 , stretch = " lin " )

# multiframe con ggplot2 e gridExtra
p1  <- ggRGB( defor1 , r = 1 , g = 2 , b = 3 , stretch = " lin " )
p2  <- ggRGB( defor2 , r = 1 , g = 2 , b = 3 , stretch = " lin " )
grid.arrange( p1 , p2 , nrow = 2 )

# classificazione non supervisionata
d1c  <- unsuperClass( defor1 , nClasses = 2 )
trama ( d1c $ mappa )
# classe 1: foresta
# classe 2: agricoltura

# set.seed() ti permetterebbe di ottenere gli stessi risultati ...

d2c  <- unsuperClass( defor2 , nClasses = 2 )
trama ( d2c $ mappa )
# classe 1: agricoltura
# classe 2: foresta

d2c3  <- unsuperClass( defor2 , nClasses = 3 )
trama ( d2c3 $ mappa )

# frequenze
freq( d1c $ mappa )
#    valore conteggio
# [1,] 1 306583
# [2,] 2 34709

s1  <-  306583  +  34709

prop1  <- freq( d1c $ map ) /  s1
# foresta prop: 0.8983012
# agricoltura prop: 0.1016988

s2  <-  342726
prop2  <- freq( d2c $ map ) /  s2
# foresta prop: 0,5206958
# agricoltura prop: 0.4793042

# costruisci un dataframe
cover  <- c( " Foresta " , " Agricoltura " )
percent_1992  <- c( 89.83 , 10.16 )
percent_2006  <- c( 52.06 , 47.93 )

percentuali  <-  data.frame ( cover , percent_1992 , percent_2006 )
percentuali

# disegniamoli!
ggplot ( percentuali , AES ( x = copertura , y = percent_1992 , color = copertina )) + geom_bar ( stat = " identità " , fill = " bianco " )
ggplot ( percentuali , AES ( x = copertura , y = percent_2006 , color = copertina )) + geom_bar ( stat = " identità " , fill = " bianco " )

p1  <- ggplot( percentili , aes( x = cover , y = percent_1992 , color = cover )) + geom_bar( stat = " identity " , fill = " white " )
p2  <- ggplot( percentuali , aes( x = cover , y = percent_2006 , color = cover )) + geom_bar( stat = " identity " , fill = " white " )

grid.arrange( p1 , p2 , nrow = 1 )

# ------------------------------------------------

# 10. Variabilità del codice R

# R_codice_variabilità.r

libreria ( raster )
libreria ( RStoolbox )
# install.packages("RStoolbox")
library( ggplot2 ) # per la stampa di ggplot
library( gridExtra ) # per tracciare ggplot insieme
# install.packages("viridis")
library( viridis ) # per la colorazione di ggplot


setwd( " ~/lab/ " ) # Linux
# setwd("C:/lab/") # Windows
# setwd("/Utenti/nome/Desktop/lab/") # Mac

inviato  <- brick( " sentinel.png " )

# NIR 1, ROSSO 2, VERDE 3
# r=1, g=2, b=3
plotRGB( inviato , stretch = " lin " )
# plotRGB(sent, r=1, g=2, b=3, stretch="lin")

plotRGB( inviato , r = 2 , g = 1 , b = 3 , stretch = " lin " )

nir  <-  inviato $ sentinel.1
rosso  <-  inviato $ sentinel.2

ndvi  <- ( nir - rosso ) / ( nir + rosso )
trama ( ndvi )
cl  <- colorRampPalette(c( ' nero ' , ' bianco ' , ' rosso ' , ' magenta ' , ' verde ' ))( 100 ) # 
plot( ndvi , col = cl )

ndvisd3  <- focale( ndvi , w = matrix ( 1 / 9 , nrow = 3 , ncol = 3 ), fun = sd )

clsd  <- colorRampPalette(c( ' blue ' , ' green ' , ' pink ' , ' magenta ' , ' orange ' , ' brown ' , ' red ' , ' yellow ' ))( 100 ) # 
plot( ndvisd3 , col = clsd )

# significa ndvi con focale
ndvimean3  <- focale( ndvi , w = matrice ( 1 / 9 , nrow = 3 , ncol = 3 ), fun = media )
clsd  <- colorRampPalette(c( ' blue ' , ' green ' , ' pink ' , ' magenta ' , ' orange ' , ' brown ' , ' red ' , ' yellow ' ))( 100 ) # 
plot( ndvimean3 , col = clsd )

# modifica delle dimensioni della finestra
ndvisd13  <- focale( ndvi , w = matrix ( 1 / 169 , nrow = 13 , ncol = 13 ), fun = sd )
clsd  <- colorRampPalette(c( ' blue ' , ' green ' , ' pink ' , ' magenta ' , ' orange ' , ' brown ' , ' red ' , ' yellow ' ))( 100 ) # 
plot( ndvisd13 , col = clsd )

ndvisd5  <- focale( ndvi , w = matrix ( 1 / 25 , nrow = 5 , ncol = 5 ), fun = sd )
clsd  <- colorRampPalette(c( ' blue ' , ' green ' , ' pink ' , ' magenta ' , ' orange ' , ' brown ' , ' red ' , ' yellow ' ))( 100 ) # 
plot( ndvisd5 , col = clsd )

# PCA
sentpca  <- rasterPCA ( inviato )
plot( sentpca $ map )  

sommario ( modello sentpca $ )

# il primo PC contiene il 67,36804% delle informazioni originali

pc1  <-  sentpca $ map $ PC1

pc1sd5  <- focale( pc1 , w = matrice ( 1 / 25 , nrow = 5 , ncol = 5 ), fun = sd )
clsd  <- colorRampPalette(c( ' blue ' , ' green ' , ' pink ' , ' magenta ' , ' orange ' , ' brown ' , ' red ' , ' yellow ' ))( 100 ) # 
plot( pc1sd5 , col = clsd )

# pc1 <- sentpca$map$PC1
# pc1sd7 <- focale(pc1, w=matrix(1/49, nrow=7, ncol=7), fun=sd)
# plot(pc1sd7)

# Con la funzione sorgente puoi caricare codice dall'esterno!
source( " source_test_lezione.r " )
source( " source_ggplot.r " )

# https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
# Il pacchetto contiene otto scale di colori: "viridis", la scelta primaria e cinque alternative con proprietà simili - "magma", "plasma", "inferno", "civids", "mako" e "razzo" - e una mappa dei colori dell'arcobaleno - "turbo".

p1  <- ggplot() +
geom_raster( pc1sd5 , mapping  = aes( x  =  x , y  =  y , fill  =  layer )) +
scale_fill_viridis()   +
ggtitle( " Deviazione standard di PC1 dalla scala di colori viridis " )

p2  <- ggplot() +
geom_raster( pc1sd5 , mapping  = aes( x  =  x , y  =  y , fill  =  layer )) +
scale_fill_viridis( opzione  =  " magma " )   +
ggtitle ( " Deviazione standard di PC1 dalla scala di colori del magma " )

p3  <- ggplot() +
geom_raster( pc1sd5 , mapping  = aes( x  =  x , y  =  y , fill  =  layer )) +
scale_fill_viridis( opzione  =  " turbo " )   +
ggtitle ( " Deviazione standard di PC1 dalla scala di colori turbo " )

grid.arrange( p1 , p2 , p3 , nrow  =  1 )

# ------------------------------------------------

# 11. Firme spettrali del codice R

# R_code_spectral_signatures.r

libreria ( raster )
biblioteca ( rgdal )
libreria ( ggplot2 )

setwd( " ~/lab/ " )
# setwd("/Users/utente/lab") #mac
# setwd("C:/lab/") # windows

defor2  <- mattone( " defor2.jpg " )

# defor2.1, defor2.2, defor2.3
# NIR, rosso, verde

plotRGB( defor2 , r = 1 , g = 2 , b = 3 , stretch = " lin " )
plotRGB( defor2 , r = 1 , g = 2 , b = 3 , stretch = " hist " )

click( defor2 , id = T , xy = T , cell = T , type = " p " , pch = 16 , cex = 4 , col = " giallo " )

# risultati:
#       xy cella defor2.1 defor2.2 defor2.3
# 1 178,5 435,5 30293 206 6 19
#       xy cella defor2.1 defor2.2 defor2.3
# 1 571,5 245,5 166916 40 99 139

# definisce le colonne del dataset:
banda  <- c( 1 , 2 , 3 )
foresta  <- c( 206 , 6 , 19 )
acqua  <- c( 40 , 99 , 139 )

# crea il dataframe
spettri  <-  data.frame ( banda , foresta , acqua )

# traccia le firme settrali
ggplot( spettri , aes( x = banda )) +
geom_line(aes( y = foresta ), color = " verde " ) +
geom_line(aes( y = acqua ), color = " blu " ) +
labs( x = " banda " , y = " riflettanza " )

# ############## Multitemporale

defor1  <- mattone( " defor1.jpg " )

plotRGB( defor1 , r = 1 , g = 2 , b = 3 , stretch = " lin " )

# firme spettrali defor1
click( defor1 , id = T , xy = T , cell = T , tipo = " p " , pch = 16 , col = " giallo " )

#      xy cella defor1.1 defor1.2 defor1.3
# 1 89,5 339,5 98622 223 11 33
#      xy cella defor1.1 defor1.2 defor1.3
# 1 42,5 336,5 100717 218 16 38
#      xy cella defor1.1 defor1.2 defor1.3
# 1 64,5 341,5 97169 213 36 46
#       xy cella defor1.1 defor1.2 defor1.3
# 1 80,5 326,5 107895 208 2 22
#      xy cella defor1.1 defor1.2 defor1.3
# 1 76.5 374.5 73619 224 21 41

# tempo t2
plotRGB( defor2 , r = 1 , g = 2 , b = 3 , stretch = " lin " )
click( defor2 , id = T , xy = T , cell = T , tipo = " p " , pch = 16 , col = " giallo " )

#       xy cella defor2.1 defor2.2 defor2.3
# 1 86.5 339.5 99033 197 163 151
#       xy cella defor2.1 defor2.2 defor2.3
# 1 104.5 338.5 99768 149 157 133
#       xy cella defor2.1 defor2.2 defor2.3
# 1 110,5 354,5 88302 197 132 128
#      xy cella defor2.1 defor2.2 defor2.3
# 1 90,5 320,5 112660 169 166 149
#     xy cella defor2.1 defor2.2 defor2.3
# 1 97,5 309,5 120554 150 137 129

# definisce le colonne del dataset:
banda  <- c( 1 , 2 , 3 )
tempo1  <- c( 223 , 11 , 33 )
tempo1p2  <- c( 218 , 16 , 38 )
tempo2  <- c( 197 , 163 , 151 )
tempo2p2  <- c( 149 , 157 , 133 )

spectralst  <-  data.frame ( banda , time1 , time2 , time1p2 , time2p2 )


# traccia le firme settrali
ggplot( spectralst , aes( x = band )) +
geom_line(aes( y = time1 ), color = " red " , linetype = " punteggiato " ) +
geom_line(aes( y = time1p2 ), color = " red " , linetype = " punteggiato " ) +
geom_line(aes( y = time2 ), linetype = " punteggiato " ) +
geom_line(aes( y = time2p2 ), tipo di linea = " punteggiato " ) +
labs( x = " banda " , y = " riflettanza " )

# immagine dall'Osservatorio della Terra

eo  <- brick( " june_puzzler.jpg " )
plotRGB( eo , 1 , 2 , 3 , stretch = " hist " )
click( eo , id = T , xy = T , cell = T , type = " p " , pch = 16 , cex = 4 , col = " giallo " )

# uscita
#      xy cell june_puzzler.1 june_puzzler.2 june_puzzler.3
# 1 93,5 373,5 76414 187 163 11
#       xy cell june_puzzler.1 june_puzzler.2 june_puzzler.3
# 1 219,5 285,5 139900 11 140 0
#      xy cell june_puzzler.1 june_puzzler.2 june_puzzler.3
# 1 184,5 315,5 118265 41 40 20


# definisce le colonne del dataset:
banda  <- c( 1 , 2 , 3 )
strato1  <- c( 187 , 163 , 11 )
strato2  <- c( 11 , 140 , 0 )
strato3  <- c( 41 , 40 , 20 )

spectralsg  <-  data.frame ( banda , strato1 , strato2 , strato3 )

# traccia le firme settrali
ggplot( spectralsg , aes( x = banda )) +
geom_line(aes( y = strato1 ), color = " giallo " ) +
geom_line(aes( y = strato2 ), color = " verde " ) +
geom_line(aes( y = strato3 ), color = " blu " ) +
labs( x = " banda " , y = " riflettanza " )

