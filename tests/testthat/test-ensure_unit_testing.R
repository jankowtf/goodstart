test_that("Ensure unit testing with defaults", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_unit_testing()
    )

  target <- TRUE
  expect_identical(current, target)
  expect_true(fs::dir_exists(usethis::proj_path("tests/testthat")))

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      "Adding 'testthat' to Suggests field in DESCRIPTION",
      "Creating 'tests/testthat/'",
      "Writing 'tests/testthat.R'",
      "Call `use_test()` to initialize a basic test file and open it for editing."
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("Ensure {testthat}", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_unit_testing_testthat()
    )

  target <- TRUE
  expect_identical(current, target)
  expect_true(fs::dir_exists(usethis::proj_path("tests/testthat")))

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      "Adding 'testthat' to Suggests field in DESCRIPTION",
      "Creating 'tests/testthat/'",
      "Writing 'tests/testthat.R'",
      "Call `use_test()` to initialize a basic test file and open it for editing."
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})
