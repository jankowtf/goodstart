#' Read UTF-8
#'
#' @param path
#'
#' @return
read_utf8 <- function(path) {
  usethis:::read_utf8(path)
}

#' Write UTF-8
#'
#' @param lines
#' @param path
#'
#' @return
write_utf8 <- function(lines, path) {
  usethis:::write_utf8(path = path, lines = lines)
}
