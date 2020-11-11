
# Package dependencies ----------------------------------------------------

if (FALSE) {
  renv::install("rappster/confx")
  usethis::use_package("confx")

  renv::install("snakecase")
  usethis::use_package("snakecase")

  remotes::install_github("tidyverse/rlang", upgrade = "never")
  remotes::install_github("r-lib/vctrs", upgrade = "never")
  remotes::install_github("tidyverse/dplyr", upgrade = "never")

  usethis::use_package("devtools")
  usethis::use_package("here")
  usethis::use_package("magrittr")

  if (FALSE) {
    # Actual dependencies:
    # renv::install("logger")
  }
}

# renv::activate()

renv::install(
  # Opening RMarkdown docs -----
  "Rcpp",
  "base64enc",
  "glue",
  "highr",
  "jsonlite",
  "magrittr",
  "markdown",
  "mime",
  "rprojroot",
  "stringi",
  "stringr",
  "tinytex",

  # Rendering RMarkdown docs -----
  "digest",
  "evaluate",
  "htmltools",
  "knitr",
  "rmarkdown",
  "yaml",

  # General for package dev -----
  "devtools",
  "testthat",

  # This package -----
  "here",
  "lifecycle",
  "usethis",
  "here",
  "knitr",
  "stringr",

  "gert",
  "gitcreds"
)

# v0.0.0.9000 -------------------------------------------------------------

usethis::use_test("ensure")
usethis::use_test("ensure_good_start")
usethis::use_test("envvars")

