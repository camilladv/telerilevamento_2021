#R code complete - Telerilevamento geo-ecologico

#---------------------------------------------------

#Summary:
# 1. Remote sensing - first code
# 2. Time Series
# 3. Copernicus
# 4. Knitr
# 5. Classification
# 6. Multivariate Analysis
# 7. ggplot2
# 8. Vegetation Indices
# 9. Land Cover
# 10. Variability

#---------------------------------------------------

# 1. Remote sensing - first code

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

#---------------------------------------------------

# 2. Time Series

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

#---------------------------------------------------

# 3. Copernicus

#R_code_copernicus_r
#Visualizing Copernicus data

#install.packages('ncdf4')
library(raster)
library(ncdf4)

setwd('C:/lab')

#carichiamo un singolo strato, quindi si usa la funzione raster
water_bodies<-raster('c_gls_WB300_202010010000_GLOBE_PROBAV_V1.0.1.nc')
WB<-water_bodies  #rinonimo lo strato
WB  #coordinate geografiche, datum WGS84

#siccome abbiamo un singolo strato possiamo decidere quali colori usare
cl<-colorRampPalette(c('lightblue','green','purple','red'))
plot(WB,col=cl)

#diminuiamo la risoluzione dell'immagine, ricampionando il dataset con la funzione aggregate
#l'immagine iniziale ha n. pixel. Prendo un pixel più grande ed estraggo la media dei valori di tutti i pixel al suo interno. Quindi riduco il numero di pixel dell'immagine.
#il fattore fact diminuisce lineramente n volte (n=10, diminuisco di 100 valori e li accorpo in un solo pixel)-->linearmente prende n pixel e ne calcola uno. Ricampionamento bilineare
WB_res<-aggregate(WB,fact=100)  #100x100=10000 volte
plot(WB_res,col=lc)

#usiamo l
#la funzione stitch crea automaticamente un report basato su uno script di R
#template tipo misc

#---------------------------------------------------

# 4. Knitr

#R_code_knitr.r
#il pacchetto knitr è all'interno di R e utilizza un codice esterno per creare un reporp
#prende un codice all'esterno, lo importa all'interno di R e qui genera un report che viene salvato nella stessa cartella in cui è presente il codice

setwd('C:/lab')

#install.packages('knitr')
library(knitr)  #o require(knitr), è uguale

#install.packages('tinytex')
library(tinytex)
#tinytex::install_tinytex()
#tinytex::tlmgr_update()

stitch('R_code_greenland.r',template=system.file('misc','knitr-template.Rnw',package='knitr'))  

#---------------------------------------------------

# 5. Classification

#R_code_classification.r

library(raster)
library(RStoolbox)
setwd('C:/lab/')

#carichiamo l'immagine ESA che ha 3 layer con la funzione brick. Prende i 3 livelli e li unisce
so<-brick('Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg')
so

#visualize RGB level
plotRGB(so,1,2,3,stretch='lin') #plotta l'immagine con i colori RGB. Si vedono i 3 livelli: livello energetico molto alto di colore chiaro,
#livello energetico basso di colore scuro e livello energetico intermedio con colori intermedi

#Unsupervised Classification: classificare l'immagine con la funzione unsuperClass all'interno del pacchetto RStoolbox.
#Unsupervised Classification, è il software che costruise il training set
#Capisce come i pixel si comportano in uno spazio multispettrale, creando alcune classi utilizzando dei pixel già conosciuti come campione (training set).
#Dopo aver definito quante classi vogliamo il comando classifica tutti gli altri pixel dell'immagine in funzione del training set che si è creato.
#L'assegnazione dei pixel ad una classe avviene grazie alla distanza tra pixel nello spazio spettrale.  Maximum likehood
#Viene costruito un grafico a 3 assi: blu, verde e rosso.
#Su ogni asse si mettono i valori di riflettanza del pixel in ogni colore e si incrociano questi valori per identificare il pixel nel grafico
soc<-unsuperClass(so,nClasses=3) #immagine, numero di classi in cui vogliamo raggruppare i pixel
plot(soc$map)  #plot dell'immagine classificata e della mappa
#funzione per fare in modo che l'immagine sia sempre uguale, utilizzando lo stesso training set
set.seed(42)

