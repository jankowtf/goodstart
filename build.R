
# Manage renv cache -------------------------------------------------------

# renv_cache <- here::here("renv/cache")
renv_cache <- "renv/cache"
dir.create(renv_cache, recursive = TRUE, showWarnings = FALSE)

Sys.setenv(RENV_PATHS_CACHE = normalizePath(renv_cache))
# Sys.getenv("RENV_PATHS_CACHE")

# reinstall_deps <- as.logical(Sys.getenv("RENV_REINSTALL_DEPENDENCIES", FALSE))
# reinstall_deps <- TRUE
ensure_deps <- FALSE

# force_cache_update <- TRUE
force_cache_update <- FALSE
ignore_dev_packages <- TRUE

# Package infos -----------------------------------------------------------

# package_name <- devtools::as.package(".")$package
package_name <- get_package_name()
package_version <- get_package_version()

# Dependencies ------------------------------------------------------------

library("magrittr")

if (ensure_deps) {
  renv::install(c(
    "r-lib/usethis",
    # "clipr", # Dependency of {usethis}
    # "fs", # Dependency of {usethis}
    "gert",
    # "git2r", # Dependency of {usethis}
    "here",
    "knitr",
    "lifecycle",
    "pkgdown",
    # "purrr", # Dependency of {usethis}
    # "renv",
    "rstudio/renv",
    # "rlang", # Dependency of {usethis}
    "roxygen2",
    # "rstudioapi", # Dependency of {usethis}
    "stringr"
    # "withr", # Dependency of {usethis}
    # "yaml", # Dependency of {usethis}
  ))

  usethis::use_package("usethis")
  usethis::use_package("gert")
  usethis::use_package("here")
  usethis::use_package("knitr")
  usethis::use_package("lifecycle")
  usethis::use_package("stringr")
  usethis::use_package("covr", type = "Suggests")
  usethis::use_package("pkgdown", type = "Suggests")
  usethis::use_package("rmarkdown", type = "Suggests")
  usethis::use_package("renv", type = "Suggests")
  usethis::use_package("roxygen2", type = "Suggests")
  usethis::use_package("testthat", type = "Suggests")

  ensure_env_vars(
    list(
      GITHUB_USERNAME = "rappster"
    )
  )
  ensure_good_start()
}

# Ignore dependencies -----------------------------------------------------

# {here} currently needed by {confx} and the others by {devtools} which is on
# the hit list
if (ignore_dev_packages) {
  renv::settings$ignored.packages(c(
    "devtools",
    "reprex",
    "roxygen2",
    "testthat"
  ))
} else {
  renv::settings$ignored.packages(character())
}

# Populate inst directory -------------------------------------------------

# Ensure clean dir to start with:
# fs::dir_ls("inst/api", all = TRUE) %>%
#   purrr::walk(~.x %>% fs::file_delete())
# fs::file_copy("R/api_server_prod.R", "inst/api/api_server.R", overwrite = TRUE)
# fs::file_copy("start_internal.R", "inst/api/start_api_server.R", overwrite = TRUE)

# Ensure built package is not contained in renv.lock ----------------------

renv::remove(package_name)

# Test --------------------------------------------------------------------

# devtools::test()

# Knit README -------------------------------------------------------------

# ensure_knit_readme()

# Build -------------------------------------------------------------------

fs::dir_create("renv/local") %>%
# Ensure clean dir to start with:
  fs::dir_ls(all = TRUE) %>%
  purrr::walk(~.x %>% fs::file_delete())
usethis::use_build_ignore(c("data", "renv"))
devtools::document()
devtools::build(path = "renv/local")
# install.packages(paste0(package_name, ".tar.gz"), repos = NULL, type="source")
# renv::install(list.files(pattern = paste0(package_name, ".*\\.tar\\.gz")))
ensure_knit_readme()
# Create snapshot ---------------------------------------------------------

# Important for making execution via bash shell possible!
# Script renv/activate.R needs to be executed again in order to make snapshoting
# work
if (file.exists("renv/activate.R")) {
  source("renv/activate.R")
}

renv::snapshot(confirm = FALSE)

file <- "renv.lock"
renv_lock_hash_current <- digest::digest(readLines(file))

# Copy snapshot to cache builder dir --------------------------------------

file <- "renv/renv.lock"
renv_lock_hash_cached <- if (file.exists(file)) {
  digest::digest(readLines(file))
} else {
  ""
}

if (renv_lock_hash_current != renv_lock_hash_cached ||
    force_cache_update
) {
  message("Updating cached renv.lock")
  # fs::file_copy("renv.lock", "../cache_builder/renv.lock", overwrite = TRUE)
  fs::file_copy("renv.lock", "renv/renv.lock", overwrite = TRUE)
} else {
  message("Cached renv.lock up to date")
}

package_record <- list(list(
  Package = package_name,
  Version = package_version,
  Source = "Filesystem"
))
names(package_record) <- package_name
renv::record(package_record)

# Preps for Docker --------------------------------------------------------

dir.create("renv/cache_docker", recursive = TRUE, showWarnings = FALSE)

# Ensure .gitignore content -----------------------------------------------

# c(
#   "cache/",
#   "cache_docker/",
#   "local/"
# ) %>%
#   modify_ignore_file("renv/.gitignore", escape = FALSE)
#
# c(
#   "scripts",
#   "build.R"
# ) %>%
#   modify_ignore_file(".Rbuildignore", escape = TRUE)

ensure_renv_gitignore_state()
ensure_rbuildignore_state()
