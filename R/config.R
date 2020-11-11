#' Config for `{goodstart}`
#'
#' @param use_github_user_name
#' @param use_github_repo_name
#' @param use_github_auth
#'
#' @return
#' @export
goodstart_config <- function(
  use_github_user_name = "rappster",
  use_github_repo_name = gs_package_name(),
  use_github_auth = "ssh"
) {
  # Transfer to env vars
  ensure_env_vars(
    list(
      GS_GITHUB_USERNAME = use_github_user_name,
      GS_GITHUB_REPONAME = use_github_repo_name
    )
  )

  list(
    # Internal
    use_roxygen = TRUE,
    use_rmarkdown = TRUE,
    use_readme = TRUE,
    use_news = TRUE,
    use_backlog = TRUE,
    use_license = TRUE,
    use_license_license = "gpl3",

    use_unit_testing = TRUE,
    use_unit_testing_package = "testthat",
    use_unit_testing_coverage = TRUE,
    use_unit_testing_coverage_package = "covr",
    use_dep_management = TRUE,
    use_dep_management_package = "renv",

    # External
    use_github = TRUE,
    use_github_user_name = use_github_user_name,
    use_github_repo_name = use_github_repo_name,
    use_github_auth = use_github_auth,
    # use_github_actions = TRUE,
    use_ci = TRUE,
    use_ci_platform = "github_actions",
    use_ci_test_coverage = TRUE,
    use_ci_test_coverage_service = "codecov",
    use_lifecycle = TRUE
  )
}

#' Write config for `{goodstart}`
#'
#' @param config
#' @param path
#' @param id
#'
#' @return
#' @export
write_goodstart_config <- function(
  config = goodstart_config(),
  path = path_config_file(id = id),
  id = character()
) {
  # Ensure directory
  path %>%
    fs::path_dir() %>%
    fs::dir_create()

  # Deparse config and write to file
  config %>%
    envvy__deparse() %>%
    as.character() %>%
    write(path)

  path
}

#' Read config for `{goodstart}`
#'
#' @param path
#' @param id
#'
#' @return
#' @export
read_goodstart_config <- function(
  path = path_config_file(id = id),
  id = character()
) {
  if (path %>% fs::file_exists() %>% magrittr::not()) {
    stop("Config file '{path}' does not exist" %>% stringr::str_glue())
  }

  # Inform
  message("Reading config {path}" %>% stringr::str_glue())

  # Read
  path %>%
    read_utf8() %>%
    envvy__parse()
}

#' Check existence of config file
#'
#' @param path
#' @param id
#'
#' @return
#' @export
exists_goodstart_config <- function(
  path = path_config_file(id = id),
  id = character()
) {
  path %>% fs::file_exists()
}

#' List available config file
#'
#' @param path
#' @param id
#'
#' @return
#' @export
list_goodstart_configs <- function(
  path = path_config_file(id = id),
  id = character()
) {
  exists_dir <- path %>%
    fs::path_dir() %>%
    fs::dir_exists()

  if (!exists_dir) {
    return("No config files have been saved yet")
  }

  path %>%
    fs::path_dir() %>%
    fs::dir_ls(all = TRUE)
}
