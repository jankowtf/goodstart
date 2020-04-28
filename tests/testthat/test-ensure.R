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

if (FALSE) {
  usethis::proj_path() %>%
    fs::dir_ls()
  usethis::proj_path("R") %>%
    fs::dir_ls()
}

"man" %>%
  usethis::proj_path() %>%
  fs::dir_create()

# usethis::use_testthat()
handle_deps("r-hub/sysreqs", install_if_missing = TRUE)

# Ensure some other stuff -------------------------------------------------

ensure_package("praise")

# Ensure to remove arbitrary file -----------------------------------------

context("Removing arbitrary files")

test_that("File is removed if it exists", {
  # print(usethis::proj_path())
  path <- "test"
  fs::file_create(usethis::proj_path(path))

  # Only seems to work when called interactively:
  if (FALSE) {
    expect_output(
      is <- ensure_removed_file(usethis::proj_path(path)),
      stringr::str_glue("Succesfully removed {usethis::proj_path(path)}") %>%
        stringr::str_replace("\\.", "\\\\.")
    )
  }

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_removed_file(usethis::proj_path(path))
    })
  )

  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_output <- readLines(temp_file)
  expect_match(
    is_output %>% stringr::str_subset("Message"),
    stringr::str_glue("Succesfully removed {usethis::proj_path(path)}") %>%
      stringr::str_replace("\\.", "\\\\.")
  )
})

test_that("File is removed if it doesn't exist", {
  path <- "tests/testthat/dummy.R"

  # Only seems to work when called interactively:
  if (FALSE) {
    expect_output(
      is <- ensure_removed_file(usethis::proj_path(path)),
      stringr::str_glue("{usethis::proj_path(path)} was already removed") %>%
        stringr::str_replace("\\.", "\\\\.")
    )
  }

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_removed_file(usethis::proj_path(path))
    })
  )

  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_output <- readLines(temp_file)
  expect_match(
    is_output %>% stringr::str_subset("Message"),
    stringr::str_glue("{usethis::proj_path(path)} was already removed") %>%
      stringr::str_replace("\\.", "\\\\.")
  )
})

# Remove R/hello.R --------------------------------------------------------

context("Removing R/hello.R")

test_that("R/hello.R is removed if it exists", {
  path <- "R/hello.R"
  fs::file_create(usethis::proj_path(path))

  # Seems to only work when called interactively:
  if (FALSE) {
    expect_output(
      is <- ensure_removed_hello_r(),
      "Succesfully removed R/hello\\.R"
    )
  }

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_removed_hello_r()
    })
  )

  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_output <- readLines(temp_file)
  expect_match(
    is_output %>% stringr::str_subset("Message"),
    "Succesfully removed R/hello\\.R"
  )
})

test_that("R/hello.R is removed if it doesn't exist", {
  # Seems to only work interactively:
  if (FALSE) {
    expect_output(
      is <- ensure_removed_hello_r(),
      "R/hello\\.R was already removed"
    )
    should <- TRUE
    expect_identical(is, should)
  }

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_removed_hello_r()
    })
  )

  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_output <- readLines(temp_file)
  expect_match(
    is_output %>% stringr::str_subset("Message"),
    "R/hello\\.R was already removed"
  )
})

# Remove man/hello.Rd -----------------------------------------------------

context("Removing man/hello.Rd")

test_that("man/hello.Rd is removed if it exists", {
  path <- "man/hello.Rd"
  fs::file_create(usethis::proj_path(path))

  # Seems to only work when called interactively:
  if (FALSE) {
    expect_output(
      is <- ensure_removed_hello_rd(),
      "Succesfully removed man/hello\\.Rd"
    )
    should <- TRUE
    expect_identical(is, should)
  }

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_removed_hello_rd()
    })
  )

  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_output <- readLines(temp_file)
  expect_match(
    is_output %>% stringr::str_subset("Message"),
    "Succesfully removed man/hello\\.Rd"
  )
})

test_that("man/hello.Rd is removed if it doesn't exist", {
  # Only seems to work when called interactively:
  if (FALSE) {
    expect_output(
      is <- ensure_removed_hello_rd(),
      "man/hello\\.Rd was already removed"
    )
    should <- TRUE
    expect_identical(is, should)
  }

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_removed_hello_rd()
    })
  )

  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_output <- readLines(temp_file)
  expect_match(
    is_output %>% stringr::str_subset("Message"),
    "man/hello\\.Rd was already removed"
  )
})

