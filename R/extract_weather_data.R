#' Combines the full functionality to take the raw inputs and produce data.frame of extracted weather data and dates.
#'
#' @param rawRasterData list of raw raster data from Arc2 weather site
#' @param gpsFile GPS file, probably from data warehouse, of GPS points for which we want to extract weather values
#' @param latCol The Latitude column in the gpsFile
#' @param lonCol The Longitude column in the gpsFile
#' @inheritParams create_date_vector
#' @return A data.frame with the extracted weather values and the date for each GPS point in the file.
#' @export
#' @examples
#' weatherValues <- extract_weather_data(dates, gpsData, "Latitude", "Longitude")

extract_weather_data <- function(start_date,
                                 end_date,
                                 gpsFile,
                                 latCol,
                                 lonCol){

  datExtract <- extract_velox_gps(
    veloxRaster = convert_to_velox(convert_tibble_to_raster(arc2_api_download(dates)), dates),
    spdf = convert_spdf(gpsFile, lonCol, latCol))

  return(datExtract)
}
