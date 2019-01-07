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
getFullList <- function(url){
  
  h = new_handle(dirlistonly=TRUE)
  con = curl(url, "r", h)
  fullList = read.table(con, stringsAsFactors=TRUE, fill=TRUE)
  close(con)
  saveRDS(fullList, file=paste(fullList, todayDate, ".rds", sep = ""))
  
}

getCurrentList <- function(df){
  # input: loads the current data 
  # output: and returns vector of names of what we have.
}

getNewAdditions <- function(existingList, fullList){
  # input: list of current data we've accessed
  # output: list of new files we need to access
  
  updatedList = existingList[!existingList$V1 %in% fullList$V1,]
  
}

if(exists("updatedList")){
  listToAccess = updatedList
} else {
  listToAccess = fullList
}


urls =  paste0(url, listToAccess)
#fls = basename(urls)

###### DOWNLOAD DATA


# then download those urls
  
arcWeatherRaw <- lapply(urls, function(fileLocation){
  print(basename(fileLocation))
  raw <- convertBinToRaster(readArcBinary(fileLocation), fileLocation)
  return(raw)
  
})

todayDate <- format(Sys.time(), "%Y-%m-%d")

#### saved dated arcWeatherRaw file so that I can steadily create an updated raster brick
saveRDS(arcWeatherRaw, file=paste("weatherRasterList", todayDate, ".rds", sep = ""))


# and add them to the existing data
dataDir <- normalizePath(file.path("..", "arc2_weather_data", "raw_data", "rdata_file"))

fileList <- list.files(dataDir, pattern = "weatherRasterList")


# read them all in, put them together, and order them. I will eventually just
# want to download the latest and add them to the existing rather than importing
# lots of segments
finalDf <- NULL

for(i in seq_along(fileList)){
  load(paste(dataDir, fileList[i], sep = "/"))
  finalDf <- 
}



  