# R/foo.R -----------------------------------------------------------------

context("Ensuring R/foo.R")

test_that("R/hello.R is removed if it exists", {
  path <- "R/foo.R"
  fs::file_create(usethis::proj_path(path))
  expr <-
'#\' Hello world
#\' @param x Hello world
#\' @export
#\' @example
#\' foo()
foo <- function(x = "hello world") x
'
  expr %>% write(usethis::proj_path(path))

  usethis::use_test("foo")

  expect_true(fs::file_exists(usethis::proj_path(path)))
})


# DESCRIPTION -------------------------------------------------------------

context("Modify DESCRIPTION")

test_that("Modify DESCRIPTION: license", {
  # Testing function itself but suppressing shell output:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_gpl3_license()
    })
  )

  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_messages <- readLines(temp_file) %>%
    stringr::str_subset("Message")
  should_messages <- expectations_ensure_gpl3_license()
  check_results <- should_messages %>%
    purrr::map_lgl(
      ~stringr::str_detect(is_messages, .x) %>%
        any()
    )
  # expect_true(all(check_results))
  expect_true(any(check_results))
})

# NAMESPACE: remove default file ------------------------------------------

context("NAMESPACE: remove default file")

test_that("Default NAMESPACE is removed if it exists", {
  "exportPattern(\"^[[:alpha:]]+\")" %>%
    write(usethis::proj_path("NAMESPACE"))

  # Only seems to work when called interactively:
  if (FALSE) {
    expect_output(
      is <- ensure_removed_default_namespace(),
      "Succesfully removed NAMESPACE"
    )
    should <- TRUE
    expect_identical(is, should)
  }

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_removed_default_namespace()
    })
  )

  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_output <- readLines(temp_file)
  expect_match(
    is_output %>% stringr::str_subset("Message"),
    "Succesfully removed NAMESPACE"
  )
})

test_that("Default NAMESPACE is removed if it doesn't exist", {
  # Only seems to work when called interactively:
  if (FALSE) {
    expect_output(
      is <- ensure_removed_default_namespace(),
      "NAMESPACE was already removed"
    )
  }

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_removed_default_namespace()
    })
  )

  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_output <- readLines(temp_file)
  expect_match(
    is_output %>% stringr::str_subset("Message"),
    "NAMESPACE was already removed"
  )
})

# Activate {renv} ---------------------------------------------------------------

context("{renv}")

test_that("{renv} is activated", {
  if (fs::dir_exists(usethis::proj_path("renv"))) {
    usethis::proj_path("renv") %>%
      fs::dir_delete()
  }

  # Only seems to work when called interactively:
  if (FALSE) {
    expect_output(
      is <- ensure_renv_active(),
      "Package \\{renv\\} activated"
    )
    should <- TRUE
    expect_identical(is, should)
  }

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      res <- ensure_renv_active()
    })
  )
  if (FALSE) {
    usethis::proj_path() %>%
      fs::dir_ls() #%>%
    #   write(file = "/home/data/renv.txt")
  }

  is_output <- readLines(temp_file)
  # is_output %>%
  #   write(file = "/home/data/renv.txt")

  should <- TRUE
  expect_identical(res, should)
  expect_true(fs::dir_exists(usethis::proj_path("renv")))
  expect_true(fs::file_exists(usethis::proj_path(".Rprofile")))
  expect_identical(
    readLines(usethis::proj_path(".Rprofile")),
    "source(\"renv/activate.R\")"
  )

  # Testing output/messages:
  is_output <- readLines(temp_file)
  messages <- is_output %>%
    stringr::str_subset("Message")
  # is_output %>%
  #   write(file = "/home/data/renv.txt")
  # should <- if (length(messages) > 1) {
  #   c(
  #     "Failed to find installation of renv",
  #     "Installing renv \\d.*",
  #     "Done!",
  #     "Successfully installed and loaded renv \\d.*",
  #     "Package \\{renv\\} activated"
  #   )
  # } else {
  #   "Package \\{renv\\} activated"
  # }
  # purrr::map2(
  #   messages,
  #   should,
  #   ~expect_match(.x, .y)
  # )

  should <- "Package \\{renv\\} activated"
  purrr::map2(
    messages[length(messages)],
    should,
    ~expect_match(.x, .y)
  )
})

