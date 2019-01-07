#' Subset the raster list by month
#'
#' @param rList A list of raster in raster format.
#' @param month A numeric month between 1 and 12 to indicate which month to keep. This can be a vector or range as well.
#' @return List of two elements - first is the raster data in velox format. Second are the labels needed to identify the data later.
#' @examples
#' add(1, 1)
#' add(10, 1)

subset_month <- function(rList, month){
  # input - list of weather rasters and month as numeric month
  # output - list of rasters corresopnding to that month
  if(month > 12 || month < 1){
    stop("\n Not a valid month number. Please enter a number between 1 and 12")
  }


  if(month < 9){
    month = as.character(paste0(0, month))
  } else {
    month = as.character(month)
  }

  if(length(month) > 1){
    month = paste(month, collapse = "|")
  }

  nameVector = lapply(rList, function(x) names(x))

  # grepping the month will be a bit more tricky because we can't simply enter a
  # number as that number will appear many other times for other reasons. So our pattern matching will need to be better!
  grepText = paste0("....", month, "..\\.gz$")
  loc = grep(grepText, nameVector)
  res = rList[loc]
  return(res)

}
