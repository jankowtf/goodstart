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

# proj_path <- function(..., ext = "") {
#   path_norm(path(proj_get(), ..., ext = ext))
# }
