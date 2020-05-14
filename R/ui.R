ui_glue_wrap_field <- function(x) {
  x %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_field()
}

ui_glue_wrap_line <- function(x, indent = 0) {
  x %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = indent) %>%
    usethis::ui_line()
}

ui_glue_wrap_done <- function(x) {
  x %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
}
