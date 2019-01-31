rm(list=ls())

# ------------------------ Libraries ------------------------ 

library(raster)

# ------------------------ Function definition ------------------------ 

differenceNBR <- function(outpath, beforeImage, afterImage){

# ------------------------ Loading Bands ------------------------ 
#BEFORE#
before_R20m_file <- beforeImage

#AFTER#
after_R20m_file  <- afterImage

#Before Bands
Before_NIR  = raster(before_R20m_file,band = 8)
Before_SWIR = raster(before_R20m_file,band = 11)

#After Bands
After_NIR  = raster(after_R20m_file,band = 8)
After_SWIR = raster(after_R20m_file,band = 11)

# ------------------------ Normalized Burn Ratio ------------------------ 

Before_NBR <- (Before_NIR - Before_SWIR) / (Before_NIR + Before_SWIR)

After_NBR <- (After_NIR - After_SWIR) / (After_NIR + After_SWIR)

plot(Before_NBR)
#Compute difference Normalized Burn Ratio from before and after images
dNBR <- Before_NBR - After_NBR

#reclassify with the classes from the paper
outputdNBR <- reclassify(dNBR, c( -Inf  , -0.1, 0   , 
                                  -0.1  ,  0.1, 0   ,
                                  0.1  ,  0.27, 1 ,      #Low severety
                                  0.27,   0.66, 2,        #Mid severety
                                  0.66 ,  Inf , 3   ))      #High severety

# ------------------------ Detect Water ------------------------ #

source("waterDetection.R")
water <- detectWater(beforeImage)

# ------------------------ Delete Water ------------------------ #

source("deleteWater.R")
output <- deleteWater(outputdNBR, water)

# ----------------------- Output ------------------------ #
b <- brick(output)
writeRaster(b,outpath)

cat(outpath)

}

args = commandArgs(trailingOnly=TRUE)

differenceNBR(args[1],args[2],args[3])
