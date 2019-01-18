#' pulls the yet to be accessed new data from the FTP
#'
#' @param url web url of FTP with the file names
#' @param listToAccess the list of files to access from get_new_additions
#' @inheritParams get_raw_data()
#' @inheritParams convert_bin_to_raster()
#' @return a list of rasters accessed from the FTP. Saves this file to the directory


get_raw_data <- function(listToAccess, dir, url = NULL){
  # input: list of files that we need to access to have up to date data
  # what it does: turns those into urls and then accesses the data
  # output: saves data to raw_data location
  if(is.null(url)){
    url <- "ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/bin/"
  }


  saveDirectory <- paste(dir, "raw_data", sep = "/")
  listDir <- paste(dir, "access_lists", sep = "/")


  urls =  paste0(url, as.vector(listToAccess[,1]))

  newData <- lapply(urls, function(fileLocation){
    print(basename(fileLocation))
    raw <- convert_bin_to_raster(read_arc_binary(fileLocation), fileLocation)
    return(raw)
  })

  saveRDS(newData, file = paste(saveDirectory, paste("weatherRasterList", todayDate(), ".rds", sep = ""), sep = "/"))

  # and save the names of those newly downloaded data to the master list of downloaded data
  newFiles <- do.call(rbind, lapply(newData, names))
  saveRDS(newData, file = paste(dir, paste("files_downloaded_", todayDate(), ".rds", sep = ""), sep = "/"))
}