#Unsupervised Classification with 20 classes: aumentare il numero delle classi. Questa classificazione è basata sui valori della riflettanza
soct<-unsuperClass(so,nClasses=20)
plot(soct$map)
cl<-colorRampPalette(c('yellow','red','brown'))(100)
plot(soct$map,col=cl)

#Scaricare un'immagine da:
#https://www.esa.int/ESA_Multimedia/Missions/Solar_Orbiter/(result_type)/images
sun<-brick('Sun_s_corona.png')
plot(sun)
#Unsupervised Classification con 3 classi di sun
sunc<-unsuperClass(sun,nClasses=3)
plot(sunc$map)

#le immagini possono avere dei rumori che interferiscono con la classificazione, ad esempio ombre, nuvole
#per lavorare con le nuvole in un'immagine ci sono 3 sistemi:
#1: in alcuni dati ci sono delgi strati 'mask' che contengono le nuvole e le ombre e si fa una sottrazione del raster
#2: si inserisce nella classificazione e si dichiara che erano nuvole
#3: si usa un altro tipo di sensore, quello attivo, come i segnali radar, che attraversano le nuvole e quindi non vengono visualizzate

#Visualizzare immagine Grand Canyon
#https://landsat.visibleearth.nasa.gov/view.php?id=80948

library(raster)
library(RStoolbox)
setwd('C:/lab/')

#importo l'immagine
gc<-brick('dolansprings_oli_2013088_canyon_lrg.jpg')

#visualizzo l'immagine in RGB a colori visibili
plotRGB(gc,r=1,g=2,b=3,stretch='lin')
plotRGB(gc,r=1,g=2,b=3,stretch='hist') #effetto maggiore

#Unsupervised Classification basata sul maximum likehood
gcc2<-unsuperClass(gc,nClasses=2)
gcc2
plot(gcc2$map) #in uscita da il numero di classi e la mappa, quindi per visualizzare la mappa dobbiamo inserire il dollaro nel comando
#la zona centrale può essere un tipo di roccia caratteristico. Ha un valore di riflettanzamaggiore a cui è stato associato il valore 1 

#classificazione con 4 classi
gcc4<-unsuperClass(gc,nClasses=4)
plot(gcc4$map)  #per capire la differenziazione nella classi e assegnare delle informazioni bisognerebbe andare a terra

#se usassimo anche la banda dell'infrarosso verrebbe visualizzata anche l'acqua

#---------------------------------------------------

# 6. Multivariate Analysis

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

#plottiamo la banda del blu contro quella del verde per vedere la correlazione. Dalle informazioni precedenti la banda del blu è la B1_sre, la banda del verde la B2_sre
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
#prima informazione: call. Funzione usata
#model
#mappa: rasterbrick con risoluzione uguale a quella originale, 7 bande

#plotRGB delle 3 componenti principali della mappa risultante dalla PCA. E' l'analisi risultante dalle componenti principali
plotRGB(p224r63_2011res_pca$map,r=1,g=2,b=3,stretch='lin')  #colori legati alle 3 componenti, non danno molto informazioni

#plottare la prima componente contro la seconda per vedere se c'è correlazione
plotRGB(p224r63_2011res_pca$map$PC1,p224r63_2011res_pca$map$PC2)  #non sono correlate tra loro (come deve essere)

str(p224r63_2011res_pca) #da informazioni complete sul file

#Analisi PCA: genera delle nuove componenti che diminuiscono la correlazione iniziale e, con un numero minore di componenti, possiamo spiegare tutta l'immagine togliendo la correlazione.
#E' importante fare la PCA per ridurre la correlazione tra le variabili quando, per esempio, si fa un'analisi con variabili molto correlate tra di loro a cui non è consigliato applicare un modello lineare.
#In generale si applica l'analisi delle componenti principali se si ha un set di dati con molte variabili 

#---------------------------------------------------

# 7. ggplot2 

library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)

setwd("~/lab/")

p224r63 <- brick("p224r63_2011_masked.grd")

ggRGB(p224r63,3,2,1, stretch="lin")
ggRGB(p224r63,4,3,2, stretch="lin")

