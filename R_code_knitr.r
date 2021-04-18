#R_code_knitr
#installiamo il pacchetto knitr
install_packages("knitr")
#settiamo la working directory ovvero quella in cui andiamo a pescare il nostro codice originale
setwd("C:/lab/")

# carichiamo il pacchetto knitr
library(knitr)

#salviamo il codice da utilizzare nella cartella lab
#il pacchetto knitr pesca il codice nella cartella lab e lo carica in R generando il report 
#utilizziamo la funzione stitch
stitch("R_code_greenland.txt", template=system.file("misc", "knitr-template.Rnw", package="knitr"))

