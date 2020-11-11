# Environment variables ---------------------------------------------------

context("Preliminaries: environment variables")

Sys.setenv("__GOODSTART_TESTING" = "TRUE")

# Create temporary package ------------------------------------------------

# test_that("Man directory exist", {
#   current <- when_testing_ensure_man_dir()
#   expect_true(current %>% fs::dir_exists())
# })

# usethis::use_testthat()
# handle_deps("r-hub/sysreqs", install_if_missing = TRUE)

# Ensure some other stuff -------------------------------------------------

ensure_package("praise")

test_that("Package templates exist", {
  current <- when_testing_copy_template("package-README")
  expect_true(current %>% names() %>% fs::file_exists())
  current <- when_testing_copy_template("package-BACKLOG")
  expect_true(current %>% names() %>% fs::file_exists())
})

# Ensure to remove arbitrary file -----------------------------------------

context("Removing arbitrary files")

test_that("Remove file if existing", {
  pkg <- create_sandbox_package()

  path <- "test"
  fs::file_create(usethis::proj_path(path))

  # Only seems to work when called interactively:
  if (FALSE) {
    expect_output(
      current <- ensure_removed_file(usethis::proj_path(path)),
      stringr::str_glue("Succesfully removed {usethis::proj_path(path)}") %>%
        stringr::str_replace("\\.", "\\\\.")
    )
  }

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_removed_file(path %>% usethis::proj_path())
    )

  target <- TRUE
  expect_identical(current, target)
  expect_true(!fs::file_exists(path %>% usethis::proj_path()))

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      stringr::str_glue("Succesfully removed {usethis::proj_path(path)}")
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }

  # withr::deferred_run()
})

