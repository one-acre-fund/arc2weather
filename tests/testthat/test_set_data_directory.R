context("data directory checking")


test_that("set_data_directory returns right directory", {
  expect_equal(set_data_directory("/Users/mlowes/Google Drive/analyses/weather_analyses/arc2_weather_data"), "/Users/mlowes/Google Drive/analyses/weather_analyses/arc2_weather_data/raw_data")
  expect_error(set_data_directory("/Users/mlowes/Google Drive/analyses/weather_analyses"))
})

