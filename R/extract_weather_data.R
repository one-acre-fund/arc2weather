extract_weather_data <- function(rawData, 
                               gpsFile, 
                               latCol, 
                               lonCol){
  
  datExtract <- extract_velox_gps(
    veloxRaster = convert_to_velox(rawData), 
    spdf = convertSpdf(gpsFile, lonCol, latCol))
  
  return(datExtract)
}