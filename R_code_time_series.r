#Time series analysis
#Greenland increase of temperature
#Data and code from Emanuela Cosma

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
rlist <- list.files(pattern="lst")
rlist

#dare le informazini di tutte le 4 immagini in un unico comando
import <- lapply(rlist,raster)
import

TGr <- stack(import)
plot(TGr)

plotRGB(TGr, 1, 2, 3, stretch="Lin") 
plotRGB(TGr, 2, 3, 4, stretch="Lin") 
plotRGB(TGr, 4, 3, 2, stretch="Lin") 

