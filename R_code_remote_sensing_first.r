 Primo codice R per il telerilevamento

#install.packages("raster")
library(raster)     #richiama il pacchetto raster

setwd("C:/lab/")  

p224r63_2011 <- brick("p224r63_2011_masked.grd")  #importa i dati raster dentro R
p224r63_2011     #informazioni sull'immagine
#class      : RasterBrick 
#dimensions : 1499, 2967, 4447533, 7  (nrow, ncol, ncell, nlayers)
#resolution : 30, 30  (x, y)
#extent     : 579765, 668775, -522705, -477735  (xmin, xmax, ymin, ymax)
#crs        : +proj=utm +zone=22 +datum=WGS84 +units=m +no_defs 
#source     : C:/lab/p224r63_2011_masked.grd 
#names      :       B1_sre,       B2_sre,       B3_sre,       B4_sre,       B5_sre,        B6_bt,       B7_sre 
#min values : 0.000000e+00, 0.000000e+00, 0.000000e+00, 1.196277e-02, 4.116526e-03, 2.951000e+02, 0.000000e+00 
#max values :    0.1249041,    0.2563655,    0.2591587,    0.5592193,    0.4894984,  305.2000000,    0.3692634 

#Bande Landsat
#B1: blu
#B2: verde
#B3: rosso
#B4: infrarosso vicino
#B5: infrarosso medio
#B6: infrarosso termico
#B7: infrarosso medio

plot(p224r63_2011)  #visualizza i dati, quindi le 7 bande. B1 blu, B2 verde, B3 rosso, B4 NIR, B5 infrarosso medio, B6 infrarosso termico, B7 infrarosso medio

cl<-colorRampPalette(c('black','grey','light grey'))(100)    #stabilisce la variazione del colore. c crea un array dei colori. 100 intervalli di colore

plot(p224r63_2011,col=cl)    #immagine che vogliamo plottare con i colori di cl

cl<-colorRampPalette(c('yellow','blue','green','purple'))(100)  
plot(p224r63_2011,col=cl)
cl1<-colorRampPalette(c('yellow','purple','green','blue'))(100) 
plot(p224r63_2011,col=cl1)
dev.off() #pulisce la finestra grafica

plot(p224r63_2011$B1_sre) #plotta solamente la prima banda B1 del blu
cl1<-colorRampPalette(c('yellow','purple','green','blue'))(100)
plot(p224r63_2011$B1_sre, col=cl1) #plotta la banda B1 con la palette di colori scelta
dev.off()

par(mfrow=c(1,2)) ##multiframe, plotta più grafici uno di fianco all'altro. Il primo parametro indica le righe, il secondo le colonne, la c è per creare il vettore
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

par(mfrow=c(2,1)) #2 righe, 1 colonna
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

par(mfrow=c(2,2)) #2 righe, 2 colonne
cl1<-colorRampPalette(c('yellow','purple','green','blue'))(100)
plot(p224r63_2011$B1_sre, col=cl1)
cl<-colorRampPalette(c('yellow','blue','green','purple'))(100) 
plot(p224r63_2011$B2_sre, col=cl)
clr <- colorRampPalette(c('green','red','pink','blue'))(100)
plot(p224r63_2011$B3_sre, col=clr)
cln <- colorRampPalette(c('grey','red','orange','yellow'))(100)
plot(p224r63_2011$B4_sre, col=cln)

