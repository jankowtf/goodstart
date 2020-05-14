#' Get key-value store name
#'
#' @return
#' @importFrom stringr str_glue
skeval__store_name <- function() {
  pkg <- get_package_name() %>% toupper()
  stringr::str_glue("{pkg}_KEY_VALUE_STORE")
}

#' Ensure key-value store
#'
#' @return
skeval__ensure_store <- function() {
  store_name <- skeval__store_name()
  if (!exists(store_name, options(), inherits = FALSE)) {
    "options(\"{store_name}\" = new.env(parent = emptyenv()))" %>%
      stringr::str_glue() %>%
      rlang::parse_expr() %>%
      rlang::eval_tidy()
    TRUE
  } else {
    FALSE
  }
}

#' Reset key-value store
#'
#' @return
skeval__reset_store <- function() {
  store_name <- skeval__store_name()
  "options(\"{store_name}\" = new.env(parent = emptyenv()))" %>%
    stringr::str_glue() %>%
    rlang::parse_expr() %>%
    rlang::eval_tidy()

  exists(store_name, options(), inherits = FALSE)
}

#' Compute hash key for key-value store
#'
#' @param ...
#'
#' @return
skeval__compute_key <- function(
  ...
) {
  dots <- rlang::list2(...)

  dots %>% digest::digest()
}

#' Check if hash key exists in key-value store
#'
#' @param key
#'
#' @return
skeval__exists_value <- function(key) {
  skeval__ensure_store()

  store_name <- skeval__store_name()
  exists(key, getOption(store_name), inherits = FALSE)
}

#' Create key-value pair
#'
#' @param key
#' @param value
#'
#' @return
skeval__create_value <- function(
  value,
  key
) {
  skeval__ensure_store()

  # Automatic key in case only `value` was provided
  # expr <- rlang::call_frame() %>% purrr::pluck("expr")
  call_args <- rlang::call_args(rlang::call_frame())
  if (length(call_args) == 1 && call_args[[1]] %>% is.symbol()) {
    key <- call_args %>% as.character()
  }

  store_name <- skeval__store_name()
  env <- getOption(store_name)
  env[[key]] <- value
  env[[key]]
}

#' Read value from key-value store
#'
#' @param key
#'
#' @return
skeval__read_value <- function(
  key
) {
  skeval__ensure_store()

  store_name <- skeval__store_name()
  env <- getOption(store_name)
  env[[key]]
}
