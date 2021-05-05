#R_code_land_cover.r

library(raster)
library(RStoolbox)  #pacchetto per la classificazione
install.packages('ggplot2')
library(ggplot2)  #pacchetto per visualizzare le immagini in maniera più bella
setwd('C:/lab/')

#immagini defor1 e defor2: NIR 1, RED 2, GREEN 3
#defor1
defor1<-brick('defor1.jpg') #carichiamo il dataset con tutte le bande
plotRGB(defor1,r=1,g=2,b=3,stretch='lin')
ggRGB(defor1,r=1,g=2,b=3,stretch='lin')  #immagine, 3 layer e componenti e strecth. Plotta anche le coordinate spaziali sugli assi x e y

#defor2
defor2<-brick('defor2.jpg')
plotRGB(defor2,r=1,g=2,b=3,stretch='lin')
ggRGB(defor2,r=1,g=2,b=3,stretch='lin')

#confronto tra immagini plotRGB
par(mfrow=c(2,1))
plotRGB(defor1,r=1,g=2,b=3,stretch='lin')
plotRGB(defor2,r=1,g=2,b=3,stretch='lin')

#confronto tra immagini ggRGB grazie al pacchetto gridExtra
install.packages('gridExtra') #permette di usare ggplot per dati raster con la faunzione grid.arrange
library(gridExtra)

#grid.arrange plotta ...
p1<-ggRGB(defor1,r=1,g=2,b=3,stretch='lin')
p2<-ggRGB(defor2,r=1,g=2,b=3,stretch='lin')
grid.arrange(p1,p2,nrow=2)  #immagini disposte su 2 righe



