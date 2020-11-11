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
  success <- !inherits(result, "try-error")

  if (!strict) {
    success
  } else {
    if (!success) {
      message <- stringr::str_glue("{message}:\n{result}")
      usethis::ui_stop(message)
    } else {
      # If the result is logical then it is assumed that it is an indicator if
      # something went wrong or not, thus it becomes the return value. For other
      # types the 'sucess' is returned
      if (is.logical(result)) {
        result
      } else {
        success
      }
      # TODO-2010111-2036: Handling of return values still seems a bit to
      # involved. Check if I could leverage existing packages/solutions for that
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
      # out <- if (pkg_is_missing <- !usethis:::is_installed(.dep)) {
      # out <- if (pkg_is_missing <- !is_package_loadable(.dep)) {
      # Keep those as reference and as a reminder that requireNamespace() is NOT
      # equivalent to checking via installed.packages() - at least not in all
      # "contexts"

      out <- if (pkg_is_missing <- !is_package_installed(.dep)) {
        if (!install_if_missing) {
          usethis:::check_installed(.dep)
        } else {
          suppressMessages(ensure_package(.dep))
        }
      }
      # print("DEBUG: package missing")
      # print(.dep)
      # print(pkg_is_missing)
      # Keep to facilitate troubleshooting

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

#' @importFrom fs path
gs_project_data <- function(project = usethis::proj_get()) {
  usethis:::project_data(base_path = project)
}
