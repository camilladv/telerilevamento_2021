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

#Usiamo i dai che riguardano lo scioglimento (melt). Immagini raccolte dal satellite Nimbus 7. Le immagini sonon a 16 bit, quindi hanno 65536 valori possibili
melt_list<-list.files(pattern='melt')  #unisce tutti i file con la parola melt in un'unica lista
melt_list
melt_import<-lapply(melt_list,raster) #importazione della lista
melt<-stack(melt_import)  #stack di tutti i file che ho importato
melt  #informazioni del rasterstack con i nomi dei layer
levelplot(melt) #mostra i valori dello scioglimento dei ghiacci. più alto è il valore maggiore è lo scioglimento.
                #Si nota che tra il 1979 e il 2007 la striscia di ghiaccio che è stato perso nello 07 è molto più grande di quella del 79

#metric algebra: differenza tra un'immagine e l'altra (più recente - meno recente). Più alto è il valore ottenuto più scioglimento c'è stato
melt_amount<-melt$X2007annual_melt-melt$X1979annual_melt  #i nomi dei dati li trovo nelle informazioni di melt. Dobbiamo legare ogni raster interno al proprio file con il $
melt_amount
cla<-colorRampPalette(c("blue","white","red"))(100)  #valori bassi in blue, medi in white e alti in red
plot(melt_amount,col=cla) #tutte le zone rosse sono quelle dove dal 2007 al 1979 è avvenuto il maggior tasso di scioglimento
levelplot(melt_amount,col.regions=cla)  #il colore esterno in realtà è un NA, quindi assenza di valore



