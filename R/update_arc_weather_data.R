update_arc_weather_data <- function(url, dir){

  currentList <- get_current_list(dir)
  fullList <- get_full_list(url)

  newAdditions <- get_new_additions(currentList, fullList, dir)

  get_raw_data(newAdditions, url)

}
