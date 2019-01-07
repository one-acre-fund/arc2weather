#' takes the list of file names and creates a single master list that will be referenced and updated going forward.
#'
#' @param directory the location where those files live
#' @return an rds file that has all the data that has been accessed up to this point

update_current_list <- function(directory = NULL){
  if(is.null(directory)){
    directory <- normalizePath(file.path("..", "arc2_weather_data", "access_lists"))
  }

  listFiles <- list.files(directory, pattern = "files_downloaded")
  fullList <- do.call(rbind, lapply(listFiles, function(f){
    tmp <- readRDS(paste(directory, f, sep = "/"))
    return(tmp)
  }))

  saveRDS(fullList, file = paste(directory, "full_list.rds", sep = "/"))

}
