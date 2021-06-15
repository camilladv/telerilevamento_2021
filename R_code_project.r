library(raster)

#set working directory
setwd('C:/lab/Progetto')

#importo l'immagine del 05/2013 con tutte le sue bande
lv13<-brick('lakevictoria_oli_2013141_lrg_8513.jpg')  #needs pacchetto raster
#importo l'immagine del 05/2021 con tutte le sue bande
lv21<-brick('lakevictoria_oli_2021147_lrg_27521.jpg')

#confronto a colori reali delle 2 immagini
par(mfrow=c(2,1))
plotRGB(lv13,r=1,g=2,b=3,stretch='lin')
plotRGB(lv21,r=1,g=2,b=3,stretch='lin')




