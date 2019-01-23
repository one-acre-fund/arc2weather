#' Convert tibble data from api call to raster
#'
#' @param list_of_tibble A list of tibbles from the API call
#' @return List of raster data. This goes into the convert_to_velox function so needs to fit nicely with that function's expectations
#' @examples
#' add(1, 1)
#' add(10, 1)

convert_tibble_to_raster <- function(raw_data_list){

  raster_list <- lapply(raw_data_list, function(tb){
    sp::coordinates(tb) = ~ lon + lat
    sp::proj4string(tb) <- sp::CRS("+init=epsg:4326")
    sp::gridded(tb) <-  TRUE
    r <- raster::raster(tb)
    return(r)
  })

  return(raster_list)
}
