#' @importFrom fs is_absolute_path
#' @importFrom here here
#' @importFrom usethis proj_path
handle_path <- function(path = ".") {
  testing <- global__get_env_var_testing()
  path <- ifelse(
    !fs::is_absolute_path(path),
    ifelse(!testing, here::here(path), usethis::proj_path(path)),
    path
  )
}

#' @importFrom fs path
get_package_name <- function(package = ".") {
  path <- fs::path(package, "DESCRIPTION")

  description <- path %>%
    read.dcf()

  description[1 , "Package"] %>%
    unname()
}

#' @importFrom fs path
get_package_version <- function(package = ".") {
  path <- fs::path(package, "DESCRIPTION")

  description <- path %>%
    read.dcf()

  description[1 , "Version"] %>%
    unname()
}

handle_return_value <- function(
  out,
  result,
  message,
  .strict = FALSE
) {
  if (!.strict) {
    out
  } else {
    if (!out) {
      message(result)
      stop(message)
    } else {
      out
    }
  }
}

#' @importFrom knitr knit
knit_readme <- function() {
  knitr::knit(
    input = "README.Rmd" %>%
      handle_path(),
    output = "README.md" %>%
      handle_path()
  )
}

#' @import usethis
handle_deps <- function(
  deps,
  install_if_missing = FALSE
) {
  if (!length(deps)) {
    return(TRUE)
  }
  deps %>%
    purrr::map(function(.dep) {
      if (!usethis:::is_installed(.dep)) {
        if (!install_if_missing) {
          usethis:::check_installed(.dep)
        } else {
          suppressMessages(ensure_package(.dep))
        }
      }
    })
}

#' @importFrom stringr str_replace_all
handle_regex_escaping <- function(string) {
  stringr::str_replace_all(string, "(\\W)", "\\\\\\1")
}
