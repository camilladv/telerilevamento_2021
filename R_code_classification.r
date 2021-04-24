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

#aumentare il numero delle classi
socv<-unsuperClass(so,nClasses=20)
plot(socv$map)

