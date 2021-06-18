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
click(defor2,id=T,xy=T,cell=T,type='p',pch=16,cex=4,col='purple') #crea un id per ogni punto (T=true); utilizziamo un'informazione spaziale;
                                                                  #n. pixel cliccato; p point; simbolo; character exageration; colore
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