test_that("{renv} is upgraded", {
  # skip("{renv}")
  # Only seems to work when called interactively:
  if (FALSE) {
    expect_output(
      is <- ensure_renv_upgraded(),
      "Package \\{renv\\} upgraded"
    )
  }

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_renv_upgraded()
    })
  )

  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_output <- readLines(temp_file)
  purrr::map2(
    is_output %>%
      stringr::str_subset("Message"),
    c(
      "Package \\{renv\\} upgraded"
    ),
    ~expect_match(.x, .y)
  )
})

# Ensure README -----------------------------------------------------------

context("Ensure README")

test_that("Ensure README.Rmd exists", {
  if (fs::file_exists(usethis::proj_path("README.Rmd"))) {
    usethis::proj_path("README.Rmd") %>%
      fs::file_delete()
  }

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_readme_rmd()
    })
  )

  should <- TRUE
  expect_identical(is, should)
  expect_true(fs::file_exists(usethis::proj_path("README.Rmd")))

  # Testing output/messages:
  is_output <- readLines(temp_file)
  # is_output %>%
  #   write(file = "/home/data/tmp.txt")
  messages <- is_output %>%
    stringr::str_subset("Message")
  should <- if (length(messages) > 2) {
    c(
      "Writing 'README\\.Rmd'",
      "Adding '^README.*",
      "Modify 'README.*'"
    )
  } else {

  }
})

test_that("README.Rmd exists (2)", {
  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_readme_rmd()
    })
  )

  should <- TRUE
  expect_identical(is, should)
  expect_true(fs::file_exists(usethis::proj_path("README.Rmd")))

  # Testing output/messages:
  is_output <- readLines(temp_file)
  purrr::map2(
    is_output %>%
      stringr::str_subset("Message"),
    c(
      "README\\.Rmd already exists"
    ),
    ~expect_match(.x, .y)
  )
})

# Ensure NEWS -------------------------------------------------------------

context("Ensure NEWS")

test_that("NEWS.md exists", {
  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_news_md()
    })
  )

  should <- TRUE
  expect_identical(is, should)
  expect_true(fs::file_exists(usethis::proj_path("NEWS.md")))

  # Testing output/messages:s
  is_output <- readLines(temp_file)
  messages_should <- c(
    "Writing 'NEWS\\.md'"#,
    # "Modify 'NEWS\\.md'" # Only when interactive
  )
  messages_is <- is_output %>%
    stringr::str_subset("Message")
  # messages_is %>%
  #   write("/home/data/news.txt")
  check_results <- messages_should %>%
    purrr::map_lgl(
      ~stringr::str_detect(messages_is, .x) %>%
        any()
    )
  expect_true(all(check_results))
})

# Ensure markdown in roxygen ----------------------------------------------

context("Markdown in {roxygen2} code")

test_that("Markdown in roxygen2 code is enabled", {
  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_roxygen_md()
    })
  )

  should <- TRUE
  expect_identical(is, should)
  description <- readLines(usethis::proj_path("DESCRIPTION"))
  expect_true(description %>%
      stringr::str_detect("Roxygen: list\\(markdown = TRUE\\)") %>%
      any()
  )
  expect_true(description %>%
      stringr::str_detect("RoxygenNote: \\d.*") %>%
      any()
  )
  # expect_true(description %>%
  #     stringr::str_detect("roxygen2") %>%
  #     any()
  # )
  # usethis::proj_path() %>%
  #   fs::path("renv/library/R-3.6/x86_64-pc-linux-gnu/") %>%
  #   fs::dir_ls()
})

# test_that("Markdown in roxygen2 code is enabled (2)", {
#   skip("Not mandatory")
#   is <- ensure_roxygen2md()
#   should <- TRUE
#   expect_identical(is, should)
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

# NAMESPACE: roxygen-based ------------------------------------------------

context("NAMESPACE: roxygen2-based")

