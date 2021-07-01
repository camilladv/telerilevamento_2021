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
dev.off()

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

#classificazione dell'immagine del 1979 per vedere la copertura del suolo prima dell'eruzione
sth79c<-unsuperClass(sth79,nClasses=3) 
sth79c
# unsuperClass results
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 1300, 1300, 1690000  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1300, 0, 1300  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 3  (min, max)
set.seed(3)
plot(sth79c$map)  #classe 3: acqua, classe 2: vegetazione + bosco, classe 1: roccia + zone meno vegetate

#confronto visivo tra immagine e mappa di classificazione
par(mfrow=c(1,2))
plotRGB(sth79,stretch='lin')
plot(sth79c$map)
dev.off()

#calcolo la percentuale di copertura delle varie classi
freq(sth79c$map)
#      value  count
# [1,]     1 709257   --> pixel roccia + zone meno vegetate
# [2,]     2 762452   --> pixel vegetazione + bosco
# [3,]     3 218291   --> pixel acqua
s79<-1690000  #totale di pixel ricavato dalle informazioni dell'immagine
prop79<-freq(sth79c$map)/s79
prop79
#             value     count
# [1,] 5.917160e-07 0.4196787   --> 42% roccia + zone meno vegetate
# [2,] 1.183432e-06 0.4511550   --> 45% vegetazione + bosco
# [3,] 1.775148e-06 0.1291663   --> 13% acqua

#classificazione dell'immagine del 1980 per vedere la copertura del suolo dopo l'eruzione MOLTO DISTURBO NUVOLE
sth80c<-unsuperClass(sth80,nClasses=3) 
sth80c
# unsuperClass results
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 1300, 1300, 1690000  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1300, 0, 1300  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
#values     : 1, 3  (min, max)

plot(sth80c$map)  #classe 3: vegetazione, classe 2: roccia + nuvole, classe 1: acqua + altro

#confronto visivo tra immagine e mappa di classificazione
par(mfrow=c(1,2))
plotRGB(sth80,stretch='lin')
plot(sth80c$map)
dev.off()

#calcolo la percentuale di copertura delle varie classi
freq(sth80c$map)
#      value   count
# [1,]     1  407136    --> pixel acqua + altro
# [2,]     2  157183    --> pixel roccia + nuvole
# [3,]     3 1125681    --> pixel vegetazione
s80<-1690000  #totale di pixel ricavato dalle informazioni dell'immagine
prop80<-freq(sth80c$map)/s80
prop80
#             value      count
# [1,] 5.917160e-07 0.24090888    --> 24% acqua + altro
# [2,] 1.183432e-06 0.09300769    --> 9% roccia + nuvole
# [3,] 1.775148e-06 0.66608343    --> 67% vegetazione






#ALTERNATIVA: siccome in sth80 la cloud cover non è indifferente, provo a classificare a priori come NA i valori di riflettanza delle nuvole, ipotizzando siano 251-255
#riclassifico i valori di riflettanza da 251 a 255 come NA per carcare di ridurre il disturbo delle nuvole sulla classificazione in 3 classi successiva
sth80r<-reclassify(sth80,cbind(251:255,NA))
plotRGB(sth80r,stretch='lin')

#quindi procedo con la classificazione sull'immagine sth80r
sth80rc<-unsuperClass(sth80r,nClasses=3) 
sth80rc
# unsuperClass results
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 1300, 1300, 1690000  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1300, 0, 1300  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 3  (min, max)

plot(sth80rc$map)  #classe 3: acqua, classe 2: vegetazione + bosco, classe 1: roccia + zone meno vegetate + nuvole

#confronto visivo tra immagine e mappa di classificazione
par(mfrow=c(1,2))
plotRGB(sth80r,stretch='lin')
plot(sth80rc$map)
dev.off()

#ANCORA PEGGIO










#install.packeages('ggplot2')
library(ggplot2)

#vari indici di vegetazione per sth79
vi79<-spectralIndices(sth79,green=3,red=2,nir=1)





