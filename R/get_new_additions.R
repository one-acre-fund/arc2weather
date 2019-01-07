get_new_additions <- function(existingList, fullList, directory){
  # input: list of current data we've accessed
  # what it does: saves list so we have record of what we've accessed
  # output: list of new files we need to access

  updatedList = as.data.frame(fullList[!fullList$V1 %in% existingList$V1,])
  names(updatedList) = "V1"

  # this saves the list for next time
  saveRDS(updatedList, file = paste(directory, paste("files_downloaded_", todayDate, ".rds", sep = ""), sep = "/"))


  return(updatedList)

}
