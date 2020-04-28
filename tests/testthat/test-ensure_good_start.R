# Environment variables ---------------------------------------------------

ensure_env_vars(
  list(
    GITHUB_USERNAME = "rappster"
  )
)

Sys.setenv("__GOODSTART_TESTING" = "TRUE")

# Create temporary package ------------------------------------------------

# usethis::proj_set(pkg)
pkg <- scoped_temporary_package()
usethis::use_git()

if (FALSE) {
  usethis::proj_path() %>%
    fs::dir_ls()
  usethis::proj_path("R") %>%
    fs::dir_ls()
}

"man" %>%
  usethis::proj_path() %>%
  fs::dir_create()

# Ensure some other stuff -------------------------------------------------

ensure_package("praise")

# Good start --------------------------------------------------------------

context("Ensure good start")

test_that("Ensure good start", {
  skip("Soon")
  fs::file_create(usethis::proj_path("R/hello.R"))
    fs::file_create(usethis::proj_path("man/hello.Rd"))
  fs::file_create(usethis::proj_path("NAMESPACE"))

  ensure_git_add_all()
  ensure_git_fetch()
  ensure_git_commit(message = stringr::str_glue("Before ensemble function ({Sys.time()})"))

  is <- ensure_good_start()

  should <- list(
    ensure_removed_hello_r = TRUE,
    ensure_removed_hello_rd = TRUE,
    ensure_removed_default_namespace = TRUE,
    ensure_renv_active = TRUE,
    ensure_renv_upgraded = TRUE,
    ensure_readme_rmd = TRUE,
    ensure_news_md = TRUE,
    ensure_roxygen_md = TRUE,
    ensure_roxygen_namespace = TRUE,
    ensure_lifecycle = TRUE,
    ensure_github = TRUE,
    ensure_github_actions = TRUE,
    ensure_coverage = TRUE,
    ensure_knit_readme = TRUE
  )

  expect_identical(is, should)
})

test_that("Good start if files do not exist", {
  skip("Not ready yet")
  expect_output(
    is <- ensure_a_good_start(),
    "R/hello\\.R was already removed"
  )
  expect_output(
    is <- ensure_a_good_start(),
    "man/hello\\.Rd was already removed"
  )
  should <- list(
    ensure_removed_hello_r = TRUE,
    ensure_removed_hello_rd = TRUE,
    ensure_renv_active = TRUE,
    ensure_renv_upgraded = TRUE,
    ensure_readme_rmd = TRUE,
    ensure_news_md = TRUE
  )
  expect_identical(is, should)
})
