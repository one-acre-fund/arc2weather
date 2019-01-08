#' Extracts values for GPS df from velox raster
#'
#' @param veloxRaster A list of two elements (from convert_to_velox function). First is list of velox raster, second is df of date information.
#' @param spdf A SpatialPointsDataFrame of the GPS for which we'll be extracting data from the velox raster.
#' @return A data.frame that is long by date. It has the observation for each date and GPS point in the raster data.
#' @export

extract_velox_gps <- function(veloxRaster, spdf){
  # input: v$extract_points(siteReproject) style code.
  # Takes a list of velox raster and extracts the right data points
  # output: a list with two elements: the first element is a df of the extracted values for the given gps points.
  #The second list is the df of GPS points to later merge with those GPS points for the final output.
  veloxLoop <- veloxRaster[[1]]

  ## here is where we check the CRS and confirm they're compatible.
  align_crs(veloxLoop, spdf)

  ## here is where we extract the values for the given GPS values.
  extractLoop <- list()
  for(i in seq_along(veloxLoop)){
    extractLoop[[i]] <- veloxLoop[[i]]$extract_points(spdf)
    extractLoop[[i]] <- as.data.frame(extractLoop[[i]])
  }

  # map the metaDf to the list so that I know the values of each extracted value. Keep this long?
  # extract loop has # of elements equal to the dates and each element is the length of the GPS points. I therefore want to combine dates with each element.
  # convert spdf@data into equal length list for easy mapping
  spdfList <- rep(list(spdf@data), nrow(extractLoop[[1]]))

  # combine gps points with extracted values
  dateList <- Map(cbind, spdfList, extractLoop)

  #combine date labels with the gps points and extracted values so the data can be aggregated as desired based on dates
  fullDfList <- Map(cbind, split(veloxRaster[[2]], veloxRaster[[2]]$numbers), dateList)

  fullDf <- plyr::rbind.fill(fullDfList) %>%
    rename(rainfall = V1)

  # return the combined meta data and the extracted values
  return(fullDf)

}
