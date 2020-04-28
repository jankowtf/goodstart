global__get_env_var_testing <- function() {
  Sys.getenv("__GOODSTART_TESTING", FALSE) %>%
    ifelse(. == "", "FALSE", .) %>%
    as.logical()
}
