#R_code_spectral_signatures.r

library(raster)
library(rgdal)  #per usare dei vettoriali
library(ggplot2)

setwd('C:/lab')

#caricare tutte le bande con brick
defor2<-brick('defor2.jpg') #3 bande: defor2.1 NIR, defor2.2 red, defor 2.3 green

plotRGB(defor2,r=1,g=2,b=3,stretch='lin')
plotRGB(defor2,r=1,g=2,b=3,stretch='hist')  #differenze maggiori e più evidenti

#creare le firme spettrali con la funzione click. Una volta inserita la funzione basterà cliccare sull'immagine per ottenere il grafico della firma spettrale (informazioni)
click(defor2,id=T,xy=T,cell=T,type='p',pch=16,cex=4,col='yellow') #crea un id per ogni punto (T=true); utilizziamo un'informazione spaziale;
                                                                  #n. pixel cliccato; p point; simbolo; (character exageration non funziona); colore
#da le informzioni sulla riflettanza nel NIR, nel red e nel green.
#In un pixel di vegetazione la prima banda avrà un valore alto, nella seconda basso perchè la vegetazione assorbe il rosso, sul green un valore intermedio ma basso.
#In un pixel del fiume la riflettanza nel NIR è bassa, alta in rosso e ancora più alta nel verde.
#results
#       x     y   cell defor2.1 defor2.2 defor2.3
# 1 149.5 249.5 163626      198       16       31   #vegetazione
#       x     y   cell defor2.1 defor2.2 defor2.3   #fiume
# 1 412.5 102.5 269288       48       98      157

#per uscire dalla funzione si deve chiudere la finestra dell'immagine

#creare un dataframe con 3 colonne: numero banda, foresta, acqua e i valori di riflettanza sulle righe
#definire le colonne del dataset
band<-c(1,2,3) #definito da un vettore di righe
Forest<-c(198,16,31) #valore di riflettanza della foresta. Li prendo da quelli ottenuti con click
Water<-c(48,98,157) #valore di riflettanza del fiume. Li prendo da quelli ottenuti con click

#creare il dataframe (tabella)
spectrals<-data.frame(band,Forest,Water)
spectrals
#   band Forest Water
# 1    1    198    48
# 2    2     16    98
# 3    3     31   157

#plottiamo la firma spettrale
ggplot(spectrals,aes(x=band))+ #sull'asse x le bande, lo definiamo dentro aestetics
  geom_line(aes(y=Forest),col='green') +  #inserisce le geometrie che ci interessa, per esempio delle linee. Sull'asse delle y i valori di riflettanza della foresta
  geom_line(aes(y=Water),col='blue') +  #aggiunge, sull'asse delle y, anche i valori di riflettanza dell'acqua
  labs(x='band',y='reflectance') #nome degli assi

###Multitemporal
defor1<-brick('defor1.jpg')
plotRGB(defor1,r=1,g=2,b=3,stretch='lin')
plotRGB(defor1,r=1,g=2,b=3,stretch='hist')

#spectral signature defor1
#time1
click(defor1,id=T,xy=T,cell=T,type='p',pch=16,col='yellow') #serve avere il plot aperto
#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 82.5 336.5 100757      217       18       37
#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 48.5 333.5 102865      213       17       31
#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 14.5 336.5 100689      225       21       33
#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 72.5 319.5 112885      207       10       27
#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 85.5 391.5 61490      220       26       52

#time 2
plotRGB(defor2,r=1,g=2,b=3,stretch='lin')
click(defor1,id=T,xy=T,cell=T,type='p',pch=16,col='yellow')
#      x     y  cell defor1.1 defor1.2 defor1.3
# 1 56.5 350.5 90735      182       57       73
#      x     y  cell defor1.1 defor1.2 defor1.3
# 1 98.5 347.5 92919      219       13       26
#      x     y  cell defor1.1 defor1.2 defor1.3
# 1 58.5 373.5 74315      162       87       82
#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 76.5 328.5 106463      224       17       37
#      x     y   cell defor1.1 defor1.2 defor1.3
# 1 98.5 317.5 114339      203        5       22

#definire le colonne del dataset
band<-c(1,2,3) #definito da un vettore di righe
time1<-c(217,18,37) #valore di riflettanza in defor1
time2<-c(182,57,73) #valore di riflettanza in defor2

#creare il dataframe (tabella)
spectralst<-data.frame(band,time1,time2)
spectralst
#   band time1 time2
# 1    1   217   182
# 2    2    18    57
# 3    3    37    73

ggplot(spectralst,aes(x=band))+ 
  geom_line(aes(y=time1),col='red') +  
  geom_line(aes(y=time2),col='black') + 
  labs(x='band',y='reflectance')

#il time1 è vegetato, il time2 anche...

#inseriamo un altro pixel
band<-c(1,2,3) 
time1<-c(217,18,37)
time1p2<-c(213,17,31)
time2<-c(182,57,73)
time2p2<-c(219,13,26)

spectralst2<-data.frame(band,time1,time1p2,time2,time2p2)
spectralst2
#   band time1 time1p2 time2 time2p2
# 1    1   217     213   182     219
# 2    2    18      17    57      13
# 3    3    37      31    73      26

ggplot(spectralst2,aes(x=band))+ 
  geom_line(aes(y=time1),col='red',linetype='dotted') +  #linetype inserisce dei punti al posto della linea continua
  geom_line(aes(y=time1p2),col='red',linetype='dotted') +
  geom_line(aes(y=time2),col='black',linetype='dotted') + 
  geom_line(aes(y=time2p2),col='black',linetype='dotted') +
  labs(x='band',y='reflectance')

#random_point per selezionare i punti in modo casuale

#altra immagine
peru<-brick('perugoldtypes_oli_2020111.jpg')
plotRGB(peru,1,2,3,stretch='hist')

click(peru,id=T,xy=T,cell=T,type='p',pch=16,col='yellow')
#     x     y    cell     perugoldtypes_oli_2020111.1 perugoldtypes_oli_2020111.2 perugoldtypes_oli_2020111.3
# 1 42.5 352.5   91483                13                          48                          44
#     x     y    cell     perugoldtypes_oli_2020111.1 perugoldtypes_oli_2020111.2 perugoldtypes_oli_2020111.3
# 1 158.5 186.5  211119               199                         195                         98           
#     x     y    cell     perugoldtypes_oli_2020111.1 perugoldtypes_oli_2020111.2 perugoldtypes_oli_2020111.3
# 1 163.5 324.5 111764                18                          107                         63
  
band<-c(1,2,3)
point1<-c(13,48,44) 
point2<-c(199,195,98)
point3<-c(18,107,63)               

spectralp<-data.frame(band,point1,point2,point3)
spectralp
#   band point1 point2 point3
# 1    1     13    199     18
# 2    2     48    195    107
# 3    3     44     98     63

ggplot(spectralp,aes(x=band))+ 
  geom_line(aes(y=point1),col='yellow') + 
  geom_line(aes(y=point2),col='blue') +
  geom_line(aes(y=point3),col='green') + 
  labs(x='band',y='reflectance')

