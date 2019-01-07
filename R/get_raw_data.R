get_raw_data <- function(listToAccess, url){
  # input: list of files that we need to access to have up to date data
  # what it does: turns those into urls and then accesses the data
  # output: saves data to raw_data location

  urls =  paste0(url, listToAccess)

  newData <- lapply(urls, function(fileLocation){
    print(basename(fileLocation))
    raw <- convertBinToRaster(readArcBinary(fileLocation), fileLocation)
    return(raw)
  })

  saveRDS(newData, file = paste(rdsDir, paste("weatherRasterList", todayDate, ".rds", sep = ""), sep = "/"))

}
