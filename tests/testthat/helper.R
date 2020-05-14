when_testing_copy_template <- function(
  template_name
) {
  from <- usethis:::find_template(template_name, "goodstart")
  stopifnot(from %>% fs::file_exists())

  to <- usethis::proj_path() %>%
    fs::path(
      "inst",
      "templates"
    ) %>%
    fs::dir_create() %>%
    fs::path(template_name)
  fs::file_copy(from, to, overwrite = TRUE)
  fs::file_exists(to)
}

when_testing_ensure_man_dir <- function() {
  "man" %>%
    usethis::proj_path() %>%
    fs::dir_create()
}

when_testing_load_local_package <- function(
  env = parent.frame()
) {
  devtools::load_all(usethis::proj_path())
  withr::defer(devtools::unload(get_package_name()), env = env)
}

when_testing_ensure_example_function_and_unit_test <- function() {
  path <- "R/foo.R"
  foo <- path %>% usethis::proj_path()
  foo %>% fs::file_create()

  def <-
    '#\' Hello world
#\' @param x Hello world
#\' @export
#\' @example
#\' foo()
foo <- function(x = "hello world") x
'
  def %>% write(foo)

  usethis::use_test("foo", open = FALSE)

  TRUE
}

when_testing_namespace_default <- function() {
  "exportPattern(\"^[[:alpha:]]+\")" %>%
    write("NAMESPACE" %>% usethis::proj_path())
}

when_testing_local_options <- function(
  env = parent.frame()
) {
  old <- options()
  withr::defer(withr:::reset_options(old), envir = env)
}

# Expectations ------------------------------------------------------------

expectations_messages_ <- function(messages, escape = TRUE) {
  if (escape) {
    messages %>%
      handle_regex_escaping()
  } else {
    messages
  }
}

# expectations_ensure_gpl3_license <- function(escape = TRUE) {
#   c(
#     "Setting active project to '/home/data/Code/R/Packages/goodstart'",
#     "Setting License field in DESCRIPTION to 'GPL-3'",
#     "Writing 'LICENSE.md'",
#     "Adding '^LICENSE\\\\.md$' to '.Rbuildignore'"
#   ) %>%
#     expectations_messages_(escape = escape)
# }

expected_messages_ensure_readme_rmd <- function(escape = FALSE) {
  c(
    "Writing 'README.Rmd'",
    "Adding '^README\\\\.Rmd$' to '.Rbuildignore'"
  ) %>%
    expectations_messages_(escape = escape)
}

expected_messages_ensure_readme_md <- function(escape = FALSE) {
  c(
    "Writing 'README.md'"
  ) %>%
    expectations_messages_(escape = escape)
}

expected_messages_ensure_ci_github_actions <- function(escape = TRUE) {
  c(
    "Creating '.github/'",
    "Adding '^\\\\.github$' to '.Rbuildignore'",
    "Adding '*.html' to '.github/.gitignore'",
    "Creating '.github/workflows/'",
    "Writing '.github/workflows/R-CMD-check.yaml'",
    "Adding R build status badge to 'README.Rmd'",
    "Re-knit 'README.Rmd'"
  ) %>%
    expectations_messages_(escape = escape)
}

expectations_ensure_roxygen_namespace <- function(escape = TRUE) {
  c(
    "First time using roxygen2. Upgrading automatically...",
    "Loading goodstarttest",
    "Writing NAMESPACE"
  ) %>%
    expectations_messages_(escape = escape)
}

expecations_ensure_lifecycle <- function(escape = TRUE) {
  c(
    "Succesfully created /tmp/RtmpvW6oLr/testpkg7fb711a73669/R/goodstarttest-package.R",
    "Succesfully created /tmp/RtmpvW6oLr/testpkg7fb711a73669/R/goodstarttest-package.R",
    "Adding 'lifecycle' to Imports field in DESCRIPTION",
    "Copy and paste the following lines into .*",
    "Creating 'man/figures/'",
    "Copied SVG badges to 'man/figures/'",
    "Add badges in documentation topics by inserting one of:",
    "Adding Lifecycle: experimental badge to 'README.Rmd'",
    "Re-knit 'README.Rmd'"
  ) %>%
    expectations_messages_(escape = escape)
}

