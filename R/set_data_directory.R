#' This function sets the directory to the raw data location to simplify
#' extending data directories in the read and write process
#'
#' @param fileDirectory the file location locally where the data names are saved
#' @return A vector of the file names available already

set_data_directory <- function(dir){

  if(endsWith(dir, "arc2_weather_data") && dir.exists(dir)){
    data_dir <- paste(dir, "raw_data", sep = "/")
  } else {
    stop("\n directory doesn't exist. Please check directory location.")
  }

  return(data_dir)
}
