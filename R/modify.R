# Modify README -----------------------------------------------------------

#' @importFrom stringr str_glue str_replace
modify_readme_installation <- function() {
  package <- get_package_name()
  package_remote <- stringr::str_glue(
    "{Sys.getenv(\"GITHUB_USERNAME\")}/{package}"
  )

  path <- "README.Rmd" %>%
    handle_path()
  readme <- readLines(path)
  readme %>%
    stringr::str_replace(
      stringr::str_glue("install.packages\\(\"{package}\"\\)"),
      stringr::str_glue("remotes::install_github(\"{package_remote}\")")
    ) %>%
    write(path)
}

#' @importFrom stringr str_replace str_glue
modify_readme_backticks <- function() {
  path <- "README.Rmd" %>%
    handle_path()
  readme <- readLines(path)
  readme %>%
    stringr::str_replace(
      stringr::str_glue("``` r"),
      stringr::str_glue("```{{r}}")
    ) %>%
    write(path)
}

#' @importFrom stringr str_detect
modify_readme_opts_chunk <- function() {
  path <- "README.Rmd" %>%
    handle_path()

  readme <- readLines(path)

  # Identify opts_chunk():
  index <- readme %>%
    stringr::str_detect("knitr::opts_chunk\\$set\\(")

  # Append opts_chunk:
  readme %>%
    append(
      values = "  eval = FALSE,",
      after = index %>% which()
    ) %>%
    write(path)
}

# Modify GitHub Actions workflow YAML -------------------------------------

#' @importFrom fs path dir_ls
#' @importFrom stringr str_split
#' @importFrom usethis ui_oops
modify_github_actions_workflow_add_codecov <- function() {
  path <- ".github" %>%
    fs::path("workflows") %>%
    handle_path() %>%
    fs::dir_ls(type = "file", regexp = "R-CMD-check\\.yaml$")

  # Safety check:
  if (length(path) > 1) {
    usethis::ui_oops("Multiple GitHub Action workflow YAML files found:\n{path %>% stringr::str_c(collapse = \"\n\")}")
    return(FALSE)
  }

  # This would be my preferred solution. However, certain words with special
  # meaning either due to YAML or R mess things up big time.
  # For example, `on` is turned into `TRUE` and `false` is turned into `FALSE
  # and then `"false"` when writing to disk, which makes GitHub Actions fail.
  # Thus, due to a lack of better options, I have to resort to string
  # manipulation
  if (FALSE) {
    # Read R-CMD-check workflow:
    yaml <- yaml::read_yaml(path, eval.expr = FALSE) %>%
      antifrag__fix_yaml_parsing_handler_logical()

    # Read codecov workflow template:
    yaml_codecov <- templar__github_actions_workflow_codecov()

    # Append existing R-CMD-check workflow:
    yaml$jobs$`R-CMD-check`$steps <- append(
      yaml$jobs$`R-CMD-check`$steps,
      yaml_codecov$steps
    )

    # Write new YAML file:
    # path_test <- path %>% stringr::str_c("test.yaml")
    yaml %>%
      yaml::write_yaml(
        path,
        handlers = list(
          logical = antifrag__fix_yaml_deparsing_handler_logical
        )
      )
  }

  # Read R-CMD-check workflow:
  yaml <- readLines(path)

  # Read codecov workflow template:
  yaml_codecov <- templar__github_actions_workflow_codecov(
    parse = FALSE,
    steps_only = TRUE
  ) %>%
    stringr::str_split("\\n") %>%
    unlist() %>%
    `[`(. != "")

  # Append existing R-CMD-check workflow:
  yaml_modified <- yaml %>%
    append(yaml_codecov)

  # Write new YAML file:
  yaml_modified %>%
    write(file = path)

}


# Modify gitignore --------------------------------------------------------

#' @import usethis
modify_ignore_file <- function (files, file_ignore, escape = TRUE)
{
  if (escape) {
    files <- usethis:::escape_path(files)
  }
  usethis::write_union(usethis::proj_path(file_ignore), files)
}
