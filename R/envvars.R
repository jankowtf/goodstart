# Make environment variable expression ------------------------------------

#' @importFrom purrr imap_chr map_chr set_names
#' @importFrom rlang parse_expr
#' @importFrom stringr str_glue
envvars__make_expressions <- function(env_vars, fn, key_only = FALSE) {
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

envvars__make_set_expressions <- function(env_vars) {
  env_vars %>%
    envvars__make_expressions(fn = "Sys.setenv")
}

# Make Sys.getenv() expressions -------------------------------------------

envvars__make_get_expressions <- function(env_vars) {
  env_vars %>%
    envvars__make_expressions(fn = "Sys.getenv", key_only = TRUE)
}

# Make Sys.unsetenv() expressions -----------------------------------------

envvars__make_unset_expressions <- function(env_vars) {
  env_vars %>%
    envvars__make_expressions(fn = "Sys.unsetenv", key_only = TRUE)
}

# Evaluate Sys.setenv() or Sys.getenv() expressions -----------------------

#' @importFrom purrr map set_names
#' @importFrom rlang eval_tidy
envvars__eval_expressions <- function(
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

envvars__eval_set_expressions <- function(
  env_var_expressions
) {
  env_var_expressions %>%
    envvars__eval_expressions(return_actual = FALSE)
}

envvars__eval_get_expressions <- function(
  env_var_expressions
) {
  env_var_expressions %>%
    envvars__eval_expressions(return_actual = TRUE)
}

envvars__eval_unset_expressions <- function(
  env_var_expressions
) {
  env_var_expressions %>%
    envvars__eval_expressions(return_actual = TRUE)
}

# Ensure crucial environt variables for the package to work ---------------

ensure_env_vars <- function(
  env_vars = list(
    GITHUB_USERNAME = "rappster"
  )
) {
  env_vars_expressions <- env_vars %>%
    envvars__make_set_expressions() %>%
    envvars__eval_set_expressions()
}
