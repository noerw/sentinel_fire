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
BAIS2 <- function(outpath, beforeImage, afterImage){

# ------------------------ Loading Bands ------------------------ 
#BEFORE#
before_R20m_file <- beforeImage

#AFTER#
after_R20m_file  <- afterImage

#Before Bands
Before_Band01  = raster(before_R20m_file,band = 1)
Before_Band02  = raster(before_R20m_file,band = 2)
Before_Band03  = raster(before_R20m_file,band = 3)
Before_Band04  = raster(before_R20m_file,band = 4)
Before_Band05  = raster(before_R20m_file,band = 5)
Before_Band06  = raster(before_R20m_file,band = 6)
Before_Band07  = raster(before_R20m_file,band = 7)
Before_Band08  = raster(before_R20m_file,band = 8)
Before_Band8A  = raster(before_R20m_file,band = 9)#10
Before_Band11  = raster(before_R20m_file,band = 8)
Before_Band12  = raster(before_R20m_file,band = 9)

#After Bands
After_Band01  = raster(after_R20m_file,band = 1)
After_Band02  = raster(after_R20m_file,band = 2)
After_Band03  = raster(after_R20m_file,band = 3)
After_Band04  = raster(after_R20m_file,band = 4)
After_Band05  = raster(after_R20m_file,band = 5)
After_Band06  = raster(after_R20m_file,band = 6)
After_Band07  = raster(after_R20m_file,band = 7)
After_Band08  = raster(after_R20m_file,band = 8)
After_Band8A  = raster(after_R20m_file,band = 9) #10
After_Band11  = raster(after_R20m_file,band = 8)
After_Band12  = raster(after_R20m_file,band = 9)


# ------------------------ Before Fire ------------------------ 

#Before Water Pixels (Before_WP)
Before_WP <--   ((Before_Band8A+Before_Band08+Before_Band12)-(Before_Band01+Before_Band02+Before_Band03)) / 
         ((Before_Band8A+Before_Band11+Before_Band12)+(Before_Band01+Before_Band02+Before_Band03))

#Burned Area Index for Sentinel-2 (BAIS2)
Before_BAIS2 <- (1- sqrt((Before_Band06*Before_Band07*Before_Band8A)/Before_Band04) * 
         ( (Before_Band12-Before_Band8A) / (sqrt(Before_Band12+Before_Band8A) ) +1) )

#Water Pixels (After_WP)
After_WP <--   ((After_Band8A+After_Band11+After_Band12)-(After_Band01+After_Band02+After_Band03)) / 
               ((After_Band8A+After_Band11+After_Band12)+(After_Band01+After_Band02+After_Band03))

#Burned Area Index for Sentinel-2 (BAIS2)
After_BAIS2 <- (1- sqrt((After_Band06*After_Band07*After_Band8A)/After_Band04) * 
               ( (After_Band12-After_Band8A) / (sqrt(After_Band12+After_Band8A) ) +1) ) / 2



#------------------------ Reclassification ------------------------ 
#find out the breaks
Before_limits <- summary(Before_BAIS2)

#reclassify the result
Before_BAIS2 <- reclassify(Before_BAIS2, c( Before_limits[1] , Before_limits[2], -1  , 
                                            Before_limits[2] , Before_limits[3], -0.6,
                                            Before_limits[3] , Before_limits[4],  0  ,
                                            Before_limits[4] , Before_limits[5],  0.75))

#find out the breaks
After_limits <- summary(After_BAIS2)

#reclassify the result
After_BAIS2 <- reclassify(After_BAIS2, c( After_limits[1] , After_limits[2], -1  , 
                                          After_limits[2] , After_limits[3], -0.6,
                                          After_limits[3] , After_limits[4],  0  ,
                                          After_limits[4] , After_limits[5],  0.75))

# ------------------------ Output ------------------------ #

before_result <- brick(Before_BAIS2)
writeRaster(before_result,outpath)

cat(outpath)

}

args = commandArgs(trailingOnly=TRUE)

BAIS2(args[1],args[2],args[3])
