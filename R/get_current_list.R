#' gets names of current files already downloaded and worked with
#'
#' @param fileDirectory the file location locally where the data names are saved
#' @return A vector of the file names available already


get_current_list <- function(dir){
  # input: loads the current data. Each time we I access data I'll save a file
  # that has a date and a vector of what we've accessed.
  # what it does: accesses the latest file with the list.
  # output: and returns vector of names of what we have.
  dir <- check_data_directory(dir)

  tmp <- readRDS(paste(dir, "full_list.rds", sep = "/"))
  return(tmp)

}