expected_messages_ensure_unit_testing_test_coverage <- function(escape = TRUE) {
  c(
    "Adding 'covr' to Suggests field in DESCRIPTION",
    "Use `requireNamespace(\"covr\", quietly = TRUE)` to test if package is installed",
    "Then directly refer to functons like `covr::fun()` (replacing `fun()`)"
  ) %>%
    expectations_messages_(escape = escape)
}

expectations_ensure_test_coverage <- function(escape = TRUE) {
  c(
    "Adding 'covr' to Suggests field in DESCRIPTION",
    "Writing 'codecov.yml'",
    "Adding '^codecov\\\\.yml$' to '.Rbuildignore'",
    "Adding Codecov test coverage badge to 'README.Rmd'",
    "Re-knit 'README.Rmd'"
  ) %>%
    expectations_messages_(escape = escape)
}

expectations_ensure_pkgdown <- function(
  scenario = c(
    "before_github_actions",
    "after_github_actions"
  ),
  escape = TRUE
) {
  scenario <- match.arg(scenario)
  messages <- switch(
    scenario,
    before_github_actions = c(
      "Adding '^_pkgdown\\\\.yml$', '^docs$' to '.Rbuildignore'",
      "Adding '^pkgdown$' to '.Rbuildignore'",
      "Adding 'docs' to '.gitignore'",
      # "Writing '_pkgdown.yml'",
      "Edit '_pkgdown.yml'",
      "Creating '.github/'",
      "Adding '^\\\\.github$' to '.Rbuildignore'",
      "Adding '*.html' to '.github/.gitignore'",
      "Creating '.github/workflows/'"
    ),
    after_github_actions = c(
      before_github_actions = c(
        "Adding '^_pkgdown\\\\.yml$', '^docs$' to '.Rbuildignore'",
        "Adding '^pkgdown$' to '.Rbuildignore'",
        "Adding 'docs' to '.gitignore'",
        # "Writing '_pkgdown.yml'",
        "Edit '_pkgdown.yml'"
      )
    )
  )

  messages %>% expectations_messages_(escape = escape)
}

expectations_ensure_vignette <- function(escape = TRUE) {
  c(
    "Adding 'knitr' to Suggests field in DESCRIPTION",
    "Setting VignetteBuilder field in DESCRIPTION to 'knitr'",
    "Adding 'inst/doc' to '.gitignore'",
    "Creating 'vignettes/'",
    "Adding '*.html', '*.R' to 'vignettes/.gitignore'",
    stringr::str_glue("Writing 'vignettes/{get_package_name()}.Rmd'"),
    stringr::str_glue("Edit 'vignettes/{get_package_name()}.Rmd'")
  ) %>%
    expectations_messages_(escape = escape)
}

# Actual test functions ---------------------------------------------------

test_and_record_output <- function(
  path_temp = tempfile(),
  fn
) {
  fn <- rlang::enquo(fn)
  suppressWarnings(
    verify_output(path_temp, {
      is <- rlang::eval_tidy(fn)
    })
  )
  is
}

test_output <- function(
  path,
  output_subset = "Message",
  expected,
  any_all = c("any", "all"),
  escape = FALSE
) {
  stopifnot(fs::file_exists(path))
  any_all <- match.arg(any_all)
  any_all <- get(any_all)

  current <- readLines(path)

  current_subset <- current %>%
    stringr::str_subset(output_subset)

  expected_next <- if (!escape) {
    expected
  } else {
    expected %>%
      handle_regex_escaping()
  }

  inner_results <- expected_next %>%
    purrr::map_lgl(
      ~stringr::str_detect(current_subset, .x) %>%
        any()
    )

  result <- try(expect_true(any_all(inner_results)))
  # if (inherits(result, "try-error")) {
  out <- list(
    result = result,
    inner_results = inner_results,
    current = current,
    expected = expected
  )
  if (!identical(expected, expected_next)) {
    c(
      out,
      list(
        expected_next = expected_next
      )
    )
  } else {
    out
  }
  # } else {
  #   list(
  #     result = result,
  #   )
  # }
}
