context("date_df_creator")


test_that("date_df_creator returns the right numbers", {
  expect_equal(date_df_creator("20180519dateandfillerinfo"), data.frame(numbers = 20180519, year = 2018, month = 5, day = 19))
  expect_equal(date_df_creator("19970109textandsurrouding"), data.frame(numbers = 19970109, year = 1997, month = 1, day = 9))
  expect_equal(date_df_creator("abcd1980117newtext"), data.frame(numbers = 1980117, year = 1980, month = 11, day = 7))

})

