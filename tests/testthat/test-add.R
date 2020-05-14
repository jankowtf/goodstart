context("Add")

test_that("Add {lifecycle} components to package doc file", {
  pkg <- create_local_package()

  # Testing function itself:
  path_temp <- tempfile()
  is <- test_and_record_output(
    path_temp = path_temp,
    fn = add_lifecycle_to_package_doc()
  )
  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  test_output(
    path = path_temp,
    expected = c(
      "Added '@importFrom lifecycle deprecate_soft' to 'R/testpkg.*-package.R'"
    ),
    escape = FALSE,
    any_all = "all"
  )

  # withr::deferred_run() # For manual reset
  # withr::deferred_clear()
})

test_that("{lifecycle} components already added to package doc file", {
  pkg <- create_local_package()

  # Actually create
  is <- add_lifecycle_to_package_doc()

  # Check result when prior step already took place
  path_temp <- tempfile()
  is <- test_and_record_output(
    path_temp = path_temp,
    fn = add_lifecycle_to_package_doc()
  )
  should <- FALSE
  expect_identical(is, should)

  test_output(
    path = path_temp,
    expected = c(
      "@importFrom lifecycle deprecate_soft' was already added to 'R/testpkg.*-package.R'"
    ),
    any_all = "all"
  )

  # withr::deferred_run() # For manual reset
  # withr::deferred_clear()
})