p1 <- ggRGB(p224r63,3,2,1, stretch="lin")
p2 <- ggRGB(p224r63,4,3,2, stretch="lin")

grid.arrange(p1, p2, nrow = 2) # this needs gridExtra

#---------------------------------------------------

# 8. Vegetation Indices

#R_code_vegetation_indices.r

library(raster) #require(raster)

setwd('C:/lab/')

#carico le immagini
defor1<-brick('defor1.jpg')
defor2<-brick('defor2.jpg')

#plotRGB. La B1 è dell'infrarosso, la B2 del rosso e la B3 del verde
par(mfrow=c(2,1))
plotRGB(defor1,r=1,g=2,b=3,stretch='lin') #sul rosso la banda NIR, sul verde la banda del rosso e sul blu la banda del verde 
plotRGB(defor2,r=1,g=2,b=3,stretch='lin')
#più l'acqua è scura più è pura perchè assorbe l'infrarosso, più è chiara più solidi ci sono al suo interno
#la parte chiara è suolo nudo, agricolo. La parte rossa è la foresta

#calcolo dell'indice di vegetazione DVI di defor1: NIR-RED. Devo prima vedere qual è il nome delle bande, richiamando l'immagine
defor1
# names      : defor1.1, defor1.2, defor1.3 
# values :        0,        0,        0 
# max values :      255,      255,      255
# NIR=defor1.1, RED=defor1.2

dvi1<-defor1$defor1.1-defor1$defor1.2 #per ogni pixel prendiamo la riflettanza del NIR e lo sottraiamo alla riflettanza del RED
#Quindi in uscita abbiamo una mappa che è la differenza dei due valori di riflettanza, ovvero la mappa del DVI
plot(dvi1)  #la parte delle zone agricole è molto chiara, con colori tendenti al giallino; la parte del fiume ha colore arancione, mentre la parte della foresta amazzonica è verde

#nuova palette per il DVI
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi1,col=cl,main='DVI at time 1') #main inserisce il titolo alla mappa. Il colore rosso scuro è vegetazione, il fiume è giallo

#DVI di defor2. Prima cerco il nome delle bande
defor2
# names      : defor2.1, defor2.2, defor2.3 
# min values :        0,        0,        0 
# max values :      255,      255,      255

dvi2<-defor2$defor2.1-defor2$defor2.2
plot(dvi2,col=cl,main='DVI at time 2')  #la parte gialla indica suolo nudo

#confrontiamo le 2 immagini di DVI
par(mfrow=c(2,1))
plot(dvi1,col=cl,main='DVI at time 1')
plot(dvi2,col=cl,main='DVI at time 2')

#Se in una zona la foresta è andata distrutta nella seconda mappa dovrei avere un DVI inferiore. Calcolando DVI1-DVI2 ottengo un valore di DVI nella mappa

#per ogni pixel calcolo la differenza di dvi1-dvi2 e ottengo la mappa delle differenze nel dvi
difdvi<-dvi1-dvi2
#visualizzo la mappa della differenza nel dvi
cld<-colorRampPalette(c('blue','white','red'))(100)
plot(difdvi,col=cld)  #il colore rosso indica valori di differenza maggiori; dove la differenza è più bassa il colore è bianco e azzurro.
#indica dove c'è stata una sofferenza molto alta da parte della vegetazione

#NDVI viene utilizzato per paragonare immagini con risoluzione radiometrica diversa. E' la normalizzazione del DVI. -1<NDVI<+1
#NDVI=(NIR-RED)/(NIR+RED)

#calcolo l'NDVI della prima immagine
ndvi1<-(defor1$defor1.1-defor1$defor1.2)/(defor1$defor1.1+defor1$defor1.2)  #uguale a scrivere dvi1/(defor1$defor1.1+defor1$defor1.2)
plot(ndvi1,col=cl)  #il range dei valori è tra -1 e +1. 

#calcolo l'NDVI della seconda immagine
ndvi2<-(defor2$defor2.1-defor2$defor2.2)/(defor2$defor2.1+defor2$defor2.2)  #uguale a scrivere dvi2/(defor2$defor2.1+defor2$defor2.2)
plot(ndvi2,col=cl)

