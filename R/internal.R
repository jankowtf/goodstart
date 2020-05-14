#' @importFrom fs is_absolute_path
#' @importFrom here here
#' @importFrom usethis proj_path
handle_path <- function(path = ".") {
  testing <- global__get_env_var_testing()
  path <- ifelse(
    !fs::is_absolute_path(path),
    # ifelse(!testing, here::here(path), usethis::proj_path(path)),
    usethis::proj_path(path),
    path
  )
}

handle_return_value <- function(
  result,
  message,
  strict = TRUE
) {
  result_try <- !inherits(result, "try-error")

  if (!strict) {
    result_try
  } else {
    if (!result_try) {
      message(result)
      stop(message)
    } else {
      result_try
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
  install_if_missing = FALSE,
  add_to_desc = FALSE,
  dep_type = valid_dep_types("Suggests")
) {
  if (!length(deps)) {
    return(TRUE)
  }
  deps %>%
    purrr::map(function(.dep) {
      # Only check of install if not installed
      out <- if (!usethis:::is_installed(.dep)) {
        if (!install_if_missing) {
          usethis:::check_installed(.dep)
        } else {
          suppressMessages(ensure_package(.dep))
        }
      }

      # Add to DESCRIPTION file
      if (add_to_desc) {
        usethis::use_package(.dep, type = dep_type)
      }

      out
    })
}

#' @importFrom stringr str_replace_all
handle_regex_escaping <- function(string) {
  stringr::str_replace_all(string, "(\\W)", "\\\\\\1")
}

most <- function(x, limit = 0.5) {
  value <- (sum(x) / length(x))

  out <- value > limit
  attributes(out)$value <- value

  out
}
