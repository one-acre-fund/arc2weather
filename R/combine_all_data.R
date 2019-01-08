#' Combines all accessed data into a single list of rasters
#'
#' @param directory Where to find the lists of rasters to combine into a single list
#' @return A list of rasters to put into the convert_to_velox sequence to get it ready for extraction


combine_all_data <- function(directory = NULL){

  if(is.null(directory)){
    directory <- normalizePath(file.path("..", "arc2_weather_data", "raw_data"))
  }

  listFiles <- sort(list.files(directory, pattern = "weatherRasterList"))

  # read in data and combine into list
  fullRasterList <- do.call(c, lapply(listFiles, function(f){
    tmp <- readRDS(paste(directory, f, sep = "/"))
    return(tmp)
  }))

  saveRDS(fullRasterList, file=paste(directory, "full_weather_list.rds", sep = "/"))

}
