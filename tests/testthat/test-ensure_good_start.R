# Environment variables ---------------------------------------------------

Sys.setenv("__GOODSTART_TESTING" = "TRUE")

# Good start --------------------------------------------------------------

context("Ensure good start")

target <- list(
  ensure_removed_hello_r = TRUE,
  ensure_removed_hello_rd = TRUE,
  ensure_dep_management = list(
    ensure_renv_active = TRUE,
    ensure_renv_upgraded = TRUE
  ),
  ensure_unit_testing = TRUE,
  ensure_test_coverage = TRUE,
  ensure_readme_rmd = TRUE,
  ensure_news_md = TRUE,
  ensure_backlog_rmd = TRUE,
  ensure_roxygen = TRUE,
  ensure_removed_namespace_default = TRUE,
  ensure_roxygen_namespace = TRUE,
  ensure_roxygen_md = TRUE,
  ensure_lifecycle = TRUE,
  ensure_github = TRUE,
  ensure_ci = TRUE,
  ensure_ci_test_coverage = TRUE,
  ensure_license = TRUE,
  ensure_knit_readme = TRUE,
  ensure_vignette = TRUE,
  ensure_pkgdown = TRUE,
  ensure_renv_gitignore_state = TRUE,
  ensure_rbuildignore_state = TRUE,
  ensure_github_push = FALSE
)

test_that("Ensure good start but don't push it", {
  pkg <- create_local_package()

  # Preliminaries
  # ensure_package("praise")
  when_testing_load_local_package()
  "R/hello.R" %>% usethis::proj_path() %>% fs::file_create()
  when_testing_ensure_man_dir()
  "man/hello.Rd" %>% usethis::proj_path() %>% fs::file_create()
  when_testing_namespace_default()
  when_testing_ensure_example_function_and_unit_test()

  ensure_removed_file("README.Rmd")
  when_testing_copy_template("package-README")
  when_testing_copy_template("package-BACKLOG")

  # ensure_git_add_all()
  # ensure_git_fetch()
  # ensure_git_commit(message = stringr::str_glue("Before ensemble function ({Sys.time()})"))

  current <- ensure_good_start(
    open = FALSE,
    push_to_github = FALSE
  )

  # length(current)
  # length(target)
  expect_identical(current, target)
})

test_that("Ensure good start and push it", {
  pkg <- create_local_package()

  # Preliminaries
  # ensure_package("praise")
  when_testing_load_local_package()
  "R/hello.R" %>% usethis::proj_path() %>% fs::file_create()
  when_testing_ensure_man_dir()
  "man/hello.Rd" %>% usethis::proj_path() %>% fs::file_create()
  when_testing_namespace_default()
  when_testing_ensure_example_function_and_unit_test()

  ensure_removed_file("README.Rmd")
  when_testing_copy_template("package-README")
  when_testing_copy_template("package-BACKLOG")
  # update(remotes::dev_package_deps(dependencies=TRUE))
  ensure_package("gert")

  # ensure_git_add_all()
  # ensure_git_fetch()
  # ensure_git_commit(message = stringr::str_glue("Before ensemble function ({Sys.time()})"))

  current <- ensure_good_start(
    open = FALSE,
    push_to_github = TRUE
  )

  target$ensure_github_push <- TRUE

  expect_identical(current, target)
})
