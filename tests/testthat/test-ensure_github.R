test_that("GitHub is set up correctly", {
  pkg <- create_sandbox_package()

  ensure_env_vars(
    list(
      GS_GITHUB_USERNAME = "rappster"
    )
  )

  # current <- ensure_github()
  current <- ensure_github(strict = TRUE)
  target <- TRUE
  expect_identical(current, target)
})
