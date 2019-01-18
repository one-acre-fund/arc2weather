#' convert ftp data to matrix and then raster
#'
#' @param binaryInput Binary input from FTP site
#' @param fileUrl web url with location of file
#' @return matrix of values to be converted to raster



convert_bin_to_raster <- function(binaryInput, fileUrl){
  mat <- raster::raster(matrix(binaryInput, nrow = 801, ncol = 751, byrow = TRUE))
  ### match raster
  raster::extent(mat) <- raster::extent(-20.05, 55.05, -40.05, 40.05) ### reference raster
  crs(mat) <- crs(r) ### reference raster
  names(mat) <- basename(fileUrl)
  return(mat)
}
