get_current_list <- function(fileDirectory){
  # input: loads the current data. Each time we I access data I'll save a file
  # that has a date and a vector of what we've accessed.
  # what it does: accesses the latest file with the list.
  # output: and returns vector of names of what we have.

  listFiles <- list.files(fileDirectory, pattern = "files_downloaded")
  latest <- sort(listFiles)[1]

  tmp <- readRDS(paste(fileDirectory, latest, sep = "/"))
  return(tmp)

}
