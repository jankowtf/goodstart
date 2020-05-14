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

#' @importFrom fs path
get_project_data <- function(project = usethis::proj_get()) {
  usethis:::project_data(base_path = project)
}

#' @importFrom fs path
get_path_config_file <- function() {
  "~" %>% fs::path(".r_goodstart", "config")
}
