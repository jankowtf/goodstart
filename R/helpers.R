#' @importFrom fs path_file path_real path_dir
#' @importFrom rlang is_interactive
#' @importFrom rstudioapi isAvailable
#' @import usethis
create_package_non_interactive <- function (path,
  fields = list(),
  rstudio = rstudioapi::isAvailable(child_ok = TRUE),
  roxygen = TRUE,
  check_name = TRUE,
  open = rlang::is_interactive())
{
  path <- usethis:::user_path_prep(path)
  usethis:::check_path_is_directory(fs::path_dir(path))
  name <- fs::path_file(fs::path_real(path))
  if (check_name) {
    usethis:::check_package_name(name)
  }
  # check_not_nested(path_dir(path), name)
  usethis:::create_directory(path)
  old_project <- proj_set(path, force = TRUE)
  on.exit(proj_set(old_project), add = TRUE)
  use_directory("R")
  use_description(fields, check_name = FALSE, roxygen = roxygen)
  use_namespace(roxygen = roxygen)
  if (rstudio) {
    use_rstudio()
  }
  if (open) {
    if (proj_activate(path)) {
      on.exit()
    }
  }
  invisible(proj_get())
}

#' Create a local package
#'
#' Mainly created for clean testing as described in Jenny Bryan's
#' [Self-cleaning test fixtures](https://www.tidyverse.org/blog/2020/04/self-cleaning-test-fixtures/)
#' and to facilitate examples that don't mess things up for the package users.
#'
#' @param dir
#' @param env
#'
#' @return
#' @import usethis
#' @importFrom fs file_temp dir_delete
#' @importFrom withr defer
#' @export
create_local_package <- function(
  dir = fs::file_temp(pattern = "testpkg"),
  env = parent.frame()
) {
  old_project <- usethis:::proj_get_()  # --- Record starting state ---

  suppressMessages(
    withr::defer({                        # --- Defer The Undoing ---
      usethis::proj_set(                  # restore active usethis project (-C)
        old_project,
        force = TRUE
      )
      setwd(old_project)                  # restore working directory      (-B)
      fs::dir_delete(dir)                 # delete the temporary package   (-A)
    }, envir = env)
  )

  capture.output({
    # --- Do The Doing ---
    usethis::create_package(              # create new folder and package  (A)
      dir,
      fields = list(Package = "goodstarttest"),
      rstudio = FALSE,
      open = FALSE
    )
    setwd(dir)                            # change working directory       (B)
    usethis::proj_set(dir)                # switch to new usethis project  (C)
  })
  invisible(dir)
}

# Not in ------------------------------------------------------------------

#' Check if not in set
#'
#' @param answer
#'
#' @return [logical(1)]
not_in <- function(x, set) {
  !(x %in% set)
}

#' Flip values and names
#'
#' @param x
#'
#' @return Same structure as before, but names as values and values as names
flip_values_and_names <- function(x) {
  names <- x
  x <- names(x)
  names(x) <- names
  x
}
