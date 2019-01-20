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
detectWater <- function(outpath, Image){
  
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
  
  # Water Pixels (WP)
  Water_Pixel <--   ((Band8A+Band08+Band12)-(Band01+Band02+Band03)) / 
                    ((Band8A+Band11+Band12)+(Band01+Band02+Band03))
  
  # ------------------------ Output ------------------------ #
  
  result <- brick(Water_Pixel)
  writeRaster(result,outpath)
  
  cat(outpath)
  
}

args = commandArgs(trailingOnly=TRUE)

detectWater(args[1],args[2])
  
  
  
  
  
  
  