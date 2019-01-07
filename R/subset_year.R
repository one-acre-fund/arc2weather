subset_year <- function(rList, year){
  # input - list of weather rasters and year as INT.
  # output - year or years in question
  
  # consider adding in some checks that prevent erroneous years from being entered, too big or too small.
  year = as.character(year)
  
  if(length(year) > 1){
    year = paste(year, collapse = "|")
  }
  
  nameVector = lapply(rList, function(x) names(x))
  loc = grep(year, nameVector)
  res = rList[loc]
  return(res)
}