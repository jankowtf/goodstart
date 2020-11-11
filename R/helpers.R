# Create sandbox package --------------------------------------------------

#' Create a sandbox package
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
create_sandbox_package <- function(
  dir = fs::file_temp(pattern = "testpkg"),
  env = parent.frame(),
  defer = TRUE
) {
  if (defer) {
    old_project <- usethis::proj_get()    # --- Record starting state ---

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
  }

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


# Mimick factory fresh package as created by RStudio ----------------------

#' Mimick R package project as created from within RStudio
#'
#' @return Project path as returned by [usethis::proj_path()]
#' @export
mimick_rstudio_package <- function() {
  goodstart:::when_testing_load_local_package()
  "R/hello.R" %>% usethis::proj_path() %>% fs::file_create()
  # Example file created when creating new package projects in RStudio
  goodstart:::when_testing_ensure_man_dir()
  "man/hello.Rd" %>% usethis::proj_path() %>% fs::file_create()
  # Example file created when creating new package projects in RStudio
  goodstart:::when_testing_namespace_default()
  # goodstart:::when_testing_ensure_example_function_and_unit_test()

  # goodstart:::ensure_removed_file("README.Rmd")
  goodstart:::when_testing_copy_template("package-README")
  goodstart:::when_testing_copy_template("package-BACKLOG")

  usethis::proj_path()
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
