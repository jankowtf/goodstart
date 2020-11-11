test_that("foo.R and test-foo.R", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      when_testing_ensure_example_function_and_unit_test()
    )

  target <- TRUE
  expect_identical(current, target)

  foo_test <- usethis::proj_path("tests/testthat/test-foo.R")
  expect_true(foo_test %>% fs::file_access())

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      "Adding 'testthat' to Suggests field in DESCRIPTION",
      "Creating 'tests/testthat/'",
      "Writing 'tests/testthat.R'",
      "Call `use_test()` to initialize a basic test file and open it for editing.",
      " Writing 'tests/testthat/test-foo.R'",
      "Edit 'tests/testthat/test-foo.R'"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})