#differenza nell'NDVI e visualizzazione della mappa
difndvi<-ndvi1-ndvi2
plot(difndvi,col=cld) #il rosso indica le zone con maggiore perdita di vegetazione

#nel pacchetto RStoolbox c'è la funzione spectralIndices che calcola indici come NDVI, SAVI, ecc...
library(RStoolbox)  #per calcolare gli indici di vegetazione

#spectralIndices di defor1
vi1<-spectralIndices(defor1,green=3,red=2,nir=1) #il numero delle bande si vede dalle informazioni di defor1
plot(vi1,col=cl) #visualizza 15 indici di vario tipo, per esempio di vegetazione e il NDWI che è un indice dell'acqua

#spectralIndices di defor2
vi2<-spectralIndices(defor2,green=3,red=2,nir=1)
plot(vi2,col=cl)

#NDVI mondiale. Dati dal 1999 al 2017
install.packages('rasterdiv') #per NDVI mondiale
library(rasterdiv)
library(rasterVis)

plot(copNDVI) #l'acqua sono dei valori che non ci servono per l'NDVI
copNDVI<-reclassify(copNDVI,cbind(253:255,NA))  ##reclassify è una funzione per eliminare l'acqua. i pixel con i valori da 253 a 255 possono essere trasformati in non-valori
plot(copNDVI) #visualizza NDVI a scala globale senza l'acqua. In Nord Europa e in Nord America l'NDVI è più alto

#serve il pacchetto rasterVis
levelplot(copNDVI)  #dati dal 99 al 2017 valori medi. I valori più alti sono nelle foreste amazzonica, del borneo, centro africa e del Nord America.
#Nel resto i valori sono molti bassi, per i deserti in Africa e in Asia e per la neve ai poli.
#Nella fascia 23°N ci sono i deserti: sono tutti concentrati qui. Questo perchè nelle zone di grandi foreste c'è un'altissima evapotraspirazione.
#Le piante creano una differenza di pressione. L'aria viene scaricata dal vapore acqueo e diventa secca e si riversa a terra nelle zone attigue a quelle delle grandi foreste
#da un'idea dell'estensione della biomassa nel pianeta

#---------------------------------------------------

# 9. Land Cover

#R_code_land_cover.r

library(raster)
library(RStoolbox)  #pacchetto per la classificazione
install.packages('ggplot2')
library(ggplot2)  #pacchetto per visualizzare le immagini in maniera più bella
install.packages('gridExtra') #permette di usare ggplot per dati raster con la funzione grid.arrange
library(gridExtra)
setwd('C:/lab/')

#immagini defor1 (1992) e defor2 (2006): NIR 1, RED 2, GREEN 3. https://earthobservatory.nasa.gov/images/35891/deforestation-in-mato-grosso-brazil
#defor1
defor1<-brick('defor1.jpg') #carichiamo il dataset con tutte le bande
plotRGB(defor1,r=1,g=2,b=3,stretch='lin')
ggRGB(defor1,r=1,g=2,b=3,stretch='lin')  #immagine, 3 layer e componenti e strecth. Plotta anche le coordinate spaziali sugli assi x e y
#le immagini defor1 e defor2 non hanno un sistema di riferimento, quindi le coordinate nell'immagine non sono reali, sono la conta dei pixel
#questo succede perchè le immagini sono già processate www.earthobservatorynasa.org

#defor2
defor2<-brick('defor2.jpg')
plotRGB(defor2,r=1,g=2,b=3,stretch='lin')
ggRGB(defor2,r=1,g=2,b=3,stretch='lin')

#confronto tra immagini plotRGB
par(mfrow=c(2,1))
plotRGB(defor1,r=1,g=2,b=3,stretch='lin')
plotRGB(defor2,r=1,g=2,b=3,stretch='lin')

#confronto tra immagini ggRGB grazie al pacchetto gridExtra
#grid.arrange plotta le immagini raster
p1<-ggRGB(defor1,r=1,g=2,b=3,stretch='lin')
p2<-ggRGB(defor2,r=1,g=2,b=3,stretch='lin')
grid.arrange(p1,p2,nrow=2)  #immagini disposte su 2 righe

