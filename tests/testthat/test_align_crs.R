context("testing CRS input formats")

r <- list(raster::raster(matrix(rnorm(400),20,20)),
          raster::raster(matrix(rnorm(400),20,20)))

suppressWarnings(require(sp))                       # spatial library
data(meuse)                       # load built in dataset

# prepare the 3 components: coordinates, data, and proj4string
coords <- meuse[ , c("x", "y")]   # coordinates
data   <- meuse[ , 3:14]          # data
crs    <- CRS("+init=epsg:28992") # proj4string of coords

# make the spatial points data frame object
spdf <- SpatialPointsDataFrame(coords = coords,
                               data = data,
                               proj4string = crs)

test_that("align_crs receives the velox input", {
  expect_error(align_crs(r, spdf), "veloxRaster object needs to be a velox object. First convert to Velox")
})

# test_that("align_crs receives spdf input"){
#   expect_error(align_crs(velox(r[[1]]), data) )
# }
