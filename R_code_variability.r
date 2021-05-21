#R_code_variability.r

library(raster)
library(RStoolbox)
setwd('C:/lab/')

#importo su R l'immagine sentinel
sent<-brick('sentinel.png')
#NIR 1, RED 2, GREEN 3
#Siccome di default l'immagine ha questi colori associati alle bande r=1, g=2, b=3, possiamo ometterle nel comando
plotRGB(sent,stretch='lin') #è la stessa cosa di plotRGB(sent,r=1,g=2,b=3,stretch='lin'), quindi NIR sul red, rosso sul green e verde sul blu

#parte vegetata diventa verde fluorescente, perchè mettiamo il NIR sul colore verde
plotRGB(sent,r=2,g=1,b=3,stretch='lin')  #la roccia calcarea è viola e la parte vegetale è verde fluo, l'acqua nera

#calcolo della deviazione standard utilizzando una sola banda

