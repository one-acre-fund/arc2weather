#' takes the list of file names and creates a single master list that will be
#' referenced and updated going forward. I want this to run every time I update
#' the arc2 weather data
#'
#' @param directory the location where those files live
#' @return an rds file that has all the data that has been accessed up to this
#'   point

update_current_list <- function(directory){
  directory <- check_data_directory(directory)

  listFiles <- list.files(directory, pattern = "files_downloaded")
  fullList <- do.call(rbind, lapply(listFiles, function(f){
    tmp <- readRDS(paste(directory, f, sep = "/"))
    return(tmp)
  }))

  saveRDS(fullList, file = paste(directory, "full_list.rds", sep = "/"))

}
