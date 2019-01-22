# context("convert_spdf")
#
# df <- data.frame(lat = rnorm(100, 0, 1), lon = rnorm(100, 0, 1))
#
# test_that("CRS is null if none is provided in resulting spdf", {
#   expect_error(convert_spdf(df), "df is a data.frame. Please indicate the lat/lon variables")
# })
#
