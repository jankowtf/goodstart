# Ensure git remote -------------------------------------------------------

#' @importFrom gert git_remote_add
#' @importFrom stringr str_glue
#' @importFrom usethis ui_stop
ensure_git_remote <- function(
  name = "origin",
  github_username = Sys.getenv("GITHUB_USERNAME"),
  package_name = get_package_name(),
  url = stringr::str_glue(
    # "https://github.com/{github_username}/{package_name}"
    "ssh://git@github.com/{github_username}/{package_name}"
  ),
  .strict = FALSE
) {
  # Input handling:
  if (github_username == "") {
    usethis::ui_stop("Environment variable 'GITHUB_USERNAME' not set")
  }
  result <- try(
    gert::git_remote_add(
      name = "origin",
      url = url
    ),
    silent = TRUE
  )

  out <- !inherits(result, "try-error")

  handle_return_value(
    out = out,
    result = result,
    message = "Ensurance of git remote failed",
    .strict = .strict
  )
}

# Ensure git add all ------------------------------------------------------

#' @importFrom gert git_status git_add
ensure_git_add_all <- function(.strict = FALSE) {
  result <- try(
    gert::git_status() %>%
      # dplyr::pull(file) %>%
      `$`(file) %>%
      gert::git_add()
  )

  out <- !inherits(result, "try-error")

  handle_return_value(
    out = out,
    result = result,
    message = "Ensurance of git fetch failed",
    .strict = .strict
  )
}

# Ensure git fetch --------------------------------------------------------

#' @importFrom gert git_fetch
#' @importFrom stringr str_glue
ensure_git_fetch <- function(
  remote = "origin",
  branch = "master",
  .strict = FALSE
) {
  result <- try(
    gert::git_fetch(
      remote,
      refspec = stringr::str_glue(
        "+refs/heads/{branch}:refs/remotes/{remote}/{branch}"
      )
    )
  )
  # result <- try(
  #   gert::git_fetch(remote), silent = TRUE
  # )

  out <- !inherits(result, "try-error")

  handle_return_value(
    out = out,
    result = result,
    message = "Ensurance of git fetch failed",
    .strict = .strict
  )
}

# Ensure git commit -------------------------------------------------------

#' @importFrom gert git_commit
ensure_git_commit <- function(
  message = stringr::str_glue("Off to a good start ({Sys.time()})"),
  .strict = FALSE
) {
  result <- try(
    gert::git_commit(message %>% as.character()),
    silent = TRUE
  )

  out <- !inherits(result, "try-error")

  handle_return_value(
    out = out,
    result = result,
    message = "Ensurance of git commit failed",
    .strict = .strict
  )
}

# Ensure git push ---------------------------------------------------------

#' @importFrom gert git_push
#' @importFrom stringr str_glue
ensure_git_push <- function(
  remote = "origin",
  branch = "master",
  force = FALSE,
  .strict = FALSE
) {
  result <- try(
    gert::git_push(
      remote,
      refspec = stringr::str_glue("refs/heads/{branch}"),
      force = force
    )
  )
  result <- try(
    gert::git_push(
      remote,
      # refspec = stringr::str_glue("refs/heads/{branch}"),
      refspec = stringr::str_glue(
        "+refs/heads/{branch}:refs/remotes/{remote}/{branch}"
      ),
      force = force
    )
  )

  out <- !inherits(result, "try-error")

  handle_return_value(
    out = out,
    result = result,
    message = "Ensurance of git push failed",
    .strict = .strict
  )
}
