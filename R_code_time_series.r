#Time series analysis
#Greenland increase of temperature
#Data and code from Emanuela Cosma

#install.packages('raster')
#install.packages('rasterVis')
library(raster)
library(rasterVis)
setwd('C:/lab/greenland')

#ogni immagine nella cartella greenland è uno strato che rappresenta la stima della temperatura (lst=land surface temperature)
#le immagini che abbiamo riportano una media dell'lst dei primi 10 giorni di luglio 2000, nel 2005, nel 2010 e nel 2015.

#importiano i singoli dataset con la funzione raster
lst_2000<-raster("lst_2000.tif")     #lst=land surface temperature, è la temperatura misurata al suolo da un satellite di Copernicus
plot(lst_2000)  #colori dal bianco al verde. La riflettanza viene data in bit (0/1)
lst_2000  #i numeri interni a "valore" indicano i valori interi di temperatura
lst_2005<-raster("lst_2005.tif")
plot(lst_2005)
lst_2010<-raster("lst_2010.tif")
plot(lst_2010)
lst_2015<-raster("lst_2015.tif")
plot(lst_2015)

#multipannel
par(mfrow=c(2,2))
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)

#creare una lista di file per applicare successivamente la funzione lapply
lst_list <- list.files(pattern="lst")  #pattern definisce i file che vogliamo inserire nella lista attraverso il loro nome
lst_list #lista di tutti i file dentro la cartella greenland con, nel loro nome, la parola lst

#importare lst_list in R attraverso la funzione lapply. Inoltre applica una certa funzione (in questo caso raster) ad una lista di file (lstlist). Raster importa singoli file
lst_import <- lapply(lst_list,raster) #il primo argomento di lapply indica la lista a cui vogliamo applicare la funzione raster che è definita nel secondo argomento 
lst_import  #visualizza le informazioni relative ai 4 file all'interno di list

#raggruppare il pacchetto di file raster separati con la funzione stack
TGr <- stack(lst_import)  #prende tutti i file che ho importanto con lapply e li unisce in un unico blocco
TGr #informazioni del raster stack
plot(TGr) #plotta le 4 immagini senza dover fare un par

plotRGB(TGr,1,2,3,stretch='lin')  #file con valori dei vari anni, quindi sovrapposizione delle 3 immagini (2000,2005,2010) con colori dettati dalle immagini.
#sulla componente red (primo livello) ho messo lst_2000, perciò se ci sono zone in rosso avrò valori più alti di lst nel 2000.
#sulla componente green (secondo livello) ho messo lst_2005, perciò se trovo dei colori verdi, significa che c'è un valore più alto nell'lst nel 2005.
#sulla componente blue (terzo livello) ho messo lst_2010 ci sono zone in blu avrò valori più alti di lst nel 2010. 
#il centro della Groenlandia è blu perciò si piò pensare che la temperatura sia più alta nel 2010, perchè è il livello più alto
plotRGB(TGr,2,3,4,stretch='lin')  #nell'anno più recente (2015) ho valori più alti

#levelplot: si utilizza una singola legenda e si plottano tutti gli strati insieme
levelplot(TGr)
levelplot(TGr$lst_2000) #levelplot di un unico strato. Viene visualizzato come varia la temperatura nella zona.
                        #ll grafico grigio sopra l'immagine indica la temperatura, come media della stessa colonnna o riga della griglia di bit.
                        #valori bassi di temperatura, indicati da numeri interi di bit, sono rappresentati dal colore blu (sulla Gronelandia)
levelplot(TGr$lst_2005)
levelplot(TGr$lst_2010)
levelplot(TGr$lst_2015)

#cambiare i colori della mappa
cl<-colorRampPalette(c("blue","light blue","pink","red"))(100)  #cambiamo i colori della mappa
levelplot(TGr,col.regions=cl)  #il blu scuro indica la temperatura più bassa. Si osserva un trend di cambiamento di temperatura, infatti il colore diventa più azzurro

#i singoli strati di uno stack si chiamano attributi. In questo caso sono 4
#aggiungere i nomi degli attributi con la funzione names.attr=c()
levelplot(TGr,col.regions=cl,names.attr=c("July 2000","July 2005","July 2010","July 2015"))  #aggiunge informazioni ai grafici
#aggiungere il titolo del plot con la funzione main
levelplot(TGr,col.regions=cl,main='LST variation in time',names.attr=c("July 2000","July 2005","July 2010","July 2015"))

#Usiamo i dai che riguardano lo scioglimento (melt)
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



