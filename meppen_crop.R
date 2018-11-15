source('1aquisition/crop.R') # provides cropSenProduct()

require(sf)
meppen = sf::st_as_sfc(readLines('aoi/meppen.wkt'))

inDir = './data/meppen_l2a'
outDir = './data/meppen_l2a_cropped'
products = list.dirs(inDir, recursive = F)
lapply(products, function (productPath) {
  outPath = paste(outDir, basename(productPath), sep = '/')
  cropSenProduct(productPath, outPath, aoi = meppen)
})
