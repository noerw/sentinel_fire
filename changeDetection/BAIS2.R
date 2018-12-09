rm(list=ls())


# ------------------------ Libraries ------------------------ 
library(sp)
library(raster)

#here your direction
#here your direction
setwd("D:/Uni/Master/Monitoring")


# ------------------------ Before Fire ------------------------ 

beforDir <- "./myanmar_l2a/S2B_MSIL2A_20180916T041539_N0206_R090_T46QDH_20180916T075813.SAFE/R20m/"
Myanmar_before_20m <- list.files(path = beforDir, pattern = ".jp2")
Myanmar_before_20m <- lapply(paste0(beforDir, Myanmar_before_20m), raster)


# add different bands 
B01 <- Myanmar_before_20m[[1]]
B02 <- Myanmar_before_20m[[2]]
B03 <- Myanmar_before_20m[[3]]
B04 <- Myanmar_before_20m[[4]]
B06 <- Myanmar_before_20m[[6]]
B07 <- Myanmar_before_20m[[7]]
B8A <- Myanmar_before_20m[[10]]
B11 <- Myanmar_before_20m[[8]]
B12 <- Myanmar_before_20m[[9]]


#Water Pixels (WP)
WP <--   ((B8A+B11+B12)-(B01+B02+B03)) / ((B8A+B11+B12)+(B01+B02+B03))
plot(WP)
title(main = "WP")

#file:///Users/albert/Downloads/proceedings-02-00364-v3.pdf
#Burned Area Index for Sentinel-2 (BAIS2)
BAIS2 <- (1- sqrt((B06*B07*B8A)/B04) * ( (B12-B8A) / (sqrt(B12+B8A) ) +1) )

plot(BAIS2)
title(main = "BAIS2")



# ------------------------ After Fire ------------------------ 
beforDir <- "./myanmar_l2a/S2B_MSIL2A_20181026T041839_N0206_R090_T46QDH_20181026T080327.SAFE/R20m/"
Myanmar_after_20m <- list.files(path = beforDir, pattern = ".jp2")
Myanmar_after_20m <- lapply(paste0(beforDir, Myanmar_after_20m), raster)



# add different bands
AB01 <- Myanmar_before_20m[[1]]
AB02 <- Myanmar_before_20m[[2]]
AB03 <- Myanmar_before_20m[[3]]
AB04 <- Myanmar_before_20m[[4]]
AB06 <- Myanmar_before_20m[[6]]
AB07 <- Myanmar_before_20m[[7]]
AB8A <- Myanmar_before_20m[[10]]
AB11 <- Myanmar_before_20m[[8]]
AB12 <- Myanmar_before_20m[[9]]

#Water Pixels (WP)
AWP <--   ((AB8A+AB11+AB12)-(AB01+AB02+AB03)) / ((AB8A+AB11+AB12)+(AB01+AB02+AB03))
plot(AWP)
title(main = "AWP")


#Burned Area Index for Sentinel-2 (BAIS2)
ABAIS2 <- (1- sqrt((AB06*AB07*AB8A)/AB04) * ( (AB12-AB8A) / (sqrt(AB12+AB8A) ) +1) ) / 2



#------------------------ Visualisation ------------------------ 
#set colors
colors <- c("red", "#40FF00", "#F3F781")

#find out the breaks
summary(ABAIS2)


plot(ABAIS2,col=colors, breaks = c(-13979.48526, -15.76164, 665601.58220),main="Burned Area Index for Sentinel-2")

plot(ABAIS2)
title(main = "Burned Area Index for Sentinel-2")
