#' Make sure the velox raster and the GPS spdf have the same CRS
#'
#' @param veloxRasterList A list of raster in velox format.
#' @param spdf A SpatialPointsDataFrame from the sp package.
#' @return An spdf with the same format as the velox raster data.
#' @examples
#' add(1, 1)
#' add(10, 1)

convert_to_velox <- function(rList){
  # input: takes the subset data and convets to velox. Works with list input
  # output: a list of two objects:
  # a list of velox rasters for additional manipulation
  # a df of the labels to associate with the rasters so that I have something to work with when aggregating the data.
  veloxLoop <- list()
  for(i in seq_along(rList)){
    tmp <- velox(rList[[i]])
    #tmp$crop(oafAreaReproject)
    veloxLoop[[i]] <- tmp
  }

  # and create df of the labels from rList
  nameList <- lapply(rList, function(x) names(x))
  nameDf <- data.frame(label = do.call(rbind, nameList))
  metaDf <- dateDfCreator(nameDf$label)

  return(list(veloxLoop, metaDf))
}
