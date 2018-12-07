# ARC 2 Weather access and analysis

Code for systematically downloading available arc2 weather .tif files for east Africa

One Acre Fund has been using [aWhere](www.awhere.com) for weather data access for the simplicity of their GPS based API. However, we're looking to do more with site GPS and weather data and have not seen aWhere to be a superior product in terms of quality. Therefore we are accesing publically available weather datasets so that we can more easily communicate and share with collaborators on weather data related projects.

This code is the example / starter code for accessing a publically available weather dataset and formatting the data for 1AF's use cases. Eventually we'll be adding these data or [CHIRPS](ftp://ftp.chg.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/africa_daily/tifs/p25/) into the organizational data warehouse so that we can automate extracting long and short term weather averages using site GPS. 
