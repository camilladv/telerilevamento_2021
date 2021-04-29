#R_code_multivariate_analysis.r

library(raster)
library(RStoolbox)
setwd('C:/lab/')

#carico l'immagine Landsat su R. L'immagine ha 7 bande, quindi utilizzo la funzione brick che carica in modo diretto tutte le 7 bande
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

#immagine Landsat: B1=blu, B2=verde, B3=rosso, B4=NIR, B5=infrarosso medio, B6=infrarosso termico, B7=infrarosso medio

#plottiamo la banda del blu contro quella del verde per vedere la correlazione. Dalle informazioni precedentiLa la banda del blu è la B1_sre, la banda del verde la B2_sre
plot(p224r63_2011$B1_sre,p224r63_2011$B2_sre,col='red',pch=20,cex=1) #il pch cambia il simbolo del punto, cex cambia la grandezza. Sulla x c'è B1 e sulla y la B2
#sono due bande molto correlate tra loro linearmente

#pairs plotta tutte le bande una contro l'altra per vedere la loro correlazione. Mette in correlazione, a 2 a 2, ciascuna banda.
pairs(p224r63_2011)
#sulla diagonale ci sono le bande, mentre sulla parte bassa della matrice ci sono i grafici di correlazione.
#i numeri sulla parte alta della matrice rappresentano l'indice della correlazione (-1<R<+1)
#se la correlazione è perfetta positivamente R=+1, mentre se la correlaione è perfetta negativamente R=-1. B1-B2, B1-B3, B2-B3, B3-B7, B5-B7 sono strettamente correlati (R>0.93)

#creiamo un dato più leggero per facilitare la PCA, aggregando i pixel con la funzione aggregate. La risoluzione attuale dell'immagine è 30x30 m. 
#li aggregiamo con un fattore di 10 per ridurre la risoluzione e la dimensione dell'immagine
#aggregate cells: resampling (ricampionamento)
p224r63_2011res<-aggregate(p224r63_2011,fact=10) #fact è il fattore di riduzione, fun la funzione per cui aggrega, in questo caso aggrega i pixel per la media
p224r63_2011res #la risoluzione della nuova immagine è di 300m
#confrontiamo le 2 immagini
par(mfrow=c(2,1))
plotRGB(p224r63_2011,r=4,g=3,b=2,stretch='lin') #infrarosso, rosso,verde
plotRGB(p224r63_2011res,r=4,g=3,b=2,stretch='lin')

#rasterPCA: Principal Component Analysis for Raster
p224r63_2011res_pca<-rasterPCA(p224r63_2011res) #si crea una mappa in uscita e un modello
summary(p224r63_2011res_pca$model) #mi visualizza le informazioni relative al modello. Permette di vedere quanta varianza spiegano le componenti.
#Importance of components:
#                         Comp.1      Comp.2       Comp.3       Comp.4
#Standard deviation     1.2050671 0.046154880 0.0151509526 4.575220e-03
#Proportion of Variance 0.9983595 0.001464535 0.0001578136 1.439092e-05
#Cumulative Proportion  0.9983595 0.999824022 0.9999818357 9.999962e-01
#                             Comp.5       Comp.6       Comp.7
#Standard deviation     1.841357e-03 1.233375e-03 7.595368e-04
#Proportion of Variance 2.330990e-06 1.045814e-06 3.966086e-07
#Cumulative Proportion  9.999986e-01 9.999996e-01 1.000000e+00
#la prima componente spiega il 99% della varianza. Con le prime 3 bande spiego il 99,99%

plot(p224r63_2011res_pca$map) #la prima componente PC1 ha molta variabilità e contiene tutta l'informazione (di distinguono bene la foresta, suolo agricolo...)
#la settima componente ha pochissima variabilità e non si distingue nulla. La PC1 contiene praticamente tutta la variabilità

#informazioni della PCA
p224r63_2011res_pca


47.27






