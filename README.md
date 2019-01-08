# ARC2 weather data package

Code for systematically downloading available arc2 weather .tif files for east Africa and shaping the data for inclusion in the One Acre Fund data warehouse.

One Acre Fund has been using [aWhere](www.awhere.com) for weather data access for the simplicity of their GPS based API. However, we're looking to do more with site GPS and weather data and have not seen aWhere to be a superior product in terms of quality. Therefore we are accesing publically available weather datasets so that we can more easily communicate and share with collaborators on weather data related projects.

This code is the example / starter code for accessing a publically available weather dataset and formatting the data for 1AF's use cases. Eventually we'll be adding these data or [CHIRPS](ftp://ftp.chg.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/africa_daily/tifs/p25/) into the organizational data warehouse so that we can automate extracting long and short term weather averages using site GPS. 

# How to install

To install this package, please do the following:

1. You'll need to create a personal access token (PAT) on github to download the package from github.
  + Go to the [tokens](https://github.com/settings/tokens) page on github to create a token. Be sure to select the `repo` scope so that it works!
  + Then, you'll need to edit the `.Renviron` file on your computer to make that PAT available to R when it tries to download the package.
  + To do this, type `usethis::edit_r_environ()` in R to edit the `.Renviron` file.
  + In the `.Renviron` file type `GITHUB_PAT = "longstringoflettersandnumbersyougetfromgithub". Then save and close that file. You might have to restart R for the changes to take effect.
2. Open R script and download the package using `devtools::install.github(one-acre-fund/arc2weather)`. (You can check that the GITHUB_PAT is working as it should by first typing `Sys.getenv("GITHUB_PAT")` in the R console.)
3. The package should now be available for your use!


# How to use

The `extract_weather_data` function takes two inputs - the raw raster data and a set of GPS points. You can find the raw raster data here: [link](https://drive.google.com/open?id=1iQoN6mRkf3L7yySflmePe5begWKDdDQ7). The example file is `weatherRasterList2019-01-07.rds`. And you can find the GPS data here: [link](https://drive.google.com/open?id=1bXO74V5c4URUqtkPVeyABywjpfmFW2Mx) and the file is named `kenya_gps_2019.rds`. These are the inputs I've been using to test the package but of course we should try additional inputs to stress test the code!

Running the code looks like:
~~~~
# first make suer you install the arc2weather package following the instructions above
library(arc2weather)

dataDir <- "path/to/weather/file"
weatherRaster <- readRDS(paste(dataDir, "full_weather_list.rds", sep = "/"))

gpsDir <- "path/to/gps/file"
gpsData <- readRDS(paste(gpsDir, "kenya_gps_2019.rds", sep = "/"))

# and the package itself!
weatherValues <- extract_weather_data(weatherRaster, gpsData)

~~~~
