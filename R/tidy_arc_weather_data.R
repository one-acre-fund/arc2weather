#' Applies some general cleaning to the extracted data before exporting
#'
#' @param df The data.frame coming from the full extract process.
#' @return A data.frame that has some variables cleaned and labels clarified.
#' @examples
#' add(1, 1)
#' add(10, 1)


tidy_arc_weather_data <- function(df){

  if(class(df) != "data.frame"){
    stop("\n tidy function wants a data frame as input!")
  }

  clean <- df %>%
    dplyr::mutate(rainfall = ifelse(rainfall < 0, NA, rainfall))

  return(clean)

}
