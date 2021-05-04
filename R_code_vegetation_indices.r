#R_code_vegetation_indices.r

library(raster) #require(raster)

setwd('C:/lab/')

#carico le immagini
defor1<-brick('defor1.jpg')
defor2<-brick('defor2.jpg')

#plotRGB. La B1 è dell'infrarosso, la B2 del rosso e la B3 del verde
par(mfrow=c(2,1))
plotRGB(defor1,r=1,g=2,b=3,stretch='lin') #sul rosso la banda NIR, sul verde la banda del rosso e sul blu la banda del verde 
plotRGB(defor2,r=1,g=2,b=3,stretch='lin')
#più l'acqua è scura più è pura perchè assorbe l'infrarosso, più è chiara più solidi ci sono al suo interno
#la parte chiara è suolo nudo, agricolo. La parte rossa è la foresta

#calcolo dell'indice di vegetazione DVI di defor1: NIR-RED. Devo prima vedere qual è il nome delle bande, richiamando l'immagine
defor1
# names      : defor1.1, defor1.2, defor1.3 
# values :        0,        0,        0 
# max values :      255,      255,      255
# NIR=defor1.1, RED=defor1.2

dvi1<-defor1$defor1.1-defor1$defor1.2 #per ogni pixel prendiamo la riflettanza del NIR e lo sottraiamo alla riflettanza del RED
#Quindi in uscita abbiamo una mappa che è la differenza dei due valori di riflettanza, ovvero la mappa del DVI
plot(dvi1)  #la parte delle zone agricole è molto chiara, con colori tendenti al giallino; la parte del fiume ha colore arancione, mentre la parte della foresta amazzonica è verde

#nuova palette per il DVI
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi1,col=cl,main='DVI at time 1') #main inserisce il titolo alla mappa. Il colore rosso scuro è vegetazione, il fiume è giallo

#DVI di defor2. Prima cerco il nome delle bande
defor2
# names      : defor2.1, defor2.2, defor2.3 
# min values :        0,        0,        0 
# max values :      255,      255,      255

dvi2<-defor2$defor2.1-defor2$defor2.2
plot(dvi2,col=cl,main='DVI at time 2')  #la parte gialla indica suolo nudo

#confrontiamo le 2 immagini di DVI
par(mfrow=c(2,1))
plot(dvi1,col=cl,main='DVI at time 1')
plot(dvi2,col=cl,main='DVI at time 2')

#Se in una zona la foresta è andata distrutta nella seconda mappa dovrei avere un DVI inferiore. Calcolando DVI1-DVI2 ottengo un valore di DVI nella mappa

#per ogni pixel calcolo la differenza di dvi1-dvi2 e ottengo la mappa delle differenze nel dvi
difdvi<-dvi1-dvi2

cld<-colorRampPalette(c('blue','white','red'))(100)
plot(difdvi,col=cld)  #il colore rosso indica valori di differenza maggiori; dove la differenza è più bassa il colore è bianco e azzurro.
#indica dove c'è stata una sofferenza molto alta da parte della vegetazione

#NDVI viene utilizzato per paragonare immagini con risoluzione radiometrica diversa. E' la normalizzazione del DVI. -1<NDVI<+1
#NDVI=(NIR-RED)/(NIR+RED)

#calcolo l'NDVI della prima immagine
ndvi1<-(defor1$defor1.1-defor1$defor1.2)/(defor1$defor1.1+defor1$defor1.2)  #uguale a scrivere dvi1/(defor1$defor1.1+defor1$defor1.2)
plot(ndvi1,col=cl)  #il range dei valori è tra -1 e +1. 

#calcolo l'NDVI della seconda immagine
ndvi2<-(defor2$defor2.1-defor2$defor2.2)/(defor2$defor2.1+defor2$defor2.2)  #uguale a scrivere dvi2/(defor2$defor2.1+defor2$defor2.2)
plot(ndvi2,col=cl)

difndvi<-ndvi1-ndvi2
plot(difndvi,col=cld)

#nel pacchetto RStoolbox c'è la funzione spectralIndices che calcola indici come NDVI, SAVI, ecc...
library(RStoolbox)  #per calcolare gli indici di vegetazione

#spectralIndices di defor1
vi1<-spectralIndices(defor1,green=3,red=2,nir=1) #il numero delle bande si vede dalle informazioni di defor1
plot(vi1,col=cl) #visualizza 15 indici di vario tipo, per esempio di vegetazione e il NDWI che è un indice dell'acqua

#spectralIndices di defor2
vi2<-spectralIndices(defor2,green=3,red=2,nir=1)
plot(vi2,col=cl)









