# description of file
# written by:  @oneacrefund.org
# written for: @oneacrefund.org
# last edited: dd mmmm yyyy

#### set up ####
# clear environment and console
rm(list = ls())
cat("\014")


## load libraries

# dplyr is for working with tables
# reshape is for easy table transformation
# knitr is to make pretty tables at the end
# ggplot2 is for making graphs
libs <- c("tidyverse", "knitr", "readxl", "curl", "raster", "rgdal")
lapply(libs, require, character.only = T)

## reference raster
r <- raster("africa_arc.20180527.tif")


#### load list of available data ####


#### tbl should be checked against existing data so that we only update data.
# url <- "ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/bin/"
# h = new_handle(dirlistonly=TRUE)
# con = curl(url, "r", h)
# tbl = read.table(con, stringsAsFactors=TRUE, fill=TRUE)
# close(con)

#head(tbl)
todayDate <- format(Sys.time(), "%Y-%m-%d")
forceUpdate <- FALSE

### full list
url <- "ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/bin/"
h = new_handle(dirlistonly=TRUE)


if(!file.exists("initialDatePull.Rdata") || forceUpdate) {
  con = curl(url, "r", h)
  fullList = read.table(con, stringsAsFactors=TRUE, fill=TRUE)
  close(con)
  save(fullList, file="initialDatePull.Rdata")
} else {
  con = curl(url, "r", h)
  updatedList = read.table(con, stringsAsFactors=TRUE, fill=TRUE)
  close(con)
  
  load("initialDatePull.Rdata")
  updatedList = updatedList[!updatedList$V1 %in% fullList$V1,]
  
  
}

###### functions needed to download the data  

readArcBinary <- function(fileUrl){
  
  ### this function gets ARC2 data from the ftp site and converts it to a raster
  ### The resulting data are a list of rasters >> to be used for some raster math later
  conInfo <- gzcon(url(fileUrl))
  
  dat <- readBin(conInfo, numeric(), n = 1e6, size = 4, endian = 'big')
  close(conInfo)
  
  return(dat)
  
}
####

convertBinToRaster <- function(binaryInput, fileUrl){
  mat <- raster(matrix(binaryInput, nrow = 801, ncol = 751, byrow = TRUE))
  ### match raster
  extent(mat) = extent(r) ### reference raster
  crs(mat) = crs(r) ### reference raster
  names(mat) = basename(fileUrl)
  return(mat)
}


### determine which files to access
### funciton to take the list of datd we have now, compare to what is available,
### and produce list of what we need to pull to have fully updated list
dataDir <- normalizePath(file.path("..", "arc2_weather_data"))
dir <- normalizePath(file.path("..", "arc2_weather_data", "access_lists"))
rdsDir <- normalizePath(file.path("..", "arc2_weather_data", "raw_data"))

getFullList <- function(url){
  # input: data location url
  # output: full list of available data sets
  
  h = new_handle(dirlistonly=TRUE)
  con = curl(url, "r", h)
  fullList = read.table(con, stringsAsFactors=TRUE, fill=TRUE)
  close(con)
  #saveRDS(fullList, file=paste(fullList, todayDate, ".rds", sep = ""))
  return(fullList)
  
}

getCurrentList <- function(fileDirectory){
  # input: loads the current data. Each time we I access data I'll save a file
  # that has a date and a vector of what we've accessed. 
  # what it does: accesses the latest file with the list.
  # output: and returns vector of names of what we have.
  
  listFiles <- list.files(fileDirectory, pattern = "files_downloaded")
  latest <- sort(listFiles)[1]
  
  tmp <- readRDS(paste(fileDirectory, latest, sep = "/"))
  return(tmp)

}

getNewAdditions <- function(existingList, fullList, directory){
  # input: list of current data we've accessed
  # what it does: saves list so we have record of what we've accessed
  # output: list of new files we need to access
  
  updatedList = as.data.frame(fullList[!fullList$V1 %in% existingList$V1,])
  names(updatedList) = "V1"
  
  # this saves the list for next time
  saveRDS(updatedList, file = paste(directory, paste("files_downloaded_", todayDate, ".rds", sep = ""), sep = "/"))
  
  
  return(updatedList)
  
}


# import current list and save in right format in right location to set up functions
# load(paste(dataDir, "initialDatePull.Rdata", sep = "/")) # fullList
# 
# saveRDS(fullList, paste(dir, "files_downloaded_2018-05-28.rds", sep = "/"))


### create funciton that downloads the data. This function will also save the ##
#list of what we've accessed so we have it for next time! what we'll do is
#assume that we've accessed everything through the most up to date file name in
#the current file for next time

arcWeatherRaw <- lapply(urls, function(fileLocation){
  print(basename(fileLocation))
  raw <- convertBinToRaster(readArcBinary(fileLocation), fileLocation)
  return(raw)
  
})

getRawData <- function(listToAccess, url){
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

#### full functionality

updateArcWeatherData <- function(url, dir){
  
  currentList <- getCurrentList(dir)
  fullList <- getFullList(url)
  
  newAdditions <- getNewAdditions(currentList, fullList, dir)
  
  getRawData(newAdditions, url)
  
}




#### okay, set up sequence and test!

test1 <- getCurrentList(dir)
test2 <- getFullList(url)
test <- getNewAdditions(test1, test2, dir)





