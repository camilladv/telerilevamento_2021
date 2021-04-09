#Time series analysis
#Greenland increase of temperature
#Data and code from Emanuela Cosma

install.packages('rasterVis')
library(rasterVis)
library(raster)
setwd('C:/lab/greenland')

#importiano una time series su R
lst_2000 <- raster("lst_2000.tif")     #lst=land surface temperature, è la temperatura misurata al suolo da un satellite di Copernicus
lst_2005 <- raster("lst_2005.tif")
lst_2010 <- raster("lst_2010.tif")
lst_2015 <- raster("lst_2015.tif")

# par
par(mfrow=c(2,2))
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)

# list f files:
rlist <- list.files(pattern="lst")  #fa la lista di tutti i file che hanno al loro interno list
rlist

#dare le informazini di tutte le 4 immagini in un unico comando
import <- lapply(rlist,raster)  #applica la funzioni a tutti i file nella lista
import

TGr <- stack(import)  #prende tutti i file e li unisce in un unico blocco
TGr #informazioni dello stack
plot(TGr)

levelplot(TGr$lst_2000) #come varia la temperatura nella zona. Il grafico grigio sopra l'immagine indica la temperatura del ghiaccio
levelplot(TGr$lst_2005)
levelplot(TGr$lst_2010)
levelplot(TGr$lst_2015)

levelplot(TGr)
cl <- colorRampPalette(c("blue","light blue","pink","red"))(100)
levelplot(TGr, col.regions=cl)  #il blu scuro indica la temperatura più bassa. Si osserva un trend di cambiamento di temperatura

levelplot(TGr,col.regions=cl, names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))  #aggiunge informazioni ai grafici
levelplot(TGr,col.regions=cl, main='LST variation in time', names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))

#Melt
meltlist<-list.files(pattern='melt')  #unisce tutti i file con la parola melt
meltlist
melt_import<-lapply(meltlist,raster) #importazione dei file
melt<-stack(melt_import)  #stack di tutti i file che ho importato
melt
levelplot(melt) #mostra lo scioglimento effettivo del ghiaccio. Tra il 1979 e il 2007 la striscia di ghiaccio perso è molto più grande

#differenza tra un'immagine e l'altra (più recente - meno recente). Più alto è il valore più scioglimento c'è stato
melt_amount<-melt$X2007annual_melt-melt$X1979annual_melt
melt_amount
cl_a<-colorRampPalette(c("blue","white","red"))(100)
plot(melt_amount,col=cl_a)
levelplot(melt_amount,col.regions=cl_a)

install.packages('knitr')
library(knitr)



