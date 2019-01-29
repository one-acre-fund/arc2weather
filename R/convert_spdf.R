#' Convert data.frame of GPS points in decimal degree format to an SpatialPointsDataFrame
#'
#' @param df A data frame of GPS points in decimal degree format
#' @param lat The variable that has the Latitude data
#' @param lon The variable that has the Longitude data
#' @param defaultCRS The default CRS to use. If none is provided then it uses the default latlon CRS.
#' @return A spdf with a default CRS. This default CRS will then need to be converted.
#' @export
#' @examples
#' add(1, 1)
#' add(10, 1)

convert_spdf <- function(df, lat = NULL, lon = NULL, defaultCRS = NULL){

  # make sure that input is not tibble and if so, convert to df.
  if(tibble::is_tibble(df)){
    df <- as.data.frame(df)
  }

  # convert lat lon to numeric
  df[, lat] <- suppressWarnings(as.numeric(df[,lat]))
  df[, lon] <- suppressWarnings(as.numeric(df[,lon]))

  if(is.null(lat) & is.null(lon) & class(df)=="data.frame"){
    stop("\n df is a data.frame. Please indicate the lat/lon variables.")
  }

  if(class(df) == "SpatialPointsDataFrame"){
    return(df)
  }

  if(any(is.na(df[,lat])) | any(is.na(df[, lon]))){
    # this will take the complete cases and proceed
    cat("\n There are missing lat/lon values. Taking complete cases and proceeding...")
    df <- df[complete.cases(df[, lat]), ]
    df <- df[complete.cases(df[, lon]), ]
  }

  if(class(df) == "data.frame" && is.null(defaultCRS)) {
    converted <- sp::SpatialPointsDataFrame(coords = df[,c(lon, lat)], data = df, proj4string = sp::CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))
    return(converted)
  }

  if(class(df) == "data.frame" && !is.null(defaultCRS)){
    converted <- sp::SpatialPointsDataFrame(coords = df[,c(lon, lat)], data = df, proj4string = sp::CRS(defaultCRS))
    return(converted)
  }

}
