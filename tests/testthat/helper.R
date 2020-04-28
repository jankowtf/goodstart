
scoped_temporary_package <- function(
  dir = fs::file_temp(pattern = "testpkg"),
  env = parent.frame(),
  rstudio = FALSE
) {
  scoped_temporary_thing(dir, env, rstudio, "package")
}

scoped_temporary_thing <- function(
  dir = fs::file_temp(pattern = pattern),
  env = parent.frame(),
  rstudio = FALSE,
  thing = c("package", "project")) {
  thing <- match.arg(thing)
  if (fs::dir_exists(dir)) {
    usethis::ui_stop("Target {usethis::ui_code('dir')} {usethis::ui_path(dir)} already exists.")
  }

  old_project <- usethis:::proj_get_()
  ## Can't schedule a deferred project reset if calling this from the R
  ## console, which is useful when developing tests
  if (identical(env, globalenv())) {
    usethis::ui_done("Switching to a temporary project!")
    if (!is.null(old_project)) {
      command <- paste0('proj_set(\"', old_project, '\")')
      usethis::ui_todo(
        "Restore current project with: {usethis::ui_code(command)}"
      )
    }
  } else {
    withr::defer({
      usethis::ui_silence({
        proj_set(old_project, force = TRUE)
      })
      setwd(old_project)
      fs::dir_delete(dir)
    }, envir = env)
  }

  usethis::ui_silence({
    switch(thing,
      package = usethis::create_package(dir, fields = list(Package = "goodstarttest"),
        rstudio = rstudio, open = FALSE, check_name = FALSE),
      project = usethis::create_project(dir, rstudio = rstudio, open = FALSE)
    )
    usethis::proj_set(dir)
  })
  setwd(dir)
  invisible(dir)
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

expectations_ensure_gpl3_license <- function(escape = TRUE) {
  c(
    "Setting active project to '/home/data/Code/R/Packages/goodstart'",
    "Setting License field in DESCRIPTION to 'GPL-3'",
    "Writing 'LICENSE.md'",
    "Adding '^LICENSE\\\\.md$' to '.Rbuildignore'"
  ) %>%
    expectations_messages_(escape = escape)
}

expectations_ensure_roxygen_namespace <- function(escape = TRUE) {
  c(
    "First time using roxygen2. Upgrading automatically...",
    # "Writing NAMESPACE",
    "Loading goodstarttest"
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

expectations_ensure_coverage <- function(escape = TRUE) {
  c(
    "Adding 'covr' to Suggests field in DESCRIPTION",
    "Writing 'codecov.yml'",
    "Adding '^codecov\\.yml$' to '.Rbuildignore'",
    "Adding Codecov test coverage badge to 'README.Rmd'",
    "Re-knit 'README.Rmd'"
  ) %>%
    expectations_messages_(escape = escape)
}

expectations_ensure_pkgdown <- function(escape = TRUE) {
  c(
    "Adding '^_pkgdown\\.yml$', '^docs$' to '.Rbuildignore'",
    "Adding '^pkgdown$' to '.Rbuildignore'",
    "Writing '_pkgdown.yml'",
    "Modify '_pkgdown.yml'"
  ) %>%
    expectations_messages_(escape = escape)
}

expectations_ensure_vignette <- function(escape = TRUE) {
  c(
    "Adding 'knitr' to Suggests field in DESCRIPTION",
    "Setting VignetteBuilder field in DESCRIPTION to 'knitr'",
    "Adding 'inst/doc' to '.gitignore'",
    "Creating 'vignettes/'",
    "Adding '*.html', '*.R' to 'vignettes/.gitignore'",
    "Writing 'vignettes/foo.Rmd'",
    "Modify 'vignettes/foo.Rmd'"
  ) %>%
    expectations_messages_(escape = escape)
}


