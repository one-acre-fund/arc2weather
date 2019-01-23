#' Converts data vector from raw raster file name into useable date information for identification
#'
#' @param dateVector The date vector from the Arc2 raw weather data
#' @return data.frame of date vector, year, month, and day in numeric format.
#' @examples
#' add(1, 1)
#' add(10, 1)

date_df_creator <- function(dateVector){
  # input: standard format of YYYYMMDD
  # output: df with three columsn for aggreation

  #numbers <- as.numeric(gsub(".*?([0-9]+).*", "\\1", dateVector))
  # if(nchar(numbers) != 8){
  #   stop("\n the date vector is not the right length")
  # }

  year = lubridate::year(dateVector)
  month = lubridate::month(dateVector)
  day = lubridate::day(dateVector)

  return(data.frame(date = dateVector, year, month, day))
}
