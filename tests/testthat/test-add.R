test_that("Add {lifecycle} components to package doc file", {
  pkg <- create_sandbox_package()

  # Testing function itself:
  path_temp <- tempfile()
  current <- test_and_record_output(
    path_temp = path_temp,
    fn = add_lifecycle_to_package_doc()
  )
  target <- TRUE
  expect_identical(current, target)

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      expected_messages_add_lifecycle_to_package_doc()
    ),
    escape = FALSE,
    any_all = "all"
  )

  if (inherits(result$result, "try-error")) {
    print(result)
  }
  expect_true(!inherits(result$result, "try-error"))

  # withr::deferred_run() # For manual reset
  # withr::deferred_clear()
})

test_that("{lifecycle} components already added to package doc file", {
  pkg <- create_sandbox_package()

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

  result <- test_output(
    path = path_temp,
    expected = expected_messages_add_lifecycle_to_package_doc_if_already_added(),
    any_all = "all"
  )

  if (inherits(result$result, "try-error")) {
    print(result)
  }
  expect_true(!inherits(result$result, "try-error"))

  # withr::deferred_run() # For manual reset
  # withr::deferred_clear()
})
