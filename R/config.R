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
  use_github_repo_name = get_package_name(),
  use_github_auth = "ssh"
) {
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
#'
#' @return
write_goodstart_config <- function(
  config = goodstart_config(),
  path = get_path_config_file()
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
}

#' Read config for `{goodstart}`
#'
#' @param path
#'
#' @return
read_goodstart_config <- function(
  path = get_path_config_file()
) {
  if (path %>% fs::file_exists() %>% magrittr::not()) {
    stop("Config file '{path}' does not exist" %>% stringr::str_glue())
  }

  # Read
  env_vars <- path %>%
    read_utf8() %>%
    envvy__parse()
}

#' Check existence of config file
#'
#' @param path
#'
#' @return
exists_goodstart_config <- function(
  path = get_path_config_file()
) {
  path %>% fs::file_exists()
}
