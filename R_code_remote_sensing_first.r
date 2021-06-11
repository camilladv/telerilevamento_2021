Primo codice R per il telerilevamento

#install.packages("raster")
library(raster)     #richiama il pacchetto raster

setwd("C:/lab/")  

p224r63_2011<-brick("p224r63_2011_masked.grd")  #importa i dati raster dentro R
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

#plottare l'immagine
plot(p224r63_2011)  #visualizza i dati, quindi le 7 bande. B1 blu, B2 verde, B3 rosso, B4 NIR, B5 infrarosso medio, B6 infrarosso termico, B7 infrarosso medio

#creare una palette di colori
cl<-colorRampPalette(c('black','grey','light grey'))(100)    #stabilisce la variazione del colore. c crea un array dei colori. 100 intervalli di colore

plot(p224r63_2011,col=cl)    #immagine che vogliamo plottare con i colori di cl

cl<-colorRampPalette(c('yellow','blue','green','purple'))(100)  #altri colori nella palette
plot(p224r63_2011,col=cl)
cl1<-colorRampPalette(c('yellow','purple','green','blue'))(100) 
plot(p224r63_2011,col=cl1)
dev.off() #pulisce la finestra grafica

#plottare una sola banda
plot(p224r63_2011$B1_sre) #plotta solamente la prima banda B1 del blu
cl1<-colorRampPalette(c('yellow','purple','green','blue'))(100)
plot(p224r63_2011$B1_sre, col=cl1) #plotta la banda B1 con la palette di colori scelta (cl1)
dev.off()

#plottare più grafici contemporaneamente
par(mfrow=c(1,2)) #multiframe. Il primo parametro indica le righe, il secondo le colonne, la c è per creare il vettore
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

par(mfrow=c(2,1)) #2 righe, 1 colonna. Se si volesse avere prima il numero di colonne il comando è par(mfcol=...)
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

#plottare le prime 4 bande
par(mfrow=c(2,2)) #2 righe, 2 colonne
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)

#plottare le prime 4 bande, assegnandogli dei nuovi colori
par(mfrow=c(2,2)) #2 righe, 2 colonne
clb<-colorRampPalette(c('dark blue','blue','light blue'))(100) #colori che richiamano la banda del blu
plot(p224r63_2011$B1_sre, col=clb)
clg<-colorRampPalette(c('dark green','green','light green'))(100) #colori che richiamano la banda del verde
plot(p224r63_2011$B2_sre, col=clg)
clr <- colorRampPalette(c('dark red','red','pink'))(100) #colori che richiamano la banda del rosso
plot(p224r63_2011$B3_sre, col=clr)
cln <- colorRampPalette(c('red','orange','yellow'))(100) #colori che richiamano la banda dell'infrarosso vicino
plot(p224r63_2011$B4_sre, col=cln)

#visualizzazione dell'immagine con RGB, considerando il numero dei layer e utilizzando uno stretch lineare per riportare i valori di riflettanza tra 0 e 1 e visualizzare meglio i colori
plotRGB(p224r63_2011,r=3,g=2,b=1,stretch='Lin') #visualizza l'immagine con i colori che l'occhio umano vede. stretch prende i valori delle singole bande e li dirada per fare in modo che non ci sia uno schiacciamento del colore
plotRGB(p224r63_2011,r=4,g=3,b=2,stretch='Lin') #la componente red visualizza le riflettanze nell'infrarosso (layer 4). La vegetazione è in rosso. Zone più scure indicano una maggiore umidità
plotRGB(p224r63_2011,r=3,g=4,b=2,stretch='Lin') #montando la banda 4 sul green il suolo nudo, senza vegetazione, viene indicato dal colore viola
plotRGB(p224r63_2011,r=3,g=2,b=4,stretch='Lin') #infrarosso nel blu. Il suolo nudo è giallo

#multiframe 2X2 con le 4 bande
par(mfrow=c(2,2))
plotRGB(p224r63_2011,r=3,g=2,b=1,stretch='Lin') 
plotRGB(p224r63_2011,r=4,g=3,b=2,stretch='Lin')
plotRGB(p224r63_2011,r=3,g=4,b=2,stretch='Lin') 
plotRGB(p224r63_2011,r=3,g=2,b=4,stretch='Lin')

#salvare l'immagine in pdf. Non visualizza le immagini in R, le salva solo
pdf('immagini_RGB.pdf')
par(mfrow=c(2,2))
plotRGB(p224r63_2011,r=3,g=2,b=1,stretch='Lin') 
plotRGB(p224r63_2011,r=4,g=3,b=2,stretch='Lin')
plotRGB(p224r63_2011,r=3,g=4,b=2,stretch='Lin') 
plotRGB(p224r63_2011,r=3,g=2,b=4,stretch='Lin')
dev.off()

#RGB con stretch non lineare, ma 'hist', una funzione ad s che ha una pendenza maggiore centralmente
par(mfrow=c(1,2))
plotRGB(p224r63_2011,r=3,g=4,b=2,stretch='lin')
plotRGB(p224r63_2011,r=3,g=4,b=2,stretch='hist') #evidenzia maggiormente le zone più umide, colorandole di viola

#RGB con colori naturali, colori falsi, colori falsi con istogramma stretch
par(mfrow=c(3,1))
plotRGB(p224r63_2011,r=3,g=2,b=1,stretch='lin') #colori naturali, strecth lineare
plotRGB(p224r63_2011,r=3,g=4,b=2,stretch='lin') #colori falsi, strecth lineare
plotRGB(p224r63_2011,r=3,g=4,b=2,stretch='hist') #colori falsi, stretch istogrammi

#multitemporal set
p224r63_1988<-brick("p224r63_1988_masked.grd") #importa un nuovo file
p224r63_1988 #riporta le informazioni relative all'immagine
plot(p224r63_1988) #visualizzazione delle singole bande. Essendo sempre un'immagine Landsat le 7 bande sono le stesse dell'immagine p224r63_2011
plotRGB(p224r63_1988,r=3,g=2,b=1,stretch='lin') #il violetto sulla parte destra delle immagini sono delle interferenze
plotRGB(p224r63_1988,r=4,g=3,b=2,stretch='lin') #visualizza l'infrarosso vicino nel rosso. Perciò viene evidenziata la vegetazione

#confronto tra la vegetazione del 1988 e quella del 2011
par(mfrow=c(2,2))
plotRGB(p224r63_1988,r=4,g=3,b=2,stretch='lin')
plotRGB(p224r63_2011,r=4,g=3,b=2,stretch='lin') #si vede nettamente il confine tra foresta e zone coltivate
plotRGB(p224r63_1988,r=4,g=3,b=2,stretch='hist') #disturbata dalla qualità dell'immagine
plotRGB(p224r63_2011,r=4,g=3,b=2,stretch='hist')

#creare il pdf di confronto
pdf('immagini_RGB_88-2011_lh.pdf')
par(mfrow=c(2,2))
plotRGB(p224r63_1988,r=4,g=3,b=2,stretch='lin')
plotRGB(p224r63_2011,r=4,g=3,b=2,stretch='lin')
plotRGB(p224r63_1988,r=4,g=3,b=2,stretch='hist')
plotRGB(p224r63_2011,r=4,g=3,b=2,stretch='hist')
dev.off()
