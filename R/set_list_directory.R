#' this function checks the directory provided as the location of the ARC2
#' weather data. It then tries to guess at a reasonable modification but if it
#' doesn't work it ask for a new directory.
#'
#' @param fileDirectory the file location locally where the data names are saved
#' @return A vector of the file names available already

set_list_directory <- function(dir){

  if(endsWith(dir, "arc2_weather_data") && dir.exists(dir)){
    dir <- paste(dir, "access_lists", sep = "/")
  } else {
    cat("\n Please check that you've set your directory to the main Google Drive folder!")
  }

  return(dir)
}
