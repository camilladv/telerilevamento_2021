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

#calcolo della deviazione standard che si può fare solamente su una banda, per esempio di NDVI
#nome delle bande di sent
sent
#....
#names      : sentinel.1, sentinel.2, sentinel.3, sentinel.4 
nir<-sent$sentinel.1
red<-sent$sentinel.2

#NDVI
ndvi<-(nir-red)/(nir+red)
plot(ndvi)  #bianco=acqua,a assenza di vegetazione, marroncino=roccia, giallo e verde chiaro=bosco, verde scuro=praterie
cl<-colorRampPalette(c('black','white','red','magenta','green'))(100)
plot(ndvi,col=cl)

#calcolo della variabilità (deviazione standard) di ndvi, immagine ad unica banda con la funzione focal
ndvisd3<-focal(ndvi,w=matrix(1/9,nrow=3,ncol=3),fun=sd) #w è la window, inseriamo la dimensione della matrice, solitamente quadrata; sd deviaizone standard
plot(ndvisd3)
clsd<-colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)
plot(ndvisd3,col=clsd)  #colori tendendi al rosso e al giallo la sd è più alta


1.05



