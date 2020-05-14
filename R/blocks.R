#' Find block between start and end identifiers
#'
#' @param lines
#' @param block_start
#' @param block_end
#'
#' @return
#' @import usethis
block_find <- function(
  lines,
  block_start,
  block_end
) {
  usethis:::block_find(lines, block_start, block_end)
}

#' Title
#'
#' @param lines
#' @param block_bounds
#'
#' @return
#' @importFrom rlang seq2
block_get <- function(lines, block_bounds, strict = TRUE) {
  if (length(block_bounds)) {
    lines[rlang::seq2(block_bounds[[1]], block_bounds[[2]])]
  } else {
    if (strict) {
      msg <- "Empty block bounds"
      usethis::ui_oops(msg)
      stop(msg)
    }
    character()
  }
}

#' Create block
#'
#' @param value
#' @param block_start
#' @param block_end
#' @param block_prefix
#' @param block_suffix
#'
#' @return
block_create <- function(
  value,
  block_start,
  block_end,
  block_prefix = character(),
  block_suffix = character()
) {
  c(
    block_prefix,
    block_start,
    value,
    block_end,
    block_suffix
  )
}

#' Append block
#'
#' @param lines
#' @param value
#' @param block_bounds
#' @param only_if_new
#' @param strict
#'
#' @return
#' @importFrom rlang seq2
#' @importFrom usethis ui_oops
block_append <- function(
  lines,
  value,
  block_bounds,
  only_if_new = TRUE,
  strict = TRUE
) {
  if (!length(block_bounds) && strict) {
    usethis::ui_oops("Empty block bounds")
  }

  # Lines before and after the actual block ----------
  lines_before <- if (length(lines)) {
    lines[rlang::seq2(1, block_bounds[[1]] - 1L)]
  } else {
    lines
  }
  lines_after <- if (length(lines)) {
    lines[rlang::seq2(block_bounds[[2]] + 1L, length(lines))]
  } else {
    lines
  }

  # Actual block ----------
  block <- block_get(lines, block_bounds, strict = strict)

  # Pluck new content ----------
  if (only_if_new) {
    value <- value[!(value %in% block)]

    if (!length(value)) {
      return(lines)
    }
  }

  c(
    lines_before,
    block,
    value,
    lines_after
  )
}