#Unsupervised Classification con 2 classi: l'inizio non viene supervisionato da noi, è il programma che prende in modo random i training sites
d1c<-unsuperClass(defor1,nClasses=2) 
d1c
# unsuperClass results
# 
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 478, 714, 341292  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 714, 0, 478  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 2  (min, max)       #solo due valori possibili
plot(d1c$map)# classe 1=zona agricola, classe 2=foresta 
#set.seed(3) #per ottenere sempre lo stesso risultato dalla classificazione

d2c<-unsuperClass(defor2,nClasses=2)
d2c
plot(d2c$map) #classe 1=zona agricola, classe 2=foresta

#classificazione con 3 classi
d2c3<-unsuperClass(defor2,nClasses=3)
plot(d2c3$map)  #distingue la foresta in una classe e la zona agricola in due classi. classe 1=foresta, agricolo

#quanto è stato perso di foresta
#calcolo della frequenza dei pixel di una certa classe. Quanti pixel di foresta ci sono? Quanti pixel di zona agricola ci sono?
#proporzioni delle 2 classi nell'immagine defor1
freq(d1c$map)
#     value  count
# [1,]     1  34948     #ci sono 34948 pixel nella zona agricola
# [2,]     2 306344     #ci sono 306344 pixel nella foresta

#proporzione (percentuale) dei pixel nelle 2 classi
s1<-34948+306344  
s1   #341292. Questo numero si trova anche in d1c
prop1<-freq(d1c$map)/s1
prop1
#             value     count
# [1,] 2.930042e-06 0.1023991   #10% di agricolo
# [2,] 5.860085e-06 0.8976009   #90% circa di foresta

#proporzioni delle 2 classi nell'immagine defor2
freq(d2c$map)
#      value  count
# [1,]     1 163672     #zona agricola
# [2,]     2 179054     #foresta
s2<-163672+179054  #342726. Questo numero si trova anche in d2c
s2    #342726. Questo numero si trova anche in d2c
prop2<-freq(d2c$map)/s2
prop2
#             value     count
# [1,] 2.917783e-06 0.4775593   #48% agricolo
# [2,] 5.835565e-06 0.5224407   #52% foresta

#generazione di un dataframe (=dataset)
#1 colonna contenente i fattori: variabili categoriche (foresta e agricolo). 1 colonna contenente le percentuali nel 1992 e un'altra con le percentualil del 2006 
#costruisco le colonne che mi interessa avere nel dataframe
cover<-c('Forest','Agriculture')  #colonna cover contenente due righe: Agriculture e Forest. Sono due vettori quindi utilizzo le virgolette e la c  
percent_1992<-c(89.76,10.23) #colonna contenente i valori percentuali di defor1 che ricavo da prop1
percent_2006<-c(52.24,47.75)  #colonna contenente i valori percentuali di defor2 che ricavo da prop2
#creo il dataframe con il comando data.frame
percentages<-data.frame(cover,percent_1992,percent_2006)
#         cover percent_1992 percent_2006
# 1      Forest        89.76        52.24
# 2 Agriculture        10.23        47.75

#ggplot del dataframe (mpg). aes definisce l'estetica: descrive gli assi x e y e color si riferisce in base a quali oggetti vogliamo discriminare 
#al ggplot si aggiunge il comando geom_bar che crea un istogramma. stat='identify' vuol dire che mantiene i dati così come sono, fill è il colore di riempimento degli istogrammi
ggplot(percentages,aes(x=cover,y=percent_1992,color=cover))+geom_bar(stat='identity',fill='white')  #istogramma con le percentuali del 1992
ggplot(percentages,aes(x=cover,y=percent_2006,color=cover))+geom_bar(stat='identity',fill='white')  #istogramma con le percentuali del 2006

p1<-ggplot(percentages,aes(x=cover,y=percent_1992,color=cover))+geom_bar(stat='identity',fill='white')
p2<-ggplot(percentages,aes(x=cover,y=percent_2006,color=cover))+geom_bar(stat='identity',fill='white')

#uniamo i due grafici nella stessa finestra
grid.arrange(p1,p2,nrow=1) #argomenti e numero di righe

#---------------------------------------------------

# 10. Variability

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

#---------------------------------------------------
#---------------------------------------------------
#---------------------------------------------------
