#R_code_multivariate_analysis.r

library(raster)
library(RStoolbox)
setwd('C:/lab/')

#carico l'immagine Landsat su R. L'immagine ha 7 bande, quindi utilizzo la funzione brick che carica tutte e 7 le bande.
#la funzione raster carica una banda alla volta
p224r63_2011<-brick('p224r63_2011_masked.grd')
plot(p224r63_2011)

#informazioni dell'immagine
p224r63_2011
#class      : RasterBrick 
#dimensions : 1499, 2967, 4447533, 7  (nrow, ncol, ncell, nlayers)
#resolution : 30, 30  (x, y)
#extent     : 579765, 668775, -522705, -477735  (xmin, xmax, ymin, ymax)
#crs        : +proj=utm +zone=22 +datum=WGS84 +units=m +no_defs 
#source     : C:/lab/p224r63_2011_masked.grd 
#names      :       B1_sre,       B2_sre,       B3_sre,       B4_sre,       B5_sre,        B6_bt,       B7_sre 
#min values : 0.000000e+00, 0.000000e+00, 0.000000e+00, 1.196277e-02, 4.116526e-03, 2.951000e+02, 0.000000e+00 
#max values :    0.1249041,    0.2563655,    0.2591587,    0.5592193,    0.4894984,  305.2000000,    0.3692634 

#plottiamo la banda del blu contro quella del verde, ovvero banda 1 contro banda 2, guardando il nome delle bande nelle informazioni precedenti
plot(p224r63_2011$B1_sre,p224r63_2011$B2_sre,col='red',pch=20,cex=1) #il pch cambia il simbolo del punto, cex cambia la grandezza. Sulla x c'è B1 e sulla y la B2
#sono due bande molto correlate tra loro linearmente

#pairs plotta tutte le bande una contro l'altra per vedere la loro correlazione. Mette in correlazione, a 2 a 2, ciascuna banda.
#sulla diagonale ci sono le bande, mentre sulla parte bassa della matrice ci sono i grafici di correlazione.
#I numeri sulla parte alta della matrice rappresentano l'indice della correlazione (-1<ic<1).
#Se la correlazione è perfetta positivamente l'indice vale +1, mentre se la correlaione è perfetta negativamente vale -1.
pairs(p224r63_2011)
#B1-B2, B1-B3, B2-B3, B3-B7, B5-B7 sono strettamente correlati (indice di correlazione >0.93)
