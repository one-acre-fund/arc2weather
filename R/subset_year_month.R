#' Subset the raster list by month and year combining the subset month and year functions
#'
#' @param rList A list of raster in raster format.
#' @param month A numeric month between 1 and 12 to indicate which month to keep. This can be a vector or range as well.
#' @param year A numeric year between 1985 and present. A range is also acceptable.
#' @return A list of rasters for the requested months and years
#' @examples
#' add(1, 1)
#' add(10, 1)


subset_year_month <- function(rList, year = NULL, month = NULL){

  if(is.null(year) && is.null(month)){
    stop("\n Please provide either a year or a month value!")
  } else if (is.null(year) && !is.null(month)){
    return(subsetMonth(rList, month))
  } else if (is.null(month) && !is.null(year)){
    return(subsetYear(rList, year))
  } else {
    return(subsetYear(subsetMonth(rList, month), year))
  }

}
