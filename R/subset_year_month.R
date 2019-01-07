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