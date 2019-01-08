#' Convert data.frame of GPS points in decimal degree format to an SpatialPointsDataFrame
#'
#' @param df A data frame of GPS points in decimal degree format
#' @param lat The variable that has the Latitude data
#' @param long The variable that has the Longitude data
#' @param defaultCRS The default CRS to use. If none is provided then it uses the default latlon CRS.
#' @return A spdf with a default CRS. This default CRS will then need to be converted.
#' @examples
#' add(1, 1)
#' add(10, 1)

convert_spdf <- function(df, lat = NULL, long = NULL, defaultCRS = NULL){
  # input: a data frame that may or not be a spdf. If it's not an spdf, convert to spdf and give it a default CRS.
  # output: spdf with a CRS ready to be converted to the CRS to match the veloxRaster data

  if(is.null(lat) & is.null(long) & class(df)=="data.frame"){
    stop("\n df is a data.frame. Please indicate the lat/lon variables.")
  }

  if(class(df) == "SpatialPointsDataFrame"){
    return(df)
  }

  if(class(df) == "data.frame" && is.null(defaultCRS)) {
    converted <- sp::SpatialPointsDataFrame(coords = df[,c(long, lat)], data = df, proj4string = sp::CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
    return(converted)
  }

  if(class(df) == "data.frame" && !is.null(defaultCRS)){
    converted <- sp::SpatialPointsDataFrame(coords = df[,c(long, lat)], data = df, proj4string = sp::CRS(defaultCRS))
    return(converted)
  }

}
