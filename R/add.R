#' Add {lifecycle} components to package doc file
#'
#' @return
#' @import usethis
#' @importFrom fs file_exists file_create
#' @importFrom magrittr not
add_lifecycle_to_package_doc <- function() {
  path <- usethis:::package_doc_path() %>%
    usethis::proj_path()
  if (path %>%
      fs::file_exists() %>%
      magrittr::not()
  ) {
    path %>%
      fs::file_create()
  }

  # Read doc file content ----------
  lines <- read_utf8(path)

  # Identify block bounds ----------
  block_start <- "## usethis namespace: start"
  block_end <- "## usethis namespace: end"
  block_bounds <- lines %>% block_find(
    block_start = block_start,
    block_end = block_end
  )

  # Ensure content ----------
  tag <- "@importFrom lifecycle deprecate_soft"
  desc <- stringr::str_glue("{usethis::ui_value(tag)}")
  value <- c(
    stringr::str_glue("#' {tag}"),
    "NULL"
  )
  if (!length(block_bounds)) {
    lines_new <- block_create(
      value = value,
      block_start = block_start,
      block_end = block_end
    )
  } else {
    lines_new <- lines %>%
      block_append(
        value = value,
        block_bounds = block_bounds,
        only_if_new = TRUE
      )
  }

  # Write new content if necessary ----------
  out <- if (!identical(lines, lines_new)) {
    lines_new %>%
      write_utf8(path = path)
    usethis::ui_done("Added {desc} to {usethis::ui_path(path)}")
    TRUE
  } else {
    usethis::ui_done("{desc} was already added to {usethis::ui_path(path)}")
    FALSE
  }

  out
}
