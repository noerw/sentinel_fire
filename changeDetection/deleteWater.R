#rm(list=ls())


# ------------------------ Libraries ------------------------ 

library(raster)

# ------------------------ Function definition ------------------------ 
deleteWater <- function(Image,water){
  
  # ------------------------ Loading Bands ------------------------ 
  ##
  burnedArea <- Image
  water <- water
  
  
  # Bands
  water <- reclassify(water, c( -Inf  , 0, 0,
                                0 ,  Inf , 1 ))

  output <- burnedArea
  output[water == 1] <- NA
  
  # ------------------------ Output ------------------------ #
  return(output)
}

