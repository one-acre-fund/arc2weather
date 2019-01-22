#' consolidate raw data into single file to simplify storage and loading
#'
#' @param dir directory where raw data lives. Dir is the raw_data folder from
#'   inhereted from the get_raw_data
#' @param pattern the pattern that identifies the raw data files
#' @inheritParams get_raw_data()
#' @return nothing. It saves a single data file and deletes the other files.

create_master_raw_data <- function(dir, pattern = "weatherRasterList"){
  list_to_combine <- list.files(dir, pattern)

  master_data <- do.call(rbind, lapply(list_to_combine, function(file_name){
    df <- readRDS(paste(dir, file_name, sep = "/"))
    return(df)
  }))

  saveRDS(master_data, file = paste(dir, "master_weather_data.rds", sep))

}