test_that("Remove file that isn't existing", {
  pkg <- create_sandbox_package()

  path <- "tests/testthat/dummy.R"

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_removed_file(path %>% usethis::proj_path())
    )

  target <- TRUE
  expect_identical(current, target)
  expect_true(!fs::file_exists(path %>% usethis::proj_path()))

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      stringr::str_glue("{usethis::proj_path(path)} was already removed")
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

# Remove R/hello.R --------------------------------------------------------

context("Removing R/hello.R")

test_that("Remove R/hello.R if existing", {
  pkg <- create_sandbox_package()

  hello <- "R/hello.R" %>% usethis::proj_path()
  hello %>% fs::file_create()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_removed_hello_r()
    )

  target <- TRUE
  expect_identical(current, target)
  expect_true(!hello %>% fs::file_exists())

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      "Succesfully removed R/hello.R"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("Remove R/hello.R if not existing", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_removed_hello_r()
    )

  target <- TRUE
  expect_identical(current, target)
  hello <- "R/hello.R" %>% usethis::proj_path()
  expect_true(!hello %>% fs::file_exists())

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      "R/hello.R was already removed"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

# Remove man/hello.Rd -----------------------------------------------------

context("Removing man/hello.Rd")

test_that("Remove 'man/hello.Rd' if existing", {
  pkg <- create_sandbox_package()

  path <- "man/hello.Rd"
  hello <- path %>%
    usethis::proj_path()
  hello %>%
    fs::path_dir() %>%
    fs::dir_create()
  hello %>%
    fs::path_dir() %>%
    fs::dir_exists()
  hello %>%
    fs::file_create()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_removed_hello_rd()
    )

  target <- TRUE
  expect_identical(current, target)
  expect_true(!hello %>% fs::file_exists())

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      "Succesfully removed man/hello.Rd"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("Remove 'man/hello.Rd' if not existing", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_removed_hello_rd()
    )

  target <- TRUE
  expect_identical(current, target)
  hello <- "R/hello.R" %>% usethis::proj_path()
  expect_true(!hello %>% fs::file_exists())

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      "man/hello.Rd was already removed"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

# Ensure license ----------------------------------------------------------

context("Ensure license")

test_that("Ensure GPL-3 license", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_license()
    )

  target <- TRUE
  expect_identical(current, target)
  target <- c(License = "GPL-3")
  expect_identical(desc::desc_get("License"), target)

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      "Setting License field in DESCRIPTION to 'GPL-3'",
      "Writing 'LICENSE.md'",
      "Adding '^LICENSE\\\\.md$' to '.Rbuildignore'"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("Ensure MIT license", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_license("mit")
    )

  target <- TRUE
  expect_identical(current, target)
  target <- c(License = "MIT + file LICENSE")
  expect_identical(desc::desc_get("License"), target)

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      "Setting License field in DESCRIPTION to 'MIT + file LICENSE'",
      "Writing 'LICENSE.md'",
      "Adding '^LICENSE\\\\.md$' to '.Rbuildignore'",
      "Writing 'LICENSE'"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("Ensure invalid license", {
  skip("Not working as planned yet. Refactor 'test_and_record_output")
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_license("abc", strict = TRUE)
    )

  target <- TRUE
  expect_identical(current, target)

  # Testing output/messages:
  result <- test_output(
    path = path_temp,
    expected = c(
      "Setting License field in DESCRIPTION to 'MIT + file LICENSE'",
      "Writing 'LICENSE.md'",
      "Adding '^LICENSE\\\\.md$' to '.Rbuildignore'",
      "Writing 'LICENSE'"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

# Ensure dependency management --------------------------------------------

context("Ensure dependency management: {renv} (default)")

test_that("Ensure dependency management: {renv} (default)", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_dependency_management()
    )

  target <- list(
    ensure_renv_active = TRUE,
    ensure_renv_upgraded = TRUE
  )
  expect_identical(current, target)
  expect_true(fs::dir_exists(usethis::proj_path("renv")))
  expect_true(fs::file_exists(usethis::proj_path(".Rprofile")))
  expect_identical(
    readLines(usethis::proj_path(".Rprofile")),
    "source(\"renv/activate.R\")"
  )

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      "Project.*loaded.*",
      "Package .*renv.* activated"
    ),
    any_all = "any"#,
    # escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

context("Dependency management: {renv} (explicit)")

test_that("{renv} is activated", {
  pkg <- create_sandbox_package()

  renv <- "renv" %>% usethis::proj_path()
  if (renv %>% fs::dir_exists()) {
    renv %>% fs::dir_delete()
  }

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_renv_active()
    )

  target <- TRUE
  expect_identical(current, target)
  expect_true(fs::dir_exists(usethis::proj_path("renv")))
  expect_true(fs::file_exists(usethis::proj_path(".Rprofile")))
  expect_identical(
    readLines(usethis::proj_path(".Rprofile")),
    "source(\"renv/activate.R\")"
  )

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      "Project.*loaded.*",
      "Package .*renv.* activated"
    ),
    any_all = "any"#,
    # escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("{renv} is upgraded", {
  pkg <- create_sandbox_package()

  renv <- "renv" %>% usethis::proj_path()
  if (renv %>% fs::dir_exists()) {
    renv %>% fs::dir_delete()
  }
  ensure_renv_active()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_renv_upgraded()
    )

  target <- TRUE
  expect_identical(current, target)

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      "renv .* is already installed and active for this project",
      "Package .*renv.* upgraded"
    ),
    any_all = "any"#,
    # escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})







# Ensure NEWS -------------------------------------------------------------

context("Ensure NEWS")

test_that("Ensure NEWS.md", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_news_md(open = FALSE)
    )

  target <- TRUE
  expect_identical(current, target)
  expect_true(fs::file_exists(usethis::proj_path("NEWS.md")))

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      "Writing 'NEWS.md'"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("Ensure NEWS.md if already existing", {
  pkg <- create_sandbox_package()

  ensure_news_md(open = FALSE)

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_news_md(open = FALSE)
    )
  # TODO-20200502T1642: This target be FALSE in case NEWS.md already exists

  target <- TRUE
  expect_identical(current, target)
  expect_true(fs::file_exists(usethis::proj_path("NEWS.md")))

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      # "Writing 'NEWS.md'"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})


# Ensure roxygen ----------------------------------------------------------

context("Ensure roxygen")

test_that("Enable roxygen", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_roxygen()
    )

  target <- TRUE
  expect_identical(current, target)

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      "Adding 'roxygen2' to Suggests field in DESCRIPTION",
      # "Increasing 'roxygen2' version to '>= 7.1.0' in DESCRIPTION",
      "Use `requireNamespace(\"roxygen2\", quietly = TRUE)` to test if package is installed",
      "Then directly refer to functons like `roxygen2::fun()` (replacing `fun()`)."
      # "Run `devtools::document()`"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

# Ensure markdown in roxygen ----------------------------------------------

context("Ensure Markdown in {roxygen2} code")

test_that("Enable markdown in roxygen2 code", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_roxygen_md()
    )

  target <- TRUE
  expect_identical(current, target)
  description <- readLines(usethis::proj_path("DESCRIPTION"))
  expect_true(description %>%
      stringr::str_detect("Roxygen: list\\(markdown = TRUE\\)") %>%
      any()
  )
  expect_true(description %>%
      stringr::str_detect("RoxygenNote: \\d.*") %>%
      any()
  )
})

# test_that("Markdown in roxygen2 code is enabled (2)", {
#   skip("Not mandatory")
#   current <- ensure_roxygen2md()
#   target <- TRUE
#   expect_identical(current, target)
#   description <- readLines(here::here("DESCRIPTION"))
#   expect_true(description %>%
#       stringr::str_detect("Roxygen: list\\(markdown = TRUE\\)") %>%
#       any()
#   )
#   expect_true(description %>%
#       stringr::str_detect("RoxygenNote: \\d.*") %>%
#       any()
#   )
#   expect_true(description %>%
#       stringr::str_detect("roxygen2") %>%
#       any()
#   )
# })

# NAMESPACE: remove default file ------------------------------------------

context("NAMESPACE: remove default file")

test_that("Remove default NAMESPACE if existing", {
  pkg <- create_sandbox_package()

  when_testing_namespace_default()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_removed_namespace_default()
    )

  target <- TRUE
  expect_identical(current, target)

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      "Succesfully removed NAMESPACE"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("Remove default NAMESPACE if not existing", {
  pkg <- create_sandbox_package()

  "exportPattern(\"^[[:alpha:]]+\")" %>%
    write(usethis::proj_path("NAMESPACE"))

  ensure_removed_namespace_default()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_removed_namespace_default()
    )

  target <- TRUE
  expect_identical(current, target)

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      "NAMESPACE was already removed"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("Remove default NAMESPACE if not existing (2)", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_removed_namespace_default()
    )

  target <- FALSE
  expect_identical(current, target)

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      "NAMESPACE generated by {roxygen2}"
    ),
    any_all = "all",
    escape = TRUE
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})



# Ensure {lifecycle} ------------------------------------------------------

context("Ensure {lifecycle}")

test_that("{lifecycle} exists", {
  pkg <- create_sandbox_package()

  when_testing_copy_template("package-README")
  when_testing_load_local_package()
  ensure_readme_rmd(open = FALSE)

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_lifecycle()
    )

  target <- TRUE
  expect_identical(current, target)

  # Check for content inside R/{package_name}-package.R:
  package_name <- gs_package_name()
  file_name <- stringr::str_glue("{package_name}-package.R")
  expect_true(
    usethis::proj_path("R", file_name) %>%
      fs::file_exists()
  )
  expect_true(
    length(
      readLines(usethis::proj_path("R", file_name))
    ) > 0
  )

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = c(
      stringr::str_glue("Succesfully created .*/R/{package_name}-package\\.R"),
      stringr::str_glue("Added '@importFrom lifecycle deprecate_soft' to 'R/{package_name}-package\\.R'")
    ),
    any_all = "all"
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }

  if (FALSE) {
    # Check for lifecycle badge in README.Rmd:
    readme <- "README.Rmd" %>%
      usethis::proj_path() %>%
      readLines()
    expect_true(
      readme %>%
        stringr::str_detect(
          "https://www.tidyverse.org/lifecycle" %>%
            handle_regex_escaping()
        ) %>%
        any()
    )

    # Testing output/messages:
    is_messages <- readLines(temp_file) %>%
      stringr::str_subset("Message")
    should_messages <- expecations_ensure_lifecycle()
    check_results <- should_messages %>%
      purrr::map_lgl(
        ~stringr::str_detect(is_messages, .x) %>%
          any()
      )
    # expect_true(all(check_results))
    expect_true(any(check_results))
  }
  # TODO-20200503T0115: Align testing {lifecycle} behavior when README.Rmd exists
})

