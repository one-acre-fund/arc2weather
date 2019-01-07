convert_bin_to_raster <- function(binaryInput, fileUrl){
  mat <- raster(matrix(binaryInput, nrow = 801, ncol = 751, byrow = TRUE))
  ### match raster
  extent(mat) = extent(r) ### reference raster
  crs(mat) = crs(r) ### reference raster
  names(mat) = basename(fileUrl)
  return(mat)
}
