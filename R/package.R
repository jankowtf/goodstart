#' @importFrom fs path
gs_package_name <- function(package = ".") {
  if (FALSE) {
    path <- fs::path(package, "DESCRIPTION")

    description <- path %>%
      read.dcf()

    description[1 , "Package"] %>%
      unname()
  }

  # Better solution
  pkgload::pkg_name()
}

#' @importFrom fs path
gs_package_version <- function(
  package = ".",
  ensure_chr = TRUE
) {
  if (FALSE) {
    path <- fs::path(package, "DESCRIPTION")

    description <- path %>%
      read.dcf()

    description[1 , "Version"] %>%
      unname()
  }

  # Better solution
  out <- pkgload::pkg_version()
  # CAUTION: Class is
  # > class(out)
  # [1] "package_version" "numeric_version"
  # which seems to throw of regex matching in `{testthat}`

  if (ensure_chr) {
    as.character(out)
  } else {
    out
  }
}
