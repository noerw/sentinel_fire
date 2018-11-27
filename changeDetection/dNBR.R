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


# ------------------------ Loading Bands ------------------------ 

setwd("D:/Uni/Master/Monitoring")

#BEFORE#
beforDir <- "./myanmar_l2a/S2B_MSIL2A_20180916T041539_N0206_R090_T46QDH_20180916T075813.SAFE/R20m/"
Myanmar_before_20m <- list.files(path = beforDir, pattern = ".jp2")
Myanmar_before_20m <- lapply(paste0(beforDir, Myanmar_before_20m), raster)

#AFTER#
#BEFORE#
beforDir <- "./myanmar_l2a/S2B_MSIL2A_20181026T041839_N0206_R090_T46QDH_20181026T080327.SAFE/R20m/"
Myanmar_after_20m <- list.files(path = beforDir, pattern = ".jp2")
Myanmar_after_20m <- lapply(paste0(beforDir, Myanmar_after_20m), raster)

#VILLAGES#
villages <- geojson_read("myanmar_osm_villages.geojson", what = "sp")

#Before Bands
Before_TCI<- Myanmar_before_20m[[12]]
Before_NIR<- Myanmar_before_20m[[10]]
Before_SWIR<- Myanmar_before_20m[[9]]

#After Bands
After_NIR<- Myanmar_after_20m[[10]]
After_SWIR<-Myanmar_after_20m[[9]]


# ------------------------ Normalized Burn Ratio ------------------------ 

Before_NBR <- (Before_NIR - Before_SWIR) / (Before_NIR + Before_SWIR)

After_NBR <- (After_NIR - After_SWIR) / (After_NIR + After_SWIR)

#Compute difference Normalized Burn Ratio from before and after images
dNBR <- Before_NBR - After_NBR

#reclassify with the classes from the paper
classified_dNBR <- reclassify(dNBR, c(-2,-0.1,0.1,0.27,0.66,2))


# ------------------------ Visualisation ------------------------ 

#color definition
colors <- c("#21610B", "#40FF00", "#F3F781", "#FF8000","#FF0000")

#Mapview options
mapviewOptions(basemaps = c("OpenStreetMap.DE"),
               raster.palette = colors,
               na.color = "magenta",
               layers.control.pos = "topright")


#Mapview of difference Normalized Burn Ratio and Villages
mapview(dNBR, col = colors)# + mapview(villages)


#Plots the difference NBR
plot(dNBR,col = colors,breaks = c(-2,-0.1,0.1,0.27,0.66,2), main="Difference Normalized Burn Ratio")

#Histogramm to show distribution of the values
#hist(dNBR,
#     breaks = c(-2,-0.1,0.1,0.27,0.66,2),
#     main = "Difference Normalized Burn Ratio",
#     xlab = "Strength (m)", ylab = "Number of Pixels",
#     col = colors)





