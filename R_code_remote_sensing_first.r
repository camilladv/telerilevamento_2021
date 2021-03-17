 Primo codice R per il telerilevamento

#install.packages("raster")
library(raster)     # richiama il pacchetto raster

setwd("C:/lab/")  

p224r63_2011 <- brick("p224r63_2011_masked.grd")  # importa i dati raster dentro R
p224r63_2011     #informazioni sull'immagine: dimensione, risoluzione, valori di riflettanza nelle varie bande...

plot(p224r63_2011)  #visualizza i dati, quindi le 7 bande. B1 blu, B2 verde, B3 rosso, B4 NIR, B5 MIR, B6 TIR, B7 MIR

cl<-colorRampPalette(c('black','grey','light grey'))(100)    #stabilisce la variazione del colore. c crea un array dei colori. 100 intervalli di colore

plot(p224r63_2011,col=cl)    #immagine che vogliamo plottare con i colori di cl

cl<-colorRampPalette(c('yellow','blue','green','purple'))(100)  
plot(p224r63_2011,col=cl)
cl1<-colorRampPalette(c('yellow','purple','green','blue'))(100) 
plot(p224r63_2011,col=cl1)
