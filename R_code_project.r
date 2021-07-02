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
plotRGB(sth79)   
plotRGB(sth80,stretch='lin')  #si può notare come è cambiato il colore dell'acqua nel lago sotto, vicino al cratere. Il blu è più chiaro, indica maggiori solidi al suo interno
dev.off()

#calcolo NDVI per sth79, quindi cerco il nome delle bande
# names      : sthelens_ms3_19790829_lrg.1, sthelens_ms3_19790829_lrg.2, sthelens_ms3_19790829_lrg.3 
#rinomino le bande del NIR e del red
NIR79<-sth79$sthelens_ms3_19790829_lrg.1  #con il $ lego la banda all'immagine
RED79<-sth79$sthelens_ms3_19790829_lrg.2
NDVI79<-(NIR79-RED79)/(NIR79+RED79)

#calcolo NDVI per sth80, quindi cerco il nome delle bande
# names      : sthelens_ms2_19800924_lrg.1, sthelens_ms2_19800924_lrg.2, sthelens_ms2_19800924_lrg.3 
NIR80<-sth80$sthelens_ms2_19800924_lrg.1
RED80<-sth80$sthelens_ms2_19800924_lrg.2
NDVI80<-(NIR80-RED80)/(NIR80+RED80)

#confronto i due valori di NDVI del 1979 (prima dell'eruzione) e l'NDVI del 1980 (dopo l'eruzione)
difNDVI<-NDVI80-NDVI79
cl<-colorRampPalette(c('blue','light green','red'))(100)   
plot(difNDVI,col=cl)  #le zone con differenza di NDVI negativa, ovvero che hanno subito una maggiore perdita di vegetazione, sono in blu

#classificazione dell'immagine del 1979 per vedere la copertura del suolo prima dell'eruzione
sth79c<-unsuperClass(sth79,nClasses=4) 
sth79c
# unsuperClass results
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 1084, 1004, 1088336  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1004, 0, 1084  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 4  (min, max)
set.seed(4) #fissa la classificazione in modo che non cambi di volta in volta
clc<-colorRampPalette(c('light green','gray','dark green','blue'))(100)
plot(sth79c$map,col=clc)  #classe 4: acqua (+ versanti più vegetati), classe 3: foresta, classe 2: roccia + suolo nudo, classe 1: vegetazione più rada

#confronto visivo tra immagine e mappa di classificazione
par(mfrow=c(1,2))
plotRGB(sth79,stretch='lin')
plot(sth79c$map)
dev.off()

#calcolo la percentuale di copertura delle varie classi
freq(sth79c$map)
#      value  count
# [1,]     1 132456
# [2,]     2 378754
# [3,]     3 178710
# [4,]     4 398416
s79<-1088336  #totale di pixel ricavato dalle informazioni dell'immagine
prop79<-freq(sth79c$map)/s79
prop79
#             value     count
# [1,] 9.188339e-07 0.1217051   --> 12% vegetazione più rada
# [2,] 1.837668e-06 0.3480120   --> 35% roccia + suolo nudo
# [3,] 2.756502e-06 0.1642048   --> 16% foresta
# [4,] 3.675336e-06 0.3660781   --> 37% acqua (+ versanti più vegetati)

#classificazione dell'immagine del 1980 per vedere la copertura del suolo dopo l'eruzione 
sth80c<-unsuperClass(sth80,nClasses=4) 
sth80c
# unsuperClass results
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 1084, 1008, 1092672  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1008, 0, 1084  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
#values     : 1, 4  (min, max)
set.seed(4)
plot(sth80c$map)  #classe 3: vegetazione, classe 2: roccia + nuvole, classe 1: acqua + altro

#confronto visivo tra immagine e mappa di classificazione
par(mfrow=c(1,2))
plotRGB(sth80,stretch='lin')
plot(sth80c$map,col=clc)
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
#riclassifico i valori di riflettanza da 251 a 255 come NA per cercare di ridurre il disturbo delle nuvole sulla classificazione in 3 classi successiva
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





