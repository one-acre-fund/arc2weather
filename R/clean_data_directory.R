#' clean raw data directory of dated files.
#'
#' @param dir directory where raw data lives
#' @param listToAccess the list of files to access from get_new_additions
#' @inheritParams get_raw_data()
#' @return nothing. It saves a single data file and deletes the other files.


clean_data_directory <- function(dir, pattern = "weatherRasterList"){
  list_to_remove <- paste(dir, list.files(dir, pattern), sep = "/")

  do.call(file.remove, list(list_to_remove))


}
