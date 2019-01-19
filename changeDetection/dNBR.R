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

differenceNBR <- function(outpath, beforeImage, afterImage, threshold=FALSE){

  #check if outpath exists und wenn ja dann nicht alles berechnen
  
# ------------------------ Loading Bands ------------------------ 
#BEFORE#
before_R20m_file <- beforeImage

#AFTER#
after_R20m_file  <- afterImage

#Before Bands
Before_NIR  = raster(before_R20m_file,band = 8)
Before_SWIR = raster(before_R20m_file,band = 1)

#After Bands
After_NIR  = raster(after_R20m_file,band = 8)
After_SWIR = raster(after_R20m_file,band = 1)

# ------------------------ Normalized Burn Ratio ------------------------ 

Before_NBR <- (Before_NIR - Before_SWIR) / (Before_NIR + Before_SWIR)

After_NBR <- (After_NIR - After_SWIR) / (After_NIR + After_SWIR)

#Compute difference Normalized Burn Ratio from before and after images
dNBR <- Before_NBR - After_NBR

#reclassify with the classes from the paper
outputdNBR <- reclassify(dNBR, c( -Inf  , -0.1, -2   , 
                                  -0.1  ,  0.1,  -1   ,
                                  0.1  ,  0.27, 0 ,
                                  0.27,   0.66, 0.75,
                                  0.66 ,  Inf , 1.5   ))
if(threshold == TRUE){
  outputdNBR[outputdNBR < 0.75 ] <- NA
  outputdNBR[outputdNBR > 1.5 ] <- NA
}

# ------------------------ Output ------------------------ #
b <- brick(outputdNBR)
writeRaster(b,outpath)

cat(outpath)

}

args = commandArgs(trailingOnly=TRUE)

differenceNBR(args[1],args[2],args[3],args[4])
