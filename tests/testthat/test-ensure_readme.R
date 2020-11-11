test_that("Ensure README if not existing (default -> rmd)", {
  pkg <- create_sandbox_package()
  when_testing_copy_template("package-README")

  readme <- usethis::proj_path("README.Rmd")

  # Ensure that there's definitely no existing README
  readme %>%
    ensure_removed_file()
  expect_false(
    readme %>%
      fs::file_exists()
  )

  # Temporarily actually load the test package
  when_testing_load_local_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- suppressMessages(
    path_temp %>%
      test_and_record_output(
        ensure_readme(open = FALSE, strict = TRUE)
      )
  )

  # current <- suppressMessages(
  #   ensure_readme(open = FALSE, strict = TRUE)
  # )
  # current_msgs <- expect_snapshot_output(
  #   current <- ensure_readme(open = FALSE, strict = TRUE)
  # )

  target <- TRUE
  expect_identical(current, target)
  expect_true(fs::file_exists(readme))

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = expected_messages_ensure_readme_rmd(escape = TRUE),
    any_all = "all",
    escape = FALSE
  )

  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("Ensure README if existing: rmd (default)", {
  pkg <- create_sandbox_package()
  when_testing_copy_template("package-README")

  readme <- usethis::proj_path("README.Rmd")
  readme %>%
    ensure_removed_file()

  # Temporarily actually load the test package
  when_testing_load_local_package()
  ensure_readme(open = FALSE)

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_readme(open = FALSE)
    )

  target <- TRUE
  expect_identical(current, target)
  expect_true(fs::file_exists(readme))

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      "README.Rmd already exists"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("Ensure README.md if not existing", {
  pkg <- create_sandbox_package()
  when_testing_copy_template("package-README.md")

  readme <- usethis::proj_path("README.Rmd")
  readme %>%
    ensure_removed_file()
  readme <- usethis::proj_path("README.md")
  readme %>%
    ensure_removed_file()
  expect_false(
    readme %>%
      fs::file_exists()
  )

  # Temporarily actually load the test package
  when_testing_load_local_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_readme(type = valid_readme_types("md"), open = FALSE, strict = TRUE)
    )

  target <- TRUE
  expect_identical(current, target)
  expect_true(fs::file_exists(readme))

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = expected_messages_ensure_readme_md(escape = TRUE),
    any_all = "all",
    escape = FALSE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})
