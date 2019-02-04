#' Make sure the velox raster and the GPS spdf have the same CRS
#'
#' @param rList A list of raster in raster format.
#' @return List of two elements - first is the raster data in velox format. Second are the labels needed to identify the data later as a data.frame.
#' @examples
#' add(1, 1)
#' add(10, 1)

convert_to_velox <- function(raster_list, date_vector){

  veloxLoop <- list()
  for(i in seq_along(raster_list)){
    tmp <- velox::velox(raster_list[[i]])
    #tmp$crop(oafAreaReproject)
    veloxLoop[[i]] <- tmp
  }

  # and create df of the labels from rList
  #nameList <- lapply(rList, function(x) names(x))
  nameDf <- as.data.frame(date_vector)
  metaDf <- date_df_creator(nameDf$dates)

  return(list(veloxLoop, metaDf))
}
