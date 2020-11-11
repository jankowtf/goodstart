is_used_renv <- function() {
  "renv" %>%
    fs::path_wd() %>%
    fs::dir_exists()
}

is_package_loadable <- function(pkg) {
  requireNamespace(pkg, quietly = TRUE)
}

is_package_installed <- function(pkg) {
  pkg %in% rownames(installed.packages())
}
