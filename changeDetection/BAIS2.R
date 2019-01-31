rm(list=ls())


# ------------------------ Libraries ------------------------ 

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
Band09  = raster(R20m_file,band = 9)
Band11  = raster(R20m_file,band = 10)
Band12  = raster(R20m_file,band = 11)
Band8A  = raster(R20m_file,band = 12)

a <- Band06 
b <- Band07
c <- Band8A

d <- Band04

BAIS2P1 <- ( 1 - sqrt( ((a*b)/d)*c))
           
BAIS2P2 <- ( ( (Band12-Band8A) / (sqrt(Band12+Band8A) )  ) + 1 ) 

BAIS2 <- BAIS2P1 * BAIS2P2
#------------------------ Reclassification ------------------------ 
#find out the breaks
limits <- summary(BAIS2)


#reclassify the result
BAIS2 <- reclassify(BAIS2, c(      -Inf , limits[2], 0  , 
                              limits[2] , limits[3], 1  ,
                              limits[3] , limits[4], 2  ,
                              limits[4] ,       Inf, 3   ))


# ------------------------ Detect Water ------------------------ #

source("waterDetection.R")
water <- detectWater(Image)

# ------------------------ Delete Water ------------------------ #

source("deleteWater.R")
output <- deleteWater(BAIS2, water)

# ------------------------ Output ------------------------ #

#result <- brick(output)
writeRaster(output,outpath)

cat(outpath)

}

args = commandArgs(trailingOnly=TRUE)

BAIS2(args[1],args[2])
