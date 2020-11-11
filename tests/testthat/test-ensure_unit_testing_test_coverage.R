withr::deferred_run()

test_that("Ensure unit testing with defaults", {
  pkg <- create_sandbox_package()

  ensure_unit_testing_testthat()
  when_testing_ensure_example_function_and_unit_test()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_unit_testing_test_coverage()
    )

  target <- TRUE
  expect_identical(current, target)

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = expected_messages_ensure_unit_testing_test_coverage(),
    any_all = "all"
  )
  if (inherits(result$result, "try-error")) {
    print(result)
  }
  expect_true(!inherits(result$result, "try-error"))
})
