#' gets names of current files already downloaded and worked with
#'
#' @param dir the file location locally where the data names are saved. This
#'   should be one step above the access_list folder
#' @return A vector of the file names available already by loading the joined file.


get_current_list <- function(dir){
  # input: loads the current data. Each time we I access data I'll save a file
  # that has a date and a vector of what we've accessed.
  # what it does: accesses the latest file with the list.
  # output: and returns vector of names of what we have.
  dir <- set_list_directory(dir)

  tmp <- readRDS(paste(dir, "full_list.rds", sep = "/"))
  return(tmp)

}
