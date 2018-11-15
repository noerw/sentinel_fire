require(sen2r)

#' Crops all .jp2 files of a Sentinel product to the given AoI
#' using GDAL, and places them in the outDir.
#' 
#' @param productDir character string to directory of the product.
#' @param outDir character string to the intended output directory. should not be inside productDir!
#' @param aoi area of interest geometry (st_sfc)
#' @param format gdal format string specifying the output format.
#' @return list of generated files
cropSenProduct = function (productDir, outDir, aoi, format = 'GTiff') {
  # get the IMG_DATA directory
  imgPath = Filter(function(x) grepl('IMG_DATA', x), list.dirs(productDir, recursive=T))[1]
  
  # all jp2 files in ./GRANULE/*/IMG_DATA/ are to be cropped
  inFiles = list.files(imgPath, full.names = T, recursive = T, pattern = '*.jp2$')
  outFiles = gsub(imgPath, outDir, inFiles)
  
  # create dirs for each resolution subdir
  resolutionDirs = list.dirs(imgPath)
  outDirs = gsub(imgPath, outDir, resolutionDirs)
  lapply(outDirs, function (x) dir.create(x, recursive = TRUE))
  
  sen2r::gdal_warp(inFiles, outFiles, mask = aoi, of = format)
  
  outFiles
}
