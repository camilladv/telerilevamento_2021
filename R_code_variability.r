#R_code_variability.r

library(raster)
library(RStoolbox)
library(ggplot2)  #per plottare i ggplot
library(gridExtra)  #per plottare insieme i ggplots
#install.packages('viridis')
library(viridis)  #serve per colorare i ggplot in modo automatico
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
plot(ndvisd3,col=clsd)  #colori tendendi al rosso e al giallo la deviazione standard è più alta.
#La sd è molto bassa nelle zone di roccia nuda (blu), mentre aumenta nelle zone di confine tra roccia e vegetazione (verde).
# E'omogenea e più alta nelle parti vegetate (es. prateria d'alta quota) e le parti rosa indicano i crepacci, in cui la variabilità è più alta

#media sull'NDVI
ndvimean3<-focal(ndvi,w=matrix(1/9,nrow=3,ncol=3),fun=mean)
plot(ndvimean3,col=clsd)  #valori alti per la vegetazione e valori bassi per la roccia mura

#cambio delle dimensioni della matrice
ndvisd7<-focal(ndvi,w=matrix(1/49,nrow=7,ncol=7),fun=sd)
plot(ndvisd7,col=clsd)  #raggruppamento dei pixel
#la dimenzione della finestra dipende dalla risoluzione spaziale dell'immagine e dall'analisi che vogliamo fare
#in questo caso la matrice ottimale è 5x5
ndvisd5<-focal(ndvi,w=matrix(1/25,nrow=5,ncol=5),fun=sd)
plot(ndvisd5,col=clsd)

#Utilizziamo la banda PC1 per calcolare la deviazione standard
#PCA (analisi multivariata)
sentpca<-rasterPCA(sent)
sentpca
summary(sentpca$model)
# Importance of components:
#                            Comp.1     Comp.2      Comp.3 Comp.4
# Standard deviation     77.3362848 53.5145531 5.765599616      0
# Proportion of Variance  0.6736804  0.3225753 0.003744348      0
# Cumulative Proportion   0.6736804  0.9962557 1.000000000      1
      
#la prima componente principale spiega il 67% della variabilità, quindi contiene la maggiore informazione
plot(sentpca$map)

sentpca$map #permette di vedere i nomi delle componenti priccipali
#...
# names      :       PC1,       PC2,       PC3,       PC4

pc1<-sentpca$map$PC1   #creato l'oggetto della prima componente principale a cui applicare la funzione focal

#applicazione della funzione focal per la deviazione standard sulla pc1
pc1sd5<-focal(pc1,w=matrix(1/25,nrow=5,ncol=5),fun=sd)
clpc<-colorRampPalette(c('blue','green','purple','magenta','orange','brown','red','yellow'))(100)
plot(pc1sd5,col=clpc)   #la parte di vegetazione è blu ed omogenea (pascoli), aumento di variabilità nelle zone di roccia

#richiamare un pezzo di codice presente nella working directory lab con la funzione source
source('source_test_lezione.r')     #non si vedono i comandi, appare solo il risultato finale
#deviazione standard di una finestra 7x7 su pc1

#funzione source
source('source_ggplot.r')
#vediamo i comandi all'interno.
#dobbiamo plottiamo i dati, quindi prima creiamo la finestra vuota tramite la funzione ggplot contenuta nel pacchetto ggplot2. Con il + si aggiungono dei pezzi alla finestra
# ggplot() +
# geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) +      #viene definita la geometria (raster, perchè abbiamo dei pixel) della mappa pc1sd5.
                      #poi definiamo le estetics con mapping: sull'asse x mettiamo la x, sull'asse y la y e come valori di riempimento lo strato (layer)                       
#la parte in alto a sinistra con i crepacci è molto visibile con la dev. standard in ggplot, perchè è molto varibaile
#a livello geografico si nota ogni differenza geomorfologica, a livello ecologico serve ad individuare qualisasi variabilità ecologica (es. ecotipi)
# scale_fill_viridis() +     #per inserirla è sufficiente aggiungere il nome della legenda al codice, non serve scrivere una colorRampPalette. Non aggiungendo un nome di legenda quella utilizzata è la default 
#garantisce che tutte le leggende utilizzate possano essere viste da chiunque, anche da chi ha patologie alla vista.
#ggtitle('Standard deviation of OC1 by viridis colour scale')     #inserisce un titolo al grafico

#la funzione intera è:
p1<-ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis() + ggtitle('Standard deviation of PC1 by viridis colour scale')

#usiamo la legenda inferno
p2<-ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis(option='inferno') + ggtitle('Standard deviation of PC1 by inferno colour scale')

#usiamo la legenda turbo
p3<-ggplot() +
geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis(option='turbo') + ggtitle('Standard deviation of PC1 by turbo colour scale')

#uniamole in un'unica finestra. Prima assegniamo un nome ai 3 diversi grafici
grid.arrange(p1,p2,p3,nrow=1)
#la legenda turbo ha il giallo che risalta molto, ma indica valori medi, quindi non è molto potente dal punto di vista comunicativo.
#Lo scopo di queste mappe è mettere in evidenza le zone con la massima variabilità, quindi con un colore che salta all'occhio.
#Quelle utili dal punto di vista informativo sono viridis e magma
