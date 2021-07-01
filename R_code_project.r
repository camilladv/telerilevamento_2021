#install.packages("raster")
#install.packages("RStoolbox")
library(raster)
library(RStoolbox)  #per classificazione


#set working directory
setwd('C:/lab/Progetto')

#importo l'immagine del 1979 (prima dell'eruzione) con tutti i suoi livelli
sth79<-brick('sthelens_ms3_19790829_lrg.jpg')  #serve il pacchetto raster
#guardo le informazioni relative all'immagine
sth79 #ha 3 bande: B1 NIR, B2 red e B3 green
#visualizzo l'immagine che ha la banda del NIR sul rosso. Viene evidenziata la vegetazione
plotRGB(sth79,stretch='lin')  #siccome le bande sono NIR sul red, red sul green e green sul blue non serve definirle esplicitamente

#importo l'immagine del 1980 (dopo l'eruzione) con tutte le sue bande
sth80<-brick('sthelens_ms2_19800924_lrg.jpg')
plotRGB(sth80,stretch='lin')

#plotto le due immagini in contemporanea
par(mfrow=c(1,2)) #1 colonna, 2 righe
plotRGB(sth79,stretch='lin')   
plotRGB(sth80,stretch='lin')  #si può notare come è cambiato il colore dell'acqua nel lago sotto, vicino al cratere. Il blu è più chiaro, indica maggiori solidi al suo interno

#calcolo NDVI per sth79, quindi cerco il nome delle bande
# names      : sthelens_ms3_19790829_lrg.1, sthelens_ms3_19790829_lrg.2, sthelens_ms3_19790829_lrg.3 
#rinomino le bande del NIR e del red
NIR79<-sth79$sthelens_ms3_19790829_lrg.1
RED79<-sth79$sthelens_ms3_19790829_lrg.2
NDVI79<-(NIR79-RED79)/(NIR79+RED79)

#calcolo NDVI per sth79, quindi cerco il nome delle bande
# names      : sthelens_ms2_19800924_lrg.1, sthelens_ms2_19800924_lrg.2, sthelens_ms2_19800924_lrg.3 
NIR80<-sth80$sthelens_ms2_19800924_lrg.1
RED80<-sth80$sthelens_ms2_19800924_lrg.2
NDVI80<-(NIR80-RED80)/(NIR80+RED80)

#confronto i due valori di NDVI per il 1979, prima dell'eruzione e il NDVI per il 1970, dopo l'eruzione
difNDVI<-NDVI79-NDVI80
plot(difNDVI)

#classificazione dei pixel delle immagini per vedere la copertura del suolo
sth79c<-unsuperClass(sth79,nClasses=2) 
sth79c
plot(sth79c$map)


#install.packeages('ggplot2')
library(ggplot2)

#vari indici di vegetazione per sth79
vi79<-spectralIndices(sth79,green=3,red=2,nir=1)





