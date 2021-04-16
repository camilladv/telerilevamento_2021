#R_code_knitr.r
#il pacchetto knitr è all'interno di R e utilizza un codice esterno per creare un reporp
#prende un codice all'esterno, lo importa all'interno di R e qui genera un report che viene salvato nella stessa cartella in cui è presente il codice

setwd('C:/lab')

#install.packages('knitr')
library(knitr)  #o require(knitr), è uguale

install.packages('tinytex')
library(tinytex)

stitch('R_code_greenland.r',template=system.file('misc','knitr-template.Rnw',package='knitr'))  

#errore con LaTeX
#registrazione a circa 55 minuti



