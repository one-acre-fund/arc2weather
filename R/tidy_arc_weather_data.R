tidy_arc_weather_data <- function(df){
  
  if(class(df) != "data.frame"){
    stop("\n tidy function wants a data frame as input!")
  }
  
  clean <- df %>%
    mutate(rainfall = ifelse(rainfall < 0, NA, rainfall))
  
  return(clean)
  
}