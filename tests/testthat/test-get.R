context("Get DESCRIPTION values")

test_that("Get package name", {
  is <- get_package_name()
  should <- "goodstart"
  expect_identical(is, should)
})

test_that("Get package version", {
  is <- get_package_version()
  should <- "\\d\\.\\d\\.\\d\\.?\\d?"
  expect_match(is, should)
})
