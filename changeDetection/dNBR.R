library(rgdal)
library(sp)
library(raster)


#here your direction
setwd("D:/Uni/Master/Monitoring")


Before_NIR <- readGDAL('./myanmar_l2a/S2B_MSIL2A_20180916T041539_N0206_R090_T46QDH_20180916T075813.SAFE/R20m/T46QDH_20180916T041539_B8A_20m.jp2')
Before_SWIR <- readGDAL('./myanmar_l2a/S2B_MSIL2A_20180916T041539_N0206_R090_T46QDH_20180916T075813.SAFE/R20m/T46QDH_20180916T041539_B12_20m.jp2')

TCI <- stack('./myanmar_l2a/S2B_MSIL2A_20180916T041539_N0206_R090_T46QDH_20180916T075813.SAFE/R10m/T46QDH_20180916T041539_TCI_10m.jp2')


plotRGB(TCI)


After_NIR <- readGDAL('./myanmar_l2a/S2B_MSIL2A_20181026T041839_N0206_R090_T46QDH_20181026T080327.SAFE/R20m/T46QDH_20181026T041839_B8A_20m.jp2')
After_SWIR <- readGDAL('./myanmar_l2a/S2B_MSIL2A_20181026T041839_N0206_R090_T46QDH_20181026T080327.SAFE/R20m/T46QDH_20181026T041839_B12_20m.jp2')




#Before_NIR <- readGDAL('D:/Uni/Master/Monitoring/Meppen/meppen_l2a/meppen_moorbrand_cropped/S2A_MSIL2A_20180806T104021_N0208_R008_T32ULD_20180806T142805.SAFE/R20m/T32ULD_20180806T104021_B8A_20m.jp2')
#Before_SWIR <- readGDAL('D:/Uni/Master/Monitoring/Meppen/meppen_l2a/meppen_moorbrand_cropped/S2A_MSIL2A_20180806T104021_N0208_R008_T32ULD_20180806T142805.SAFE/R20m/T32ULD_20180806T104021_B12_20m.jp2')


#After_NIR <- readGDAL('D:/Uni/Master/Monitoring/Meppen/meppen_l2a/meppen_moorbrand_cropped/S2B_MSIL2A_20180930T104019_N0208_R008_T32ULD_20180930T165224.SAFE/R20m/T32ULD_20180930T104019_B8A_20m.jp2')
#After_SWIR <- readGDAL('D:/Uni/Master/Monitoring/Meppen/meppen_l2a/meppen_moorbrand_cropped/S2B_MSIL2A_20180930T104019_N0208_R008_T32ULD_20180930T165224.SAFE/R20m/T32ULD_20180930T104019_B12_20m.jp2')


Before_NIR<- raster(Before_NIR)
Before_SWIR<- raster(Before_SWIR)

After_NIR<- raster(After_NIR)
After_SWIR<- raster(After_SWIR)



Before_NBR <- (Before_NIR - Before_SWIR) / (Before_NIR + Before_SWIR)

After_NBR <- (After_NIR - After_SWIR) / (After_NIR + After_SWIR)

plot(After_NBR)


dNBR <- Before_NBR - After_NBR


colors <- c("#21610B", "#40FF00", "#F3F781", "#FF8000","#FF0000")


hist(dNBR,
     breaks = c(-2,-0.1,0.1,0.27,0.66,2),
     main = "Distribution of raster cell values in the DTM difference data",
     xlab = "Height (m)", ylab = "Number of Pixels",
     col = colors)

plot(dNBR,col = colors, breaks = c(-2,-0.1,0.1,0.27,0.66,2),main="Difference Normalized Burn Ratio")
