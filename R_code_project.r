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

#importo l'immagine del 1981 (dopo l'eruzione) con tutte le sue bande
sth81<-brick('sthelens_ms3_19810823_lrg.jpg')
ggRGB(sth81,r=1,g=2,b=3,stretch='lin')

#plotto le due immagini in contemporanea
h79<-ggRGB(sth79,r=1,g=2,b=3)
h81<-ggRGB(sth81,r=1,g=2,b=3,stretch='lin')
grid.arrange(h79,h81,nrow=1)  #immagini disposte su 1 riga
dev.off()

#calcolo NDVI per sth79, quindi cerco il nome delle bande
# names      : sthelens_ms3_19790829_lrg.1, sthelens_ms3_19790829_lrg.2, sthelens_ms3_19790829_lrg.3 
#rinomino le bande del NIR e del red
NIR79<-sth79$sthelens_ms3_19790829_lrg.1  #con il $ lego la banda all'immagine
RED79<-sth79$sthelens_ms3_19790829_lrg.2
NDVI79<-(NIR79-RED79)/(NIR79+RED79)

#calcolo NDVI per sth81, quindi cerco il nome delle bande
# names      : sthelens_ms3_19810823_lrg.1, sthelens_ms3_19810823_lrg.2, sthelens_ms3_19810823_lrg.3  
NIR81<-sth81$sthelens_ms3_19810823_lrg.1
RED81<-sth81$sthelens_ms3_19810823_lrg.2
NDVI81<-(NIR81-RED81)/(NIR81+RED81)

#confronto i due valori di NDVI del 1979 (prima dell'eruzione) e l'NDVI del 1981 (dopo l'eruzione)
difNDVI<-NDVI81-NDVI79
cl<-colorRampPalette(c('blue','light green','red'))(100)   
plot(difNDVI,col=cl,main='NDVI difference')  #le zone con differenza di NDVI negativa, ovvero che hanno subito una maggiore perdita di vegetazione, sono in blu

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
# [1,] 9.188339e-07 0.18490705   --> 18% roccia + suolo nudo
# [2,] 1.837668e-06 0.09690941   --> 10% acqua + alcuni versanti
# [3,] 2.756502e-06 0.33005156   --> 33% foresta
# [4,] 3.675336e-06 0.04227555   --> 4% neve + suolo nudo
# [5,] 4.594169e-06 0.34585643   --> 35% vegetazione

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
# [1,] 9.106664e-07 0.1494695   --> 15% roccia + suolo nudo
# [2,] 1.821333e-06 0.1702709   --> 17% acqua + alcuni versanti
# [3,] 2.731999e-06 0.3281377   --> 33% foresta
# [4,] 3.642665e-06 0.0811850   --> 8% suolo nudo
# [5,] 4.553332e-06 0.2709369   --> 27% vegetazione

cover<-c('Roccia','Acqua','Foresta','Suolo nudo','Vegetazione')  #colonna cover contenente le 5 classi di copertura del suolo  
perc_79<-c(18.49,9.69,33.00,4.22,34.58) #colonna contenente i valori percentuali di sth79c che ricavo da prop79
perc_81<-c(14.94,17.02,32.81,8.11,27.09)  #colonna contenente i valori percentuali di sth81c che ricavo da prop81
#creo il dataframe con il comando data.frame
cover_perc<-data.frame(cover,perc_79,perc_81)
cover_perc
#         cover perc_79 perc_81
# 1      Roccia   18.49   14.94
# 2       Acqua    9.69   17.02
# 3     Foresta   33.00   32.81
# 4  Suolo nudo    4.22    8.11
# 5 Vegetazione   34.58   27.09

#Firme spettrali delle zone che hanno subito una maggiore differrenziazione 
#apro il plot su cui cliccare
plotRGB(sth79)
click(sth79,id=T,xy=T,cell=T,type='p',pch=16,col='yellow')  #immagine, crea un id per ogni punto selezionato; utilizziamo un'informazione spaziale;
                                                            #n. pixel cliccato; p point; forma simbolo; colore simbolo nella mappa
#      x     y   cell    sthelens_ms3_19790829_lrg.1 sthelens_ms3_19790829_lrg.2 sthelens_ms3_19790829_lrg.3
# 1 721.5 788.5 296902                           7                          16                          33
#                        
#       x     y   cell   sthelens_ms3_19790829_lrg.1 sthelens_ms3_19790829_lrg.2  sthelens_ms3_19790829_lrg.3
# 1 854.5 590.5 495827                         124                          56                          55
#                       
#       x     y   cell   sthelens_ms3_19790829_lrg.1 sthelens_ms3_19790829_lrg.2  sthelens_ms3_19790829_lrg.3
# 1 600.5 867.5 217465                         188                          48                          55

plotRGB(sth81,stretch='lin')
click(sth81,id=T,xy=T,cell=T,type='p',pch=16,col='yellow')
#      x     y   cell    sthelens_ms3_19810823_lrg.1 sthelens_ms3_19810823_lrg.2 sthelens_ms3_19810823_lrg.3
# 1 716.5 793.5 304020                         171                         155                         132
# 
#       x     y   cell   sthelens_ms3_19810823_lrg.1 sthelens_ms3_19810823_lrg.2  sthelens_ms3_19810823_lrg.3
# 1 851.5 591.5 506357                         179                         171                         158
# 1                         
#       x     y   cell   sthelens_ms3_19810823_lrg.1 sthelens_ms3_19810823_lrg.2  sthelens_ms3_19810823_lrg.3
# 1 596.5 857.5 239836                         210                         208                         193














#vari indici di vegetazione per sth79
vi79<-spectralIndices(sth79,green=3,red=2,nir=1)





