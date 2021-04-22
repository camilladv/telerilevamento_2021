#R_code_classification.r

library(raster)
setwd('C:/lab/')

#carichiamo l'immagine ESA che ha 3 livelli con la funzione brick. Prende i 3 livelli e li unisce
so<-brick('Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg')
so

#
