library(sen2r)

aoi = sf::st_as_sfc(readLines('aoi/myanmar.wkt'))
timewindow = as.Date("2018-11-15") # one day
#timewindow = as.Date(c("2018-11-05","2018-11-15")) # or interval
max_cloud_coverage = 10 # percentage

l1cDir = paste0(getwd(), '/data/myanmar/l1c')
l2aDir = paste0(getwd(), '/data/myanmar/l2a')
resultDir = paste0(getwd(), '/data/myanmar') # result GeoTIFF will be in subdir ./BOA

######## 0. DISCOVERY

productList = s2_list(
  spatial_extent = aoi,
  time_interval = timewindow,
  level = 'L1C',
  apihub = './scihub.credentials',
  max_cloud = max_cloud_coverage
)

######## 1. DOWNLOAD

s2_download(
  productList,
  outdir = l1cDir,
  downloader = 'aria2',
  apihub = './scihub.credentialsss'
)

######## 2. CORRECTION

l1cNames = names(productList)
l2aList = sen2cor(
  l1cNames,
  l1cDir,
  l2aDir,
  # one instance uses ~7GB RAM, so with 16GB RAM + some swap space we can do 3 at once
  parallel = 3
)

######## 3. MERGE TILES & CLIP 

# first create a virtual raster for each product (all bands combined by reference)
# in $resultDir/BOA
vrtFiles = lapply(l2aList, function(l2a) {
  s2_translate(
    l2a,
    resultDir,
    subdirs = TRUE,
    prod_type = 'BOA',
    res = '10m' # higher resolution bands are upsampled to 10m
  )
})

# merge tiles of same orbit
mergedFiles = s2_merge(
  unlist(vrtFiles),
  resultDir,
  subdirs = TRUE,
  format = 'VRT',
  # parallelization autodetected by number of cores (RAM shouldn't be bottleneck here)
  parallel = TRUE
)

clippedFiles = gsub('.vrt$', '.tif', mergedFiles)
gdal_warp(
  mergedFiles,
  clippedFiles,
  mask = aoi,
  t_srs = 'EPSG:3857',
  of = 'GTiff'
)

######## 4. MASK

# somehow needs files containing the mask? not really clear where to get those..
# cloudmasked = s2_mask(
#   clippedFiles,
#   ????
# )

######## 5. PRESENTATION

s2_thumbnails(clippedFiles, dim = 2048, rgb_type = 'RGB', overwrite = T)
