#R_code_land_cover.r

library(raster)
library(RStoolbox)  #pacchetto per la classificazione
install.packages('ggplot2')
library(ggplot2)  #pacchetto per visualizzare le immagini in maniera più bella
install.packages('gridExtra') #permette di usare ggplot per dati raster con la funzione grid.arrange
library(gridExtra)
setwd('C:/lab/')

#immagini defor1 (1992) e defor2 (2006): NIR 1, RED 2, GREEN 3. https://earthobservatory.nasa.gov/images/35891/deforestation-in-mato-grosso-brazil
#defor1
defor1<-brick('defor1.jpg') #carichiamo il dataset con tutte le bande
plotRGB(defor1,r=1,g=2,b=3,stretch='lin')
ggRGB(defor1,r=1,g=2,b=3,stretch='lin')  #immagine, 3 layer e componenti e strecth. Plotta anche le coordinate spaziali sugli assi x e y
#le immagini defor1 e defor2 non hanno un sistema di riferimento, quindi le coordinate nell'immagine non sono reali, sono la conta dei pixel
#questo succede perchè le immagini sono già processate www.earthobservatorynasa.org

#defor2
defor2<-brick('defor2.jpg')
plotRGB(defor2,r=1,g=2,b=3,stretch='lin')
ggRGB(defor2,r=1,g=2,b=3,stretch='lin')

#confronto tra immagini plotRGB
par(mfrow=c(2,1))
plotRGB(defor1,r=1,g=2,b=3,stretch='lin')
plotRGB(defor2,r=1,g=2,b=3,stretch='lin')

#confronto tra immagini ggRGB grazie al pacchetto gridExtra
#grid.arrange plotta le immagini raster
p1<-ggRGB(defor1,r=1,g=2,b=3,stretch='lin')
p2<-ggRGB(defor2,r=1,g=2,b=3,stretch='lin')
grid.arrange(p1,p2,nrow=2)  #immagini disposte su 2 righe

#Unsupervised Classification con 2 classi: l'inizio non viene supervisionato da noi, è il programma che prende in modo random i training sites
d1c<-unsuperClass(defor1,nClasses=2) 
d1c
# unsuperClass results
# 
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 478, 714, 341292  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 714, 0, 478  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 2  (min, max)       #solo due valori possibili
plot(d1c$map)# classe 1=zona agricola, classe 2=foresta 
#set.seed(3) #per ottenere sempre lo stesso risultato dalla classificazione

d2c<-unsuperClass(defor2,nClasses=2)
d2c
plot(d2c$map) #classe 1=zona agricola, classe 2=foresta

#classificazione con 3 classi
d2c3<-unsuperClass(defor2,nClasses=3)
plot(d2c3$map)  #distingue la foresta in una classe e la zona agricola in due classi. classe 1=foresta, agricolo

#quanto è stato perso di foresta
#calcolo della frequenza dei pixel di una certa classe. Quanti pixel di foresta ci sono? Quanti pixel di zona agricola ci sono?
#proporzioni delle 2 classi nell'immagine defor1
freq(d1c$map)
#     value  count
# [1,]     1  34948     #ci sono 34948 pixel nella zona agricola
# [2,]     2 306344     #ci sono 306344 pixel nella foresta

#proporzione (percentuale) dei pixel nelle 2 classi
s1<-34948+306344  
s1   #341292. Questo numero si trova anche in d1c
prop1<-freq(d1c$map)/s1
prop1
#             value     count
# [1,] 2.930042e-06 0.1023991   #10% di agricolo
# [2,] 5.860085e-06 0.8976009   #90% circa di foresta

#proporzioni delle 2 classi nell'immagine defor2
freq(d2c$map)
#      value  count
# [1,]     1 163672     #zona agricola
# [2,]     2 179054     #foresta
s2<-163672+179054  #342726. Questo numero si trova anche in d2c
s2    #342726. Questo numero si trova anche in d2c
prop2<-freq(d2c$map)/s2
prop2
#             value     count
# [1,] 2.917783e-06 0.4775593   #48% agricolo
# [2,] 5.835565e-06 0.5224407   #52% foresta

#generazione di un dataframe (=dataset)
#1 colonna contenente i fattori: variabili categoriche (foresta e agricolo). 1 colonna contenente le percentuali nel 1992 e un'altra con le percentualil del 2006 
#costruisco le colonne che mi interessa avere nel dataframe
cover<-c('Forest','Agriculture')  #colonna cover contenente due righe: Agriculture e Forest. Sono due vettori quindi utilizzo le virgolette e la c  
percent_1992<-c(89.76,10.23) #colonna contenente i valori percentuali di defor1 che ricavo da prop1
percent_2006<-c(52.24,47.75)  #colonna contenente i valori percentuali di defor2 che ricavo da prop2
#creo il dataframe con il comando data.frame
percentages<-data.frame(cover,percent_1992,percent_2006)
#         cover percent_1992 percent_2006
# 1      Forest        89.76        52.24
# 2 Agriculture        10.23        47.75

#ggplot del dataframe (mpg). aes definisce l'estetica: descrive gli assi x e y e color si riferisce in base a quali oggetti vogliamo discriminare 
#al ggplot si aggiunge il comando geom_bar che crea un istogramma. stat='identify' vuol dire che mantiene i dati così come sono, fill è il colore di riempimento degli istogrammi
ggplot(percentages,aes(x=cover,y=percent_1992,color=cover))+geom_bar(stat='identity',fill='white')  #istogramma con le percentuali del 1992
ggplot(percentages,aes(x=cover,y=percent_2006,color=cover))+geom_bar(stat='identity',fill='white')  #istogramma con le percentuali del 2006

p1<-ggplot(percentages,aes(x=cover,y=percent_1992,color=cover))+geom_bar(stat='identity',fill='white')
p2<-ggplot(percentages,aes(x=cover,y=percent_2006,color=cover))+geom_bar(stat='identity',fill='white')

#uniamo i due grafici nella stessa finestra
grid.arrange(p1,p2,nrow=1) #argomenti e numero di righe
