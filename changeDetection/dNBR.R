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

# ------------------------ Loading Bands ------------------------ 

setwd("D:/Uni/Master/Monitoring")

#BEFORE#
beforDir <- "./myanmar_l2a/S2B_MSIL2A_20180916T041539_N0206_R090_T46QDH_20180916T075813.SAFE/R20m/"
Myanmar_before_20m <- list.files(path = beforDir, pattern = ".jp2")
Myanmar_before_20m <- lapply(paste0(beforDir, Myanmar_before_20m), raster)

#AFTER#
#BEFORE#
afterDir <- "./myanmar_l2a/S2B_MSIL2A_20181026T041839_N0206_R090_T46QDH_20181026T080327.SAFE/R20m/"
Myanmar_after_20m <- list.files(path = afterDir, pattern = ".jp2")
Myanmar_after_20m <- lapply(paste0(afterDir, Myanmar_after_20m), raster)

afterDirR10m <- "./myanmar_l2a/S2B_MSIL2A_20181026T041839_N0206_R090_T46QDH_20181026T080327.SAFE/R20m/"
Myanmar_after_10m <- list.files(path = afterDirR10m, pattern = ".jp2")
Myanmar_after_10m <- lapply(paste0(afterDirR10m, Myanmar_after_10m), raster)

#VILLAGES#
villages <- geojson_read("myanmar_osm_villages.geojson", what = "sp")

#Before Bands
Before_TCI<- Myanmar_before_20m[[12]]
Before_NIR<- Myanmar_before_20m[[10]]
Before_SWIR<- Myanmar_before_20m[[9]]

#After Bands
After_TCI<- Myanmar_after_20m[[12]]
After_NIR<- Myanmar_after_20m[[10]]
After_SWIR<-Myanmar_after_20m[[9]]


# ------------------------ Normalized Burn Ratio ------------------------ 

Before_NBR <- (Before_NIR - Before_SWIR) / (Before_NIR + Before_SWIR)

After_NBR <- (After_NIR - After_SWIR) / (After_NIR + After_SWIR)

#Compute difference Normalized Burn Ratio from before and after images
dNBR <- Before_NBR - After_NBR

#reclassify with the classes from the paper
Burn_Ratio <- reclassify(dNBR, c( -Inf  , -0.1, -2   , 
                                  -0.1  ,  0.1,  -1   ,
                                  0.1  ,  0.27, 0 ,
                                  0.27,   0.66, 0.75,
                                  0.66 ,  Inf , 1.5   ))

test <- Burn_Ratio
test[test < 0.75 ] <- NA
test[test > 1.5 ] <- NA

# ------------------------ Filter for Villages only in Burned Areas ------------------------ 

# Convert raster to  SpatialPointsDataFrame
spts <- rasterToPoints(test, spatial = TRUE)

llprj <-  "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"
llpts <- spTransform(spts, CRS(llprj))

#All Pixel where area is burned
pixel_coord_Val <- as.data.frame(llpts)

#Coordinates of the Villages
vil_coords <- coordinates(villages)

#temporal <- coordinates(villages)


temp_villages <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("longitude", "latitude")
colnames(temp_villages) <- x


#select only villages in the AOI
for(row in 1:nrow(vil_coords)){
  vil_lon <- vil_coords[[row,"coords.x1"]]
  vil_lat <- vil_coords[[row, "coords.x2"]]

  if(!is.na(vil_lat)){
    if(vil_lat < 20.77000){
      
      newRow <- data.frame(longitude= vil_lon,latitude = vil_lat)
      
      temp_villages <- rbind(temp_villages,newRow)
    }
  }
}

temp2_villages <- data.frame(matrix(ncol = 2, nrow = 0))
x <- c("longitude", "latitude")
colnames(temp2_villages) <- x



R <- 6371000

#select only villages that lay in a affected area
for(row in 1:nrow(temp_villages)){
  vil_lon <- temp_villages[[row,"longitude"]]
  vil_lat <- temp_villages[[row, "latitude"]]
  
  for(r in 1:nrow(pixel_coord_Val)){
    pix_lon <- pixel_coord_Val[[r,"x"]]
    pix_lat <- pixel_coord_Val[[r, "y"]]
    
    
    
    
    d1 <- NISTdegTOradian(pix_lat - vil_lat)
    d2 <- NISTdegTOradian(pix_lon - vil_lon)
    
    a <- sin(d1/2) * sin(d1/2) + cos(NISTdegTOradian(vil_lat)) * cos(NISTdegTOradian(pix_lat)) * sin(d2/2) * sin(d2/2)
    
    c <- 2* atan2(sqrt(a),sqrt(1-a))
    
    d <- R*c
    
    temp = d
    
    
    
    if(d <= 500){
      newRow <- data.frame(longitude= vil_lon,latitude = vil_lat)
      
      temp2_villages <- rbind(temp2_villages,newRow)
      row <- row+1
      break
    }
      
  }
}





#t <- SpatialPoints(vil_coords, proj4string=CRS(as.character(NA)), bbox = NULL)
burned_area_villages <- SpatialPoints(temp2_villages, proj4string=CRS(as.character(NA)), bbox = NULL)
villages_in_aoi <- SpatialPoints(temp_villages, proj4string=CRS(as.character(NA)), bbox = NULL)



#subset(villages, villages@coords[, "coords.x2"] < 20.15000)




# ------------------------ Visualisation ------------------------ 



# TCI Image
r<- Myanmar_before_10m[[4]]
g<- Myanmar_before_10m[[3]]
b<- Myanmar_before_10m[[2]]

RGB_stack <- stack(r,g,b)
#plotRGB(stacki,r=3,g=2,b=1,stretch="lin")


#color definition
colorsOLD <- c("#21610B", "#40FF00", "#F3F781", "#FF8000","#FF0000")

colors <- c("#21610B","#40FF00","#F3F781","#FF8000", "#FF0000")

#Plots the difference NBR
#plot(Burn_Ratio,col = colorsOLD, main="Difference Normalized Burn Ratio")
#plot(dNBR, breaks = c(-2,-0.1,0.1,0.27,0.66,2),col = colorsOLD,main="Difference Normalized Burn Ratio")


#Histogramm to show distribution of the values
#hist(Burn_Ratio,
#     breaks = c(-2,-0.1,0.1,0.27,0.66,2),
#     main = "Difference Normalized Burn Ratio",
#     xlab = "Strength (m)", ylab = "Number of Pixels",
#     col = colors)


#Mapview options
mapviewOptions(basemaps = c("OpenStreetMap.DE"),
               raster.palette = colors,
               na.color ="transparent",
               layers.control.pos = "topright")


#Mapview of difference Normalized Burn Ratio and Villages
#mapview(Burn_Ratio, col.regions = colors, at = seq(-2, 2, 0.75)) + mapview(burned_area_villages) + mapview(villages_in_aoi)

viewRGB(RGB_stack) + mapview(test,alpha="0.5" ,col.regions = colors, at = seq(-2, 2, 0.75)) + mapview(burned_area_villages) + mapview(villages_in_aoi)