test_that("Roxygen2-based NAMESPACE exists", {
  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_roxygen_namespace()
    })
  )
  # is %>% write("/home/data/temp_roxygen_is.txt")
  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_messages <- readLines(temp_file) %>%
    stringr::str_subset("Message")
  # is_messages %>% write("/home/data/temp_roxygen.txt")
  should_messages <- expectations_ensure_roxygen_namespace()
  check_results <- should_messages %>%
    purrr::map_lgl(
      ~stringr::str_detect(is_messages, .x) %>%
        any()
    )
  # expect_true(all(check_results))
  expect_true(any(check_results))

  # Check NAMESPACE content:
  namespace <- readLines(usethis::proj_path("NAMESPACE"))
  expect_true(namespace %>%
      stringr::str_detect("# Generated by roxygen2: do not edit by hand") %>%
      any()
  )
  expect_true(namespace %>%
      stringr::str_detect("export(foo)" %>% handle_regex_escaping()) %>%
      any()
  )

  # Double check default NAMESPACE handling:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_removed_default_namespace()
    })
  )

  should <- FALSE
  expect_identical(is, should)

  is_messages <- readLines(temp_file) %>%
    stringr::str_subset("Message")
  should_messages <- "NAMESPACE generated by {roxygen2}" %>%
    handle_regex_escaping()
  check_results <- should_messages %>%
    purrr::map_lgl(
      ~stringr::str_detect(is_messages, .x) %>%
        any()
    )
  expect_true(all(check_results))
  # expect_true(any(check_results))
})

# Ensure lifecycle package ------------------------------------------------

context("{lifecycle}")

test_that("{lifecycle} exists", {
  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_lifecycle()
    })
  )

  should <- TRUE
  expect_identical(is, should)

  # Check for content inside R/{package_name}-package.R:
  package_name <- get_package_name()
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

  # Check for lifecycle badge in README.Rmd:
  readme <- usethis::proj_path("README.Rmd") %>%
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
})

# GitHub ------------------------------------------------------------------

context("GitHub")

test_that("GitHub is set up correctly", {
  # is <- ensure_github()
  is <- ensure_github(.strict = TRUE)
  should <- TRUE
  expect_identical(is, should)
})

test_that("GitHub actions", {
  is <- ensure_github_actions()
  should <- TRUE
  expect_true(is == "restart" || is == should)
})

# Test coverage -----------------------------------------------------------

context("Test coverage")

test_that("Test coverage", {
  # is <- ensure_coverage()

  # Testing function itself but suppressing shell output:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_coverage()
    })
  )

  # is %>% write(file = "/home/data/temp_coverage.txt")
  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_messages <- readLines(temp_file) %>%
    stringr::str_subset("Message")
  # is_messages %>% write(file = "/home/data/temp_coverage.txt")
  should_messages <- expectations_ensure_coverage()
  check_results <- should_messages %>%
    purrr::map_lgl(
      ~stringr::str_detect(is_messages, .x) %>%
        any()
    )
  # expect_true(all(check_results))
  expect_true(any(check_results))
})

# Knit README -------------------------------------------------------------

context("Knit README")

test_that("Knit README", {
  # is <- ensure_knit_readme()

  # Testing function itself:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_knit_readme()
    })
  )

  should <- TRUE
  expect_identical(is, should)

})

# Ensure vignettes --------------------------------------------------------

context("Vignette setup")

test_that("Vignette setup", {
  # Testing function itself but suppressing shell output:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_vignette()
    })
  )

  # is %>% write(file = "/home/data/test_ensure_vignette_is.txt")
  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_messages <- readLines(temp_file) %>%
    stringr::str_subset("Message")
  # is_messages %>% write(file = "/home/data/test_ensure_vignette_messages.txt")
  should_messages <- expectations_ensure_vignette()
  check_results <- should_messages %>%
    purrr::map_lgl(
      ~stringr::str_detect(is_messages, .x) %>%
        any()
    )
  # expect_true(all(check_results))
  expect_true(any(check_results))
})

# Ensure {pkgdown} --------------------------------------------------------

context("{pkgdown}")

test_that("{pkgdown}", {
    # Testing function itself but suppressing shell output:
  temp_file <- tempfile()
  suppressWarnings(
    verify_output(temp_file, {
      is <- ensure_pkgdown()
    })
  )

  # is %>% write(file = "/home/data/test_ensure_pkgdown_is.txt")
  should <- TRUE
  expect_identical(is, should)

  # Testing output/messages:
  is_messages <- readLines(temp_file) %>%
    stringr::str_subset("Message")
  # is_messages %>% write(file = "/home/data/test_ensure_pkgdown_messages.txt")
  should_messages <- expectations_ensure_pkgdown()
  check_results <- should_messages %>%
    purrr::map_lgl(
      ~stringr::str_detect(is_messages, .x) %>%
        any()
    )
  # expect_true(all(check_results))
  expect_true(any(check_results))
})

# Ensure github push ------------------------------------------------------

context("Push to GitHub")

test_that("Push to GitHub", {
  is <- ensure_github_push()
  should <- TRUE
  expect_identical(is, should)
})
