#' @param id
#'
#' @importFrom fs path
path_config_file <- function(id = character()) {
  path <- "~" %>% fs::path(".r_goodstart", "config")

  # Handle path and ID if specified
  if (length(id)) {
    path %>%
      stringr::str_glue("_{id}") %>%
      fs::path()
  } else {
    path
  }
}
