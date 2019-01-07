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
libs <- c("tidyverse", "knitr", "readxl", "curl", "raster", "rgdal", "velox")
lapply(libs, require, character.only = T)

#https://hunzikp.github.io/velox/index.html

forceUpdate <- FALSE

dataDir <- normalizePath(file.path("..", "arc2_weather_data"))

rawDir <- normalizePath(file.path("..", "arc2_weather_data", "raw_data"))
load(paste(rawDir, "weatherRasterList.Rdata", sep = "/")) # this is huge! Find a way to break this down to simplify calculations. 

load(paste(rawDir, "rdata_file", "weatherRasterList.Rdata", sep = "/"))

# if(!file.exists(paste(rawDir, "weatherRasterList.rds", sep = "/")) | forceUpdate){
#   #load(paste(rawDir, "rdata_file", "weatherRasterList.Rdata", sep = "/"))
#   saveRDS(arcWeatherRaw, file=paste(rawDir, "weatherRasterList.rds", sep = "/"))
# } else {
#   arcWeatherRaw <- readRDS(file = paste(rawDir, "weatherRasterList.Rdata", sep = "/"))
# }

# SUBSET BY YEAR
subsetYear <- function(rList, year){
  # input - list of weather rasters and year as INT.
  # output - year or years in question
  
  # consider adding in some checks that prevent erroneous years from being entered, too big or too small.
  year = as.character(year)
  
  if(length(year) > 1){
    year = paste(year, collapse = "|")
  }
  
  nameVector = lapply(rList, function(x) names(x))
  loc = grep(year, nameVector)
  res = rList[loc]
  return(res)
}

# SUBSET BY MONTH
subsetMonth <- function(rList, month){
  # input - list of weather rasters and month as numeric month
  # output - list of rasters corresopnding to that month
  month = as.character(paste0(0, month))
  
  if(length(month) > 1){
    month = paste(month, collapse = "|")
  }
  
  nameVector = lapply(rList, function(x) names(x))
  
  # grepping the month will be a bit more tricky because we can't simply enter a
  # number as that number will appear many other times for other reasons. So our pattern matching will need to be better!
  grepText = paste0("....", month, "..\\.gz$")
  loc = grep(grepText, nameVector)
  res = rList[loc]
  return(res)
  
}

# I can now use these funcitons in concert to get data from a specific year and month
subsetYearMonth <- function(rList, year, month){
  return(subsetYear(subsetMonth(rList, month), year))
  
}

#test <- subsetYearMonth(arcWeatherRaw, 1983, 1)


# import the Kenya shapefile, focus on western Kenya and then subset for certain years
gpsDir <- normalizePath(file.path("..", "..", "soil_grids_data"))

siteGpsFiles <- list.files(paste(gpsDir, "2019", sep = "/"), pattern = ".xls")

siteGpsFiles <- siteGpsFiles[!siteGpsFiles %in% c("District Offices.xlsx", "Regional Office.xlsx", "Warehouses.xlsx")]
siteGpsFiles <- paste(gpsDir, "2019", siteGpsFiles, sep = "/")

readGpsFiles <- lapply(siteGpsFiles, function(x){
  read_xlsx(x)
})

combineGpsFiles <- as.data.frame(do.call(rbind, readGpsFiles))

