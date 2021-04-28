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

#le immagini possono avere dei rumori he interferiscono con la classificazione, ad esempio ombre, nuvole
#per lavorare con le nuvole in un'immagine ci sono 3 sistemi:
#1: in alcuni dati ci sono delgi strati 'mask' che contengono le nuvole e le ombre e si fa una sottrazione del raster
#2: si inserisce nella classificazione e si dichiara e che erano nuvole
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
