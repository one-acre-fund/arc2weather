context("get current list file exists check")

df <- readRDS(paste("/Users/mlowes/Google Drive/analyses/weather_analyses/arc2_weather_data/access_lists", "full_list.rds", sep = "/"))

test_that("the full list.rds file exists", {
  expect_equal(file.exists("/Users/mlowes/Google Drive/analyses/weather_analyses/arc2_weather_data/access_lists/full_list.rds"), TRUE)
  expect_is(df, "data.frame") # explicitly uses data set I know works.

})

