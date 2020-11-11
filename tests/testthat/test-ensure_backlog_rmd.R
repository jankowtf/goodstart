test_that("Ensure BACKLOG.Rmd: bare", {
  skip("Keep for reference but doesn't need to run anymore")
  if (fs::file_exists(usethis::proj_path("BACKLOG.Rmd"))) {
    usethis::proj_path("BACKLOG.Rmd") %>%
      fs::file_delete()
  }

  target <- TRUE

  # withr::with(
  #   "goodstarttest",
  #   usethis:::find_template("package-BACKLOG", gs_package_name())
  # )
  devtools::load_all(usethis::proj_path())
  on.exit(devtools::unload("goodstarttest"))

  show_failure(expect_identical(ensure_backlog_rmd(), target))
  expect_true(fs::file_exists(usethis::proj_path("BACKLOG.Rmd")))
})

test_that("Ensure BACKLOG.Rmd", {
  pkg <- create_sandbox_package()

  when_testing_copy_template("package-BACKLOG")
  when_testing_load_local_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_backlog_rmd(open = FALSE)
    )

  target <- TRUE
  backlog <- "BACKLOG.Rmd" %>% usethis::proj_path()
  # names(target) <- backlog
  expect_identical(current, target)
  expect_true(backlog %>% fs::file_exists())

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      "Writing 'BACKLOG.Rmd'",
      "Adding '^BACKLOG\\\\.Rmd$' to '.Rbuildignore'",
      "Created BACKLOG.Rmd"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})