# investigate the projection of these data points
siteSp <- SpatialPointsDataFrame(coords = combineGpsFiles[,c("Longitude", "Latitude")], data = combineGpsFiles, proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")) # use this to get the right map for N and P

if(!file.exists(paste0(dataDir, "/GADM_2.8_KEN_adm2.rds"))){
  keBoundaries <- getData("GADM", country='KE', level=2, path = dataDir) 
} else {
  keBoundaries <- readRDS(paste0(dataDir, "/GADM_2.8_KEN_adm2.rds"))
}

# I additionally want to subset this down to just western Kenya because it's too
# computationally intentsive to run these calculations for other areas. I'm
# going to subset the shape file to just western Kenya and the plot it to
# confirm I've done it correctly. 

# original crs for site points in Kenya = +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 
# original crs for ke boundaries = +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0
# original crs for weather data = +proj=longlat +a=6371000 +b=6371000 +no_defs

# I suggest we use the weather data crs to avoid having lots of intensive reprojection

siteReproject <- spTransform(siteSp, CRS("+proj=longlat +a=6371000 +b=6371000 +no_defs"))
boundaryReproject <- spTransform(keBoundaries, CRS("+proj=longlat +a=6371000 +b=6371000 +no_defs"))

weatherMap <- intersect(boundaryReproject, siteReproject)

### KENYA CROP AND MASK BEFORE AGGREGATING DATA ### 

# i'm still not really sure what the most expendient way is to get the data we need. 
# I think the best sequence will be extracting the points and then subsetting down by years or months as need be depending on the use case and aggregation
# 

# This means I need a full list of gps across all countries in the right CRS. I
# then can subset down to just the countries I need to make the data smaller.
# This is hopefully small enough that I can then extract the points I need from
# a complete brick and then perform the right aggregations by season, year, and month.

### FIRST DOWNLOAD THE COUNTRIES OF INTEREST AND COMBINE INTO ONE SP FILE?
# use ISO codes
oafCountries <- c("KEN", "RWA", "UGA", "BDI", "TZA", "ZMB", "MWI") 

# this imports the shape files I need.
countrySpFiles <- lapply(oafCountries, function(x){
  getData("GADM", country = x, level = 2, path = dataDir)
})

gadmFiles <- paste(dataDir, list.files(dataDir, pattern = "GADM"), sep = "/")

# check crs to make sure the files play nicely together
crsCheck <- lapply(gadmFiles, function(x){
  tmp = readRDS(x)
  coordsystem = crs(tmp)@projargs
  return(coordsystem)
})

# then check that the results are the same
length(unique(crsCheck))==1

# combine into one sp file for subsetting the weather data
oafArea <- do.call(bind, lapply(gadmFiles, function(x){readRDS(x)}))

# this is what I now what to use to subset the large and unwieldy weather data, by decade or year if need be. use velox to speed this up!
oafAreaReproject <- spTransform(oafArea, CRS("+proj=longlat +a=6371000 +b=6371000 +no_defs"))


# get map Values
getMapValues <- function(rasterList, map){
  # this function trims the africa sized raster down to just the extent of 1AF countries we care about
  # output: a list of rasters to go into the weight calculations
  # this cna also be used on a single raster but it'll then return 
  createVelox = velox(brick(rasterList))
  
  return(createVelox$extract)
}


# there's a limit to how many seasons I can combine. I want to aggregate the
# data so that it's easy to get the full picture or any relevant subsets What
# rules should I follow for determining which subsets to make? For now I should
# just make the long term average >> and set this us to easily update as we get
# more data.

# HOW TO HANDLE THE LARGE AMOUNT OF DATA subset the rasters (in groups if need
# be) to just the areas we're interested in. For the purposes of updating the
# data going forward, we'll create decade long groupings which should be
# manageable for extracting values and then summarizing them


# notes on how to use crop and extract ---------------

# these data are large


# and the full example -------------------------
veloxLoop <- list()
for(i in seq_along(arcWeatherRaw)){
  tmp <- velox(arcWeatherRaw[[i]])
  tmp$crop(oafAreaReproject)
  veloxLoop[[i]] <- tmp
  
}


## check the size of this file to see if we've made our problem a bit more manageable
checkSize <- function(obj, unit){
  return(format(object.size(obj), units = unit))
}

# notes on how velox works -----------------------

### investigate the `oafoperatingarea` object. I want this to have a matrix for
#each day for each location which means that it'll be a very long list of
#matrices. I think I really just want to create a big velox stack and extract
#the points I want taking the mean of that object. That should be manageable.

# test2 <- test$extract(oafAreaReproject, fun=mean) # this is a 1149 x 365 matrix, there is one column per band in the stack and one row for each object in oafAreaProject
# 
# test3 <- test$extract(oafAreaReproject, fun=NULL) # this is a list of 1149 objects with 365 columns per element. Those are the values 

format(object.size(veloxLoop), units = "Kb") # much smaller!

# extract GPS points from reduced set of points -------------






