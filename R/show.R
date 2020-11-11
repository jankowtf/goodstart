show_sys_call <- function(sys_call = sys.call(-1), show = FALSE) {
  if (show) {
    sys_call
    usethis::ui_info("{sys_call[[1]]}()")
  }
}

show_info <- function(show = FALSE) {
  show_sys_call(sys.call(-1), show = show)
}

show_trace <- function(show = FALSE) {
  # message(getwd())
  if (show) {
    usethis::ui_info("{getwd()}")
  }
}
