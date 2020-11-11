# TODO-20201111-1730-1: Find ways to refactor `uses_github()` to not depend on
# any internal functions of `{usethis}`
uses_github <- function()  {
  if (!uses_git()) {
    return(FALSE)
  }
  length(github_origin()) > 0
}

# TODO-20201111-1730-2: Find ways to refactor `uses_github()` to not depend on
# any internal functions of `{usethis}`
uses_git <- function (path = usethis::proj_get()) {
  !is.null(git2r::discover_repository(path))
  # Alternatives:
  # gert::git_find()
}

# TODO-20201111-1730-3: Find ways to refactor `uses_github()` to not depend on
# any internal functions of `{usethis}`
github_owner <- function() {
  # usethis:::github_origin()[["owner"]]
  github_origin()[["owner"]]
}

# TODO-20201111-1730-4: Find ways to refactor `uses_github()` to not depend on
# any internal functions of `{usethis}`
github_repo <- function () {
  # usethis:::github_origin()[["repo"]]
  github_origin()[["repo"]]
}

# TODO-20201111-1730-6: Find ways to refactor `uses_github()` to not depend on
# any internal functions of `{usethis}`
github_origin <- function () {
  r <- github_remote("origin")
  if (is.null(r))
    return(r)
  parse_github_remotes(r)[[1]]
}

# TODO-20201111-1730-7: Find ways to refactor `uses_github()` to not depend on
# any internal functions of `{usethis}`
github_remote <- function (name) {
  # remotes <- usethis:::github_remotes()
  remotes <- github_remotes()
  if (length(remotes) == 0)
    return(NULL)
  remotes[[name]]
}

parse_github_remotes <- function (x) {
  re <- "github[^/:]*[:/]{1,2}([^/]+)/(.*?)(?:\\.git)?$"
  m <- regexec(re, as.character(x))
  match <- stats::setNames(regmatches(as.character(x), m),
    names(x))
  lapply(match, function(y) list(owner = y[[2]], repo = y[[3]]))
}

# TODO-20201111-1730-8: Find ways to refactor `uses_github()` to not depend on
# any internal functions of `{usethis}`
github_remotes <- function () {
  remotes <- usethis::git_remotes()
  if (length(remotes) == 0)
    return(NULL)
  m <- vapply(remotes, function(x) grepl("github", x),
    logical(1))
  if (length(m) == 0)
    return(NULL)
  remotes[m]
}

