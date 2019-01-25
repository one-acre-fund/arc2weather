# [Africa Rainfall Climatology](http://www.cpc.ncep.noaa.gov/products/african_desk/cpc_intl/cf_test/africa/arc/arc_run_wa.shtml) weather data package

**Work in progress** Check with [Matt Lowes](mailto::matt.lowes@oneacrefund.org) if you have questions!

Code for systematically downloading available ARC2 weather .tif files for east Africa and shaping the data for inclusion in the One Acre Fund data warehouse.

One Acre Fund has been using [aWhere](www.awhere.com) for weather data access for the simplicity of their GPS based API. However, we're looking to do more with site GPS and weather data and have not seen aWhere to be a superior product in terms of quality. Therefore we are accesing publically available weather datasets so that we can more easily communicate and share with collaborators on weather data related projects.

This code is the example / starter code for accessing a publically available weather dataset and formatting the data for 1AF's use cases. Eventually we'll be adding these data or [CHIRPS](ftp://ftp.chg.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/africa_daily/tifs/p25/) into the organizational data warehouse so that we can automate extracting long and short term weather averages using site GPS. 

# How to install

To install this package, please do the following:

1. You'll need to create a personal access token (PAT) on github to download the package from github.
  + Go to the [tokens](https://github.com/settings/tokens) page on github to create a token. Be sure to select the `repo` scope so that it works!
  + Then, you'll need to edit the `.Renviron` file on your computer to make that PAT available to R when it tries to download the package.
  + To do this, type `usethis::edit_r_environ()` in R to edit the `.Renviron` file.
  + In the `.Renviron` file type `GITHUB_PAT = "longstringoflettersandnumbersyougetfromgithub"`. (What goes in the quotes is the PAT you got from GitHub). Then save and close that file. You might have to restart R for the changes to take effect.
2. Open R script and download the package using `devtools::install_github(one-acre-fund/arc2weather)`. (You can check that the GITHUB_PAT is working as it should by first typing `Sys.getenv("GITHUB_PAT")` in the R console.)
3. The package should now be available for your use!


# How to use

The `extract_weather_data` function takes two inputs - the raw raster data and a set of GPS points. You can find the raw raster data here: [link](https://drive.google.com/open?id=1iQoN6mRkf3L7yySflmePe5begWKDdDQ7). The example file is `weatherRasterList2019-01-07.rds`. And you can find the GPS data here: [link](https://drive.google.com/open?id=1bXO74V5c4URUqtkPVeyABywjpfmFW2Mx) and the file is named `kenya_gps_2019.rds`. These are the inputs I've been using to test the package but of course we should try additional GPS to stress test the code!

Running the code looks like:
~~~~
# first make suer you install the arc2weather package following the instructions above.
library(arc2weather)

# provide the list of desired dates. This example accesses the full year of 2010.
dates <- seq(from = as.Date("2010-01-01"), to = as.Date("2010-12-31"), by = "day")

weatherValues <- extract_weather_data(dates, gpsData, "Latitude", "Longitude")

# one year timing
# user  system elapsed
# 374.072 106.877 510.620
~~~~

# How to find and download data

The ARC2 data are available at this FTP address: ftp://ftp.cpc.ncep.noaa.gov/fews/fewsdata/africa/arc2/. The data are most easily avialable in binary format so the code will download the binary format and convert it to raster according to the process outlined in the ARC2 readme (see FTP link for more details).

I've downloaded a large portion of the data to this [Google Drive folder](https://drive.google.com/open?id=1n1vJDfnWKdL_PiSfnXSyGiqLVl6h0XvL). You will need local access to these data if you want to extract weather values from the data meaning you'll need to download the folder to computer.

The function `update_arc_weather_data()` will look at the available data, determine what data we already have, and then go and pull the latest data. This function assumes that you're pointing it at the Google Drive folder linked above! If you sync that Google drive folder to your computer, it should already have the subfolders you need to update the data and proceed with data extraction. A couple notes:

* The `arc2_weather_data` folder on Google Drive is a shared data folder for 1AF users. This means that 1AF users shouldn't need to update this data folder themselves since we'll have it regularly updating in this central location. That also implies that any change to this folder affects all users!
* The functions as they currently stand (1.20.19) are specifically set up with the 1AF structure in mind meaning that the download code won't be as useful for outside users. A medium term goal is to update these download functions so that the code can be used by others.

As an example of how to download data:

~~~~
# this is where the data are on my computer
arc2_weather_directory <- "/Users/mlowes/Google Drive/analyses/weather_analyses/arc2_weather_data"

update_arc_weather_data(arc2_weather_directory)

~~~~

This will download the latest available weather data, save the data with the others, and update the reference list of the data that we have. This leaves us ready to extract updated values from the data for our calculations!

# References

[rnoaa](https://github.com/ropensci/rnoaa) - R code to access other NOAA data sets. ARC2 isn't one of them.

CHIRPS data FTP- ftp://ftp.chg.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/ - will expand tools to include this as well
