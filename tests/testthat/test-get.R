test_that("Get package name", {
  current <- gs_package_name()
  target <- "goodstart"
  expect_identical(current, target)
})

test_that("Get package version", {
  current <- gs_package_version()
  target <- "\\d\\.\\d\\.\\d\\.?\\d?"
  expect_match(current, target)
})

test_that("Get project data", {
  current <- gs_project_data()
  target <- c(
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
    stringr::str_detect(current %>% names(), target) %>%
      most()
  )
})
