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

# look at names of rasters << so many but works in concept!

test <- lapply(arcWeatherRaw, function (x) names(x))


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

test <- subsetYearMonth(arcWeatherRaw, 1983, 1)
