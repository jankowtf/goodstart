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

test_that("Get project data", {
  is <- get_project_data()
  should <- c(
    "Package",
    "Type",
    "Title",
    "Version",
    "Authors@R",
    "Description",
    "License",
    "Encoding",
    "LazyData",
    "Suggests",
    "Roxygen",
    "RoxygenNote",
    "Imports",
    "RdMacros",
    "VignetteBuilder",
    "github_owner",
    "github_repo",
    "github_spec"
  )

  expect_true(
    stringr::str_detect(is %>% names(), should) %>%
      most()
  )
})
