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


load("weatherRasterList.Rdata")


### weather brick
# weatherBrick <- brick(arcWeatherRaw)
# save(weatherBrick, file = "weatherBrick.Rdata")

if(!file.exists("weatherBrick.Rdata") || forceUpdate){
  weatherBrick <- brick(arcWeatherRaw)
  save(weatherBrick, file = "weatherBrick.Rdata")
} else {
  load("weatherBrick.Rdata")
}

## now I want to do extract meta data on dates in the brick and create yearly and 
## monthly aggregates for different points that I extract from the brick. TBD if that's
## all possible.