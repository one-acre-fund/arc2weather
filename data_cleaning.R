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

forceUpdate <- FALSE

dataDir <- normalizePath(file.path("..", "arc2_weather_data"))

if(!file.exists(paste(dataDir, "weatherBrick.Rdata", sep = "/")) || forceUpdate){
  rawDir <- normalizePath(file.path("..", "arc2_weather_data", "raw_data"))
  load(paste(rawDir, "weatherRasterList.Rdata", sep = "/"))
  weatherBrick <- velox(brick(arcWeatherRaw))
  #weatherBrick[weatherBrick < 0] <- NA
  save(weatherBrick, file = "weatherBrick.Rdata")
} else {
  load(paste(dataDir, "weatherBrick.Rdata", sep = "/"))
}

# weahter brick will be the most efficient
names(weatherBrick) <- gsub(".gz", "", names(weatherBrick))
names(weatherBrick) <- gsub("daily_clim.bin.", "weatherValues_", names(weatherBrick))

#values(weatherBrick)[values(weatherBrick) < 0] <- NA # file is too big

wb.velox <- velox(weatherBrick)

# get a daily average for the full data set. I'd probably actually want to crop this first to just our locations before trying this but let's see what happens.
dailyMean <- calc(weatherBrick, fun = function(x){mean(x, na.rm=T)})