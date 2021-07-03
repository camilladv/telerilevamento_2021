#install.packages('raster')
#install.packages'RStoolbox')
#install.packages('ggplot2')
#install.packages('gridExtra')
library(raster)
library(RStoolbox)  #per classificazione
library(ggplot2)
library(gridExtra)  #per più immagini ggplot contemporaneamente

#set working directory
setwd('C:/lab/Progetto')

#importo l'immagine del 1979 (prima dell'eruzione) con tutti i suoi livelli
sth79<-brick('sthelens_ms3_19790829_lrg.jpg')  #serve il pacchetto raster
#guardo le informazioni relative all'immagine
sth79 #ha 3 bande: B1 NIR, B2 red e B3 green
#visualizzo l'immagine che ha la banda del NIR sul rosso. Viene evidenziata la vegetazione
ggRGB(sth79,r=1,g=2,b=3,stretch='lin')  #coordinate non reali

#importo l'immagine del 1980 (dopo l'eruzione) con tutte le sue bande
sth80<-brick('sthelens_ms2_19800924_lrg.jpg')
ggRGB(sth80,r=1,g=2,b=3,stretch='lin')

#plotto le due immagini in contemporanea
h79<-ggRGB(sth79,r=1,g=2,b=3,stretch='lin')
h80<-ggRGB(sth80,r=1,g=2,b=3,stretch='lin')
grid.arrange(h79,h80,nrow=2)  #immagini disposte su 1 riga
#si può notare come è cambiato il colore dell'acqua nel lago sotto, vicino al cratere. Il blu è più chiaro, indica maggiori solidi al suo interno
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

#Copertura del suolo prima e dopo l'eruzione. Classificazione in 5 classi

#situazione nel 1979
sth79c<-unsuperClass(sth79,nClasses=5)
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
# values     : 1, 5  (min, max)
c5<-colorRampPalette(c('brown','blue','green','gray','light green'))(100)
plot(sth79c$map,col=c5,main='1979 classification')
#classe 1: roccia + suolo nudo, classe 2: acqua + alcuni versanti, classe 3: foresta, classe 4: neve + suolo nudo, classe 5: vegetazione

#FORSE
#confronto visivo tra immagine e mappa di classificazione
par(mfrow=c(1,2))
plotRGB(sth79,stretch='lin')
plot(sth79c$map,col=c5,main='1979 classification')
dev.off()

#calcolo la percentuale di copertura delle varie classi
freq(sth79c$map)
#      value  count
# [1,]     1 201241
# [2,]     2 105470
# [3,]     3 359207
# [4,]     4  46010
# [5,]     5 376408
s79<-1088336  #totale di pixel ricavato dalle informazioni dell'immagine
prop79<-freq(sth79c$map)/s79
prop79
#           value      count
# [1,] 9.188339e-07 0.18490705    --> 18% roccia + suolo nudo
# [2,] 1.837668e-06 0.09690941    --> 10% acqua + alcuni versanti
# [3,] 2.756502e-06 0.33005156    --> 33% foresta
# [4,] 3.675336e-06 0.04227555    --> 4% neve + suolo nudo
# [5,] 4.594169e-06 0.34585643    --> 35% vegetazione

#carico la foto del 1981 per vedere la differenza di copertura del suolo
sth81<-brick('sthelens_ms3_19810823_lrg.jpg')

#situazione nel 1981
sth81c<-unsuperClass(sth81,nClasses=5)
sth81c
# unsuperClass results
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 1097, 1001, 1098097  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1001, 0, 1097  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 5  (min, max)
c5<-colorRampPalette(c('brown','blue','green','gray','light green'))(100)
plot(sth81c$map,col=c5,main='1981 classification')
#classe 1: roccia + suolo nudo, classe 2: acqua + alcuni versanti, classe 3: foresta, classe 4: neve + suolo nudo, classe 5: vegetazione

#FORSE
#confronto visivo tra immagine e mappa di classificazione
par(mfrow=c(1,2))
plotRGB(sth81,stretch='lin')
plot(sth81c$map,col=c5,main='1981 classification')
dev.off()

#calcolo la percentuale di copertura delle varie classi
freq(sth81c$map)
#      value  count
# [1,]     1 164132
# [2,]     2 186974
# [3,]     3 360327
# [4,]     4  89149
# [5,]     5 297515
s81<-1098097  #totale di pixel ricavato dalle informazioni dell'immagine
prop81<-freq(sth81c$map)/s81
prop81
#             value     count
# [1,] 9.106664e-07 0.1494695    --> 15% roccia + suolo nudo
# [2,] 1.821333e-06 0.1702709    --> 17% acqua + alcuni versanti
# [3,] 2.731999e-06 0.3281377    --> 33% foresta
# [4,] 3.642665e-06 0.0811850    --> 8% suolo nudo
# [5,] 4.553332e-06 0.2709369    --> 27% vegetazione















#vari indici di vegetazione per sth79
vi79<-spectralIndices(sth79,green=3,red=2,nir=1)





