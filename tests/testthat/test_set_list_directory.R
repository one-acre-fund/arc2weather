context("set list directory checking")


test_that("set_list_directory returns right directory", {
  expect_equal(set_list_directory("/Users/mlowes/Google Drive/analyses/weather_analyses/arc2_weather_data"), "/Users/mlowes/Google Drive/analyses/weather_analyses/arc2_weather_data/access_lists")
  expect_error(set_list_directory("../arc2_weather_data"))

})

