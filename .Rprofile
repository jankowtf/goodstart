# Dependency management with {renv} ---------------------------------------

renv_cache <- "renv/cache"
dir.create(renv_cache, recursive = TRUE, showWarnings = FALSE)

Sys.setenv(RENV_PATHS_CACHE = normalizePath(renv_cache))
# Sys.getenv("RENV_PATHS_CACHE")

if (file.exists("renv/activate.R")) {
  source("renv/activate.R")
}
renv::settings$snapshot.type("simple")

# Misc --------------------------------------------------------------------

Sys.setenv(language = "en")
Sys.setenv(TZ = "UTC")
options(digits.secs = 3)
Sys.setlocale("LC_TIME", "en_GB.UTF-8")
