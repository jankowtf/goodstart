# Parse -------------------------------------------------------------------

#' Parse environment variables
#'
#' @param env_vars
#'
#' @return [list()] List with parsed values
#'
#' @importFrom purrr map set_names
#' @importFrom stringi stri_remove_empty
#' @importFrom stringr str_remove_all str_split
envvy__parse <- function(env_vars) {
  body <- "{.y}={.x}"

  env_vars %>%
    purrr::map(~.x %>% stringr::str_glue())

  env_var_list <- env_vars %>%
    stringr::str_remove_all("^#.*") %>%
    stringi::stri_remove_empty() %>%
    stringr::str_split("=")

  names <- env_var_list %>%
    purrr::map(1)
  values <- env_var_list %>%
    purrr::map(2) %>%
    purrr::map(envvy__parse_special)

  values %>%
    purrr::set_names(names)
}

envvy__parse_special <- function(x) {
  if (x %in% c("TRUE", "FALSE", "true", "false")) {
    x %>% as.logical()
  } else if (x %>% stringr::str_detect("^\\d+$")) {
    x %>% as.numeric()
  } else {
    x
  }
}

# Deparse -----------------------------------------------------------------

#' Deparse environment variables
#'
#' @param env_vars
#'
#' @return [list()] List with deparsed environment variable expression as
#'   [character(1)] per list element
#'
#' @importFrom purrr imap
envvy__deparse <- function(env_vars) {
  body <- "{.y}={.x}"

  env_vars %>%
    purrr::imap(~stringr::str_glue(body))
}

# Make environment variable expression ------------------------------------

#' @importFrom purrr imap_chr map_chr set_names
#' @importFrom rlang parse_expr
#' @importFrom stringr str_glue
envvy__make_expressions <- function(env_vars, fn, key_only = FALSE) {
  body <- if (!key_only) {
    "{.y}=\"{.x}\""
  } else {
    "\"{.y}\""
  }
  env_vars %>%
    purrr::imap_chr(~stringr::str_glue(body)) %>%
    purrr::map_chr(., ~stringr::str_glue("{fn}({.x})")) %>%
    purrr::map(~rlang::parse_expr(.x)) %>%
    purrr::set_names(env_vars %>% names())
}


# Make Sys.setenv() expressions -------------------------------------------

envvy__make_set_expressions <- function(env_vars) {
  env_vars %>%
    envvy__make_expressions(fn = "Sys.setenv")
}

# Make Sys.getenv() expressions -------------------------------------------

envvy__make_get_expressions <- function(env_vars) {
  env_vars %>%
    envvy__make_expressions(fn = "Sys.getenv", key_only = TRUE)
}

# Make Sys.unsetenv() expressions -----------------------------------------

envvy__make_unset_expressions <- function(env_vars) {
  env_vars %>%
    envvy__make_expressions(fn = "Sys.unsetenv", key_only = TRUE)
}

# Evaluate Sys.setenv() or Sys.getenv() expressions -----------------------

#' @importFrom purrr map set_names
#' @importFrom rlang eval_tidy
envvy__eval_expressions <- function(
  env_var_expressions,
  return_actual = TRUE
) {
  fn <- if (!return_actual) {
    purrr::walk
  } else {
    purrr::map
  }
  result <- env_var_expressions %>%
    fn(rlang::eval_tidy)

  if (!return_actual) {
    env_var_expressions %>%
      purrr::map(~.x[[2]]) %>%
      purrr::set_names(env_var_expressions %>% names())
  } else {
    result
  }
}

envvy__eval_set_expressions <- function(
  env_var_expressions
) {
  env_var_expressions %>%
    envvy__eval_expressions(return_actual = FALSE)
}

envvy__eval_get_expressions <- function(
  env_var_expressions
) {
  env_var_expressions %>%
    envvy__eval_expressions(return_actual = TRUE)
}

envvy__eval_unset_expressions <- function(
  env_var_expressions
) {
  env_var_expressions %>%
    envvy__eval_expressions(return_actual = TRUE)
}

# Ensure crucial environt variables for the package to work ---------------

ensure_env_vars <- function(
  env_vars = list(
    GITHUB_USERNAME = "rappster"
  )
) {
  env_vars_expressions <- env_vars %>%
    envvy__make_set_expressions() %>%
    envvy__eval_set_expressions()
}
