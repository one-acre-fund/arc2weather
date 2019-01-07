#' pulls full list of available datasets from Arc2 weather FTP
#'
#' @param url web url of FTP
#' @return A vector of the file names available on the FTP

get_full_list <- function(){
  # input: no input because the FTP url should remain the same
  # output: full list of available data sets

  h = curl::new_handle(dirlistonly=TRUE)
  con = curl::curl("ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/bin/", "r", h)
  fullList = read.table(con, stringsAsFactors=TRUE, fill=TRUE)
  close(con)
  #saveRDS(fullList, file=paste(fullList, todayDate, ".rds", sep = ""))
  return(fullList)

}
