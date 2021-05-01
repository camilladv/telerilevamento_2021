#R_code_vegetation_indices.r

library(raster)

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
