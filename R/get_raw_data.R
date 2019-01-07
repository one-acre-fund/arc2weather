#' pulls the yet to be accessed new data from the FTP
#'
#' @param url web url of FTP with the file names
#' @param listToAccess the list of files to access from get_new_additions
#' @return a list of rasters accessed from the FTP. Saves this file to the directory


get_raw_data <- function(listToAccess, url = NULL){
  # input: list of files that we need to access to have up to date data
  # what it does: turns those into urls and then accesses the data
  # output: saves data to raw_data location
  if(is.null(url)){
    url = "ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/bin/"
  }

  urls =  paste0(url, listToAccess)

  newData <- lapply(urls, function(fileLocation){
    print(basename(fileLocation))
    raw <- convert_bin_to_raster(readArcBinary(fileLocation), fileLocation)
    return(raw)
  })

  saveRDS(newData, file = paste(rdsDir, paste("weatherRasterList", todayDate, ".rds", sep = ""), sep = "/"))

}
