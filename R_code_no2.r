#R_code_no2.r

#install.packages('raster')
library(raster)
library(RStoolbox)  #here used for raster based multivariate analysis (PCA)
        
# 1. Set the working directory EN
setwd('C:/lab/EN')

# 2. Importare il primo set EN_0001.PNG (prima banda): brick (carica tutti i livelli di bande) o raster (carica un solo livello)
#we will selct band 1, but the raster function enables to seletc other sing
en01<-raster('EN_0001.png')

# 3. Plot the first image with your preferred Color Ramp Palette
cl<-colorRampPalette(c('green','purple','yellow'))(100)
plot(en01,col=cl)  #il giallo individua le zone di gennaio con NO2 più alto

# 4. Import the last image (13th) and plot it with the previous
en13<-raster('EN_0013.png')
plot(en13,col=cl) #mappa di marzo

# 5. Make the difference between the two images and plot it
#marzo-febbraio
endif<-en13-en01 #se ho un valore più basso nell'immagine 13 e uno più alto nell'immagine d01 il valore della differenza sarà negativo
plot(endif, col=cl)
#oppure gennaio-marzo
en_dif<-en01-en13
plot(en_dif,col=cl)

# 6. Plot everything, altogether
par(mfrow=c(3,1))
plot(en01,col=cl, main='NO2 in January')
plot(en13,col=cl, main='NO2 in March')
plot(en_dif, col=cl, main='Difference(January-March)')

# 7. Import the whole set (13 immagini)
#list of files
rlist<-list.files(pattern='EN')
rlist

import<-lapply(rlist,raster)  #importa i singoli file come raster
import

EN<-stack(import) #compatta i 13 file
plot(EN,col=cl)

# 8. Replicate the plot of 1 and 13 using the stack
EN  #cerco il nome delle immagini che mi interessano
par(mfrow=c(2,1))
plot(EN$EN_0001, col=cl)
plot(EN$EN_0013, col=cl)

# 9. Compute a PCA over the 13 images
ENpca<-rasterPCA(EN)
summary(ENpca$model)
plotRGB(ENpca$map,r=1,g=2,b=3,stretch='lin')  #gran parte dell'informazione è nella componente red

# 10. Compute the local variability (local standard deviation) of the first component
#calcolare la deviazione standard della prima componente
PC1sd<-focal(ENpca$map$PC1, w=matrix(1/9,nrow=3,ncol=3),fun=sd)
plot(PC1sd,col=cl)

