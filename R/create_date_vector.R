#' Create date vector for given start and end date
#'
#' @param start_date start date, formatted YYYY-MM-DD
#' @param end_date end date, formatted YYYY-MM-DD
#' @return A data.frame with the extracted weather values and the date for each GPS point in the file.
#' @examples
#' add(1, 1)
#' add(10, 1)


create_date_vector <- function(start_date, end_date){

  start <- as.Date(start_date, format = "%Y-%m-%d")
  end <- as.Date(end_date, format = "%Y-%m-%d")

  if(end < start){
    stop("\n End date is not before start date. Please check!")
  }

  return(seq(from = start, to = end, by = "day"))

}
