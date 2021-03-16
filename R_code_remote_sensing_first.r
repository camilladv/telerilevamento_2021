 Primo codice R per il telerilevamento

#install.packages("raster")
library(raster)     # richiama il pacchetto raster

setwd("C:/lab/")  

p224r63_2011 <- brick("p224r63_2011_masked.grd")  # importa i dati raster dentro R
p224r63_2011

plot(p224r63_2011)  #visualizza i dati, quindi le 7 bande
