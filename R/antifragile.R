#' @importFrom purrr set_names
#' @importFrom stringr str_replace
antifrag__fix_yaml_parsing_handler_logical <- function(yaml) {
  yaml_names <- yaml %>%
    names() %>%
    stringr::str_replace("TRUE", "on")
  yaml %>%
    purrr::set_names(yaml_names)
}

antifrag__fix_yaml_deparsing_handler_logical <- function(x) {
  x %>%
    as.character() %>%
    tolower()
}
