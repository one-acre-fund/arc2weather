update_arc_weather_data <- function(url, dir){

  currentList <- getCurrentList(dir)
  fullList <- getFullList(url)

  newAdditions <- getNewAdditions(currentList, fullList, dir)

  getRawData(newAdditions, url)

}
