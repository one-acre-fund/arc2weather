#' Combines the full functionality to take the raw inputs and produce data.frame of extracted weather data and dates.
#'
#' @param rawData list of raw raster data from Arc2 weather site
#' @param gpsFile GPS file, probably from data warehouse, of GPS points for which we want to extract weather values
#' @param latCol The Latitude column in the gpsFile
#' @param lonCol The Longitude column in the gpsFile
#' @return A data.frame with the extracted weather values and the date for each GPS point in the file.
#' @examples
#' add(1, 1)
#' add(10, 1)

extract_weather_data <- function(rawData,
                               gpsFile,
                               latCol,
                               lonCol){

  datExtract <- extract_velox_gps(
    veloxRaster = convert_to_velox(rawData),
    spdf = convertSpdf(gpsFile, lonCol, latCol))

  return(datExtract)
}
