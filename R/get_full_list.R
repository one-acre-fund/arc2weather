#' pulls full list of available datasets from Arc2 weather FTP
#'
#' @param url web url of FTP
#' @return A vector of the file names available on the FTP

get_full_list <- function(url){
  # input: data location url
  # output: full list of available data sets

  h = new_handle(dirlistonly=TRUE)
  con = curl(url, "r", h)
  fullList = read.table(con, stringsAsFactors=TRUE, fill=TRUE)
  close(con)
  #saveRDS(fullList, file=paste(fullList, todayDate, ".rds", sep = ""))
  return(fullList)

}
