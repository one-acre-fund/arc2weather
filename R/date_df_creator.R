date_df_creator <- function(dateVector){
  # input: standard format of YYYYMMDD 
  # output: df with three columsn for aggreation
  
  numbers <- as.numeric(gsub(".*?([0-9]+).*", "\\1", dateVector))
  
  year = as.numeric(substr(numbers, 1, 4))
  month = as.numeric(substr(numbers, 5, 6))
  day = as.numeric(substr(numbers, 7, 8))
  
  return(data.frame(numbers, year, month, day))
}
