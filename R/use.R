# Use README.Rmd ----------------------------------------------------------

#' Use custom README.Rmd template
#'
#' @param open
#'
#' @import usethis
#' @importFrom rlang is_interactive
use_readme_rmd <- function(
  open = rlang::is_interactive()
) {
  usethis:::check_installed("rmarkdown")

  # Data to populate template with ----------
  data <- usethis:::project_data()

  # Enable Rmd
  data$Rmd <- TRUE

  # Modify package meta information: squish and wrap at line 80
  data$Title <- data$Title %>%
    stringr::str_squish() %>%
    stringr::str_wrap()

  data$Description <- data$Description %>%
    stringr::str_squish() %>%
    stringr::str_wrap()

  # GitHub information
  # if (usethis:::uses_github()) {
  if (uses_github()) {
  # TODO-20201111-1730-5: See TODO-20201111-1730-1
    data$github <- list(
      owner = github_owner(),
      repo = github_repo()
    )
  }

  # Create new README.Rmd from template ----------
  new <- usethis::use_template(
    "package-README",
    "README.Rmd",
    data = data,
    ignore = usethis:::is_package(),
    open = open,
    package = gs_package_name()
  )

  invisible(new)
}

#' Use custom README.md template
#'
#' @param open
#'
#' @import usethis
#' @importFrom rlang is_interactive
use_readme_md <- function(
  open = rlang::is_interactive()
) {
  # usethis:::check_installed("rmarkdown")

  # Data to populate template with ----------
  data <- usethis:::project_data()

  # Enable Rmd
  data$Rmd <- TRUE

  # Modify package meta information: squish and wrap at line 80
  data$Title <- data$Title %>%
    stringr::str_squish() %>%
    stringr::str_wrap()

  data$Description <- data$Description %>%
    stringr::str_squish() %>%
    stringr::str_wrap()

  # GitHub information
  # if (usethis:::uses_github()) {
  # stop("Intentional")
  if (uses_github()) {
    # TODO-20201111-1730-9: See TODO-20201111-1730-1
    data$github <- list(
      owner = github_owner(),
      repo = github_repo()
    )
  }

  # Create new README.Rmd from template ----------
  new <- usethis::use_template(
    "package-README.md",
    "README.md",
    data = data,
    ignore = usethis:::is_package(),
    open = open,
    package = gs_package_name()
  )

  invisible(new)
}

# Use BACKLOG.Rmd ---------------------------------------------------------

#' @import usethis
#' @importFrom rlang is_interactive
use_backlog_rmd <- function(open = rlang::is_interactive()) {
  usethis:::check_installed("rmarkdown")

  data <- usethis:::project_data()
  data$Rmd <- TRUE
  # if (usethis:::uses_github()) {
  #   data$github <- list(
  #     owner = usethis:::github_owner(),
  #     repo = usethis:::github_repo()
  #   )
  # }
  # TODO-20200429T1418: Think about ways of linking BACKLOG.Rmd/.md to GitHub
  # issues and/or vice verso

  new <- usethis::use_template(
    "package-BACKLOG",
    "BACKLOG.Rmd",
    data = data,
    ignore = usethis:::is_package(),
    open = open,
    package = gs_package_name()
  )

  if (new) {
    usethis::ui_done("Created BACKLOG.Rmd")
  } else {
    usethis::ui_info("BACKLOG.Rmd already exists")
  }

  invisible(new)
}


# Use roxygen -------------------------------------------------------------

#' Use Roxygen documenation via `{roxygen2}` `
#'
#' @return
#' @export
#' @import usethis
#' @importFrom desc desc_get
use_roxygen <- function() {
  usethis:::check_installed("roxygen2")

  roxy_ver <- as.character(utils::packageVersion("roxygen2"))
  usethis:::use_description_field("RoxygenNote", roxy_ver)
  usethis::use_package("roxygen2", type = "Suggests", min_version = roxy_ver)
  usethis::ui_todo("Run {usethis::ui_code('devtools::document()')}")
  !is.na(desc::desc_get("RoxygenNote") %>% unname())
}
