rm(list=ls())


# ------------------------ Libraries ------------------------ 

library(rgdal)
if (!require(geojsonio)) {
  install.packages("geojsonio")
  library(geojsonio)
}
library(sp)
library(raster)
library(maps)
library(ggmap)
library(maptools)
library(mapview)
library(RColorBrewer)
library(NISTunits)
library(raster)

# ------------------------ Function definition ------------------------ 
BAIS2 <- function(outpath, Image){

# ------------------------ Loading Bands ------------------------ 
##
R20m_file <- Image

# Bands
Band01  = raster(R20m_file,band = 1)
Band02  = raster(R20m_file,band = 2)
Band03  = raster(R20m_file,band = 3)
Band04  = raster(R20m_file,band = 4)
Band05  = raster(R20m_file,band = 5)
Band06  = raster(R20m_file,band = 6)
Band07  = raster(R20m_file,band = 7)
Band08  = raster(R20m_file,band = 8)
Band8A  = raster(R20m_file,band = 9)#10
Band11  = raster(R20m_file,band = 8)
Band12  = raster(R20m_file,band = 9)

#Burned Area Index for Sentinel-2 (BAIS2)
BAIS2 <- (1- sqrt((Band06*Band07*Band8A)/Band04) * 
         ( (Band12-Band8A) / (sqrt(Band12+Band8A) ) +1) )


#------------------------ Reclassification ------------------------ 
#find out the breaks
limits <- summary(BAIS2)

#reclassify the result
BAIS2 <- reclassify(BAIS2, c( limits[1] , limits[2], -1  , 
                              limits[2] , limits[3], -0.6,
                              limits[3] , limits[4],  0  ,
                              limits[4] , limits[5],  0.75))

# ------------------------ Output ------------------------ #

result <- brick(BAIS2)
writeRaster(result,outpath)

cat(outpath)

}

args = commandArgs(trailingOnly=TRUE)

BAIS2(args[1],args[2])
