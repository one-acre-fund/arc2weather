context("full list data access")


test_that("full list accesses website", {
  expect_is(get_full_list(), "data.frame") # maybe find another test since this requires internet connetion


})

