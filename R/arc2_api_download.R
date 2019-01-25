#' Downloads data into list of tibbles by date using rnoaa API.
#'
#' @param vector_of_dates A list of raster in velox format. Shoudl be in YYYY-MM-DD format
#' @return An spdf with the same format as the velox raster data. We can re-use the dates list again without passing it through the function as returned output.
#' @examples
#' arc2_api_download(c("2019-01-01", "2019-01-02"))

arc2_api_download <- function(list_of_dates){

  raw_data <- lapply(list_of_dates, function(cal_date){
    rnoaa::arc2(cal_date)
  })

  return(raw_data)
}