# Ensure CI platform ------------------------------------------------------

context("Ensure CI platform")

test_that("Ensure CI platform: GitHub Actions (default)", {
  pkg <- create_sandbox_package()

  # Ensure README
  when_testing_copy_template("package-README")
  when_testing_load_local_package()
  ensure_readme_rmd(open = FALSE)

  # Ensure GitHub
  ensure_env_vars(
    list(
      GITHUB_USERNAME = "rappster"
    )
  )
  ensure_github(strict = TRUE)

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_ci()
    )

  target <- TRUE
  expect_identical(current, target)

  # Check content of README.Rmd for badges
  readme_content <- "README.Rmd" %>%
    usethis::proj_path() %>%
    read_utf8()
  block_bounds <- readme_content %>%
    block_find("<!-- badges: start -->", "<!-- badges: end -->")
  badges_content <- readme_content %>%
    block_get(block_bounds = block_bounds)
  expect_true(
    badges_content %>%
      stringr::str_detect("R build status") %>%
      any()
  )

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = expected_messages_ensure_ci_github_actions(),
    any_all = "all"
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

# Ensure CI test coverage service -----------------------------------------

context("Ensure CI test coverage service")

test_that("CI test coverage", {
  pkg <- create_sandbox_package()

  ensure_env_vars(
    list(
      GITHUB_USERNAME = "rappster"
    )
  )

  when_testing_load_local_package()
  when_testing_copy_template("package-README")
  ensure_readme_rmd(open = FALSE, strict = TRUE)
  ensure_github()
  ensure_github_actions()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_ci_test_coverage_()
    )

  target <- TRUE
  expect_identical(current, target)

  # Check if workflow file exists
  path <- ".github/workflows/R-CMD-check.yaml" %>%
    fs::path()
  expect_true(
    path %>%
      usethis::proj_path() %>%
      fs::file_exists()
  )
  expect_true(
    length(
      readLines(path %>% usethis::proj_path())
    ) > 0
  )

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = expectations_ensure_test_coverage(escape = TRUE),
    any_all = "all"
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

# Ensure vignettes --------------------------------------------------------

context("Ensure vignette setup")

test_that("Vignette setup", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_vignette()
    )

  target <- TRUE
  expect_identical(current, target)

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = expectations_ensure_vignette(),
    any_all = "all"
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

# Ensure {pkgdown} --------------------------------------------------------

context("Ensure {pkgdown}")

test_that("{pkgdown}", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_pkgdown()
    )

  target <- TRUE
  expect_identical(current, target)

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = expectations_ensure_pkgdown(),
    any_all = "all"
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

test_that("{pkgdown} with prior GitHub Actions", {
  pkg <- create_sandbox_package()

  ensure_env_vars(
    list(
      GITHUB_USERNAME = "rappster"
    )
  )
  ensure_github()
  ensure_github_actions()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_pkgdown()
    )

  target <- TRUE
  expect_identical(current, target)

  # Testing output/messages
  result <- test_output(
    path = path_temp,
    expected = expectations_ensure_pkgdown("after_github_actions"),
    any_all = "all"
  )
  expect_true(!inherits(result$result, "try-error"))
  if (inherits(result$result, "try-error")) {
    print(result)
  }
})

# Ensure knitted README.Rmd -----------------------------------------------

context("Ensure knitted README.Rmd")

test_that("Knit README", {
  pkg <- create_sandbox_package()

  when_testing_load_local_package()
  when_testing_copy_template("package-README")
  ensure_readme_rmd(open = FALSE, strict = TRUE)

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_knit_readme()
    )

  target <- TRUE
  expect_identical(current, target)
  path <- "README.md" %>%
    usethis::proj_path()
  expect_true(
    path %>%
      fs::file_exists()
  )
})

# Ensure state of ignore files --------------------------------------------

context("Ensure correct state of ignore files")

test_that("renv/.gitignore", {
  pkg <- create_sandbox_package()

  ensure_renv_active()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_renv_gitignore_state()
    )

  target <- TRUE
  expect_identical(current, target)
  expect_true(
    "renv/.gitignore" %>%
      usethis::proj_path() %>%
      fs::file_exists()
  )
})

test_that(".Rbuildignore", {
  pkg <- create_sandbox_package()

  # Testing function itself
  path_temp <- tempfile()
  current <- path_temp %>%
    test_and_record_output(
      ensure_rbuildignore_state()
    )

  target <- TRUE
  expect_identical(current, target)


  rbuildignore_content <- ".Rbuildignore" %>%
    usethis::proj_path() %>%
    read_utf8()
  target <- c(
    "^renv$",
    "^renv\\.lock$",
    "^\\.*\\.Rproj$",
    "^\\.Rproj\\.user$",
    "^README\\.Rmd$",
    "^BACKLOG\\.Rmd$",
    "^codecov\\.yml$",
    "^\\.github$",
    "^LICENSE\\.md$",
    "^_pkgdown\\.yml$",
    "^docs$",
    "^pkgdown$",
    "^data$",
    "^scripts$",
    "^build\\.R$"
  )
  expect_identical(rbuildignore_content, target)
})

# Ensure github push ------------------------------------------------------

context("Ensure push to GitHub remote")

test_that("Push to GitHub", {
  skip("Postponed")
  current <- ensure_github_push()
  target <- TRUE
  expect_identical(current, target)
})
