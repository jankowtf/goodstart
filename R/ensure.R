# Ensure good start -------------------------------------------------------

#' @export
ensure_good_start <- function(
  config = goodstart_config(),
  open = rlang::is_interactive(),
  push_to_github = FALSE,
  ensure_deps = TRUE,
  add_to_suggested = TRUE
) {
  # Ensure dependencies
  "magrittr" %>%
    handle_deps(
      install_if_missing = ensure_deps,
      add_to_desc = add_to_suggested,
      dep_type = valid_dep_types("Suggests")
    )

  ensure_env_vars(
    list(GITHUB_USERNAME = config$use_github_user_name)
  )

  # Initialize
  output <- list()

  # Ensure example files are removed ----------
  output$ensure_removed_hello_r <-
    ensure_removed_hello_r()
  output$ensure_removed_hello_rd <-
    ensure_removed_hello_rd()

  # Ensure dependency management ----------
  # It's important that this precedes all other ensurance functions as this
  # ensures that package dependencies are installed correctly
  output$ensure_dep_management <- if (
    config$use_dep_management
  ) {
    ensure_dependency_management(
      package = config$use_dep_management_package
    )
  } else {
    FALSE
  }

  # Ensure unit testing ----------
  output$ensure_unit_testing <- FALSE
  output$ensure_test_coverage <- FALSE
  if (config$use_unit_testing) {
    output$ensure_unit_testing <-
      ensure_unit_testing(
        package = config$use_unit_testing_package
      )

    if (config$use_unit_testing_coverage) {
      # Ensure test coverage infrastructure is set up
      output$ensure_test_coverage <-
        ensure_unit_testing_test_coverage(strict = FALSE)
    }
  }

  # Ensure README ----------
  output$ensure_readme_rmd <- ifelse(
    config$use_readme,
    {
      readme_type <- if (config$use_rmarkdown) {
        valid_readme_types("rmd")
      } else {
        valid_readme_types("md")
      }

      ensure_readme(type = readme_type, open = open)
    },
    FALSE
  )

  # Ensure NEWS.md ----------
  output$ensure_news_md <- ifelse(
    config$use_news,
    ensure_news_md(open = open),
    FALSE
  )

  # Ensure BACKLOG.Rmd ----------
  output$ensure_backlog_rmd <- ifelse(
    config$use_backlog,
    ensure_backlog_rmd(open = open),
    FALSE
  )

  # Ensure roxygen ----------
  output$ensure_roxygen <- FALSE
  output$ensure_removed_namespace_default <- FALSE
  output$ensure_roxygen_namespace <- FALSE
  output$ensure_roxygen_md <- FALSE

  if (config$use_roxygen) {
    output$ensure_roxygen <-
      ensure_roxygen()

    # Ensure default NAMESPACE is removed
    output$ensure_removed_namespace_default <-
      ensure_removed_namespace_default()

    # Ensure roxygen2-based NAMESPACE
    output$ensure_roxygen_namespace <-
      ensure_roxygen_namespace()

    if (config$use_rmarkdown) {
      # Ensure Markdown can be used in {roxygen2} code
      output$ensure_roxygen_md <-
        ensure_roxygen_md()
    }
  }

  # Ensure {lifecycle} ----------
  output$ensure_lifecycle <- ifelse(
    config$use_lifecycle,
    ensure_lifecycle(),
    FALSE
  )

  # Ensure GitHub ----------
  output$ensure_github <- ifelse(
    config$use_github,
    ensure_github(),
    FALSE
  )

  # Ensure CI platform ----------
  output$ensure_ci <- ifelse(
    config$use_ci,
    ensure_ci(
      platform = config$use_ci_platform
    ),
    FALSE
  )

  # Ensure CI test coverage
  output$ensure_ci_test_coverage <- ifelse(
    config$use_ci_test_coverage,
    ensure_ci_test_coverage(
      service = config$use_ci_test_coverage_service
    ),
    FALSE
  )

  # Ensure CI test coverage service is linked to CI platform ----------
  config$ensure_ci_test_coverage_link <- if (
    config$use_ci_test_coverage && config$use_ci
  ) {
    ensure_ci_test_coverage_link(
      ci_test_coverage_service = config$use_ci_test_coverage_service,
      ci_platform = config$use_ci_platform
    )
  } else {
    FALSE
  }

  # Ensure license ----------
  output$ensure_license <- ifelse(
    config$use_license,
    ensure_license(
      license = config$use_license_license
    ),
    FALSE
  )

  # Ensure README.Rmd is knitted ----------
  output$ensure_knit_readme <- ifelse(
    config$use_rmarkdown,
    ensure_knit_readme(),
    FALSE
  )

  # Ensure vignettes infrastructure is set up ----------
  output$ensure_vignette <- ifelse(
    config$use_rmarkdown,
    ensure_vignette(),
    FALSE
  )

  # Ensure {pkgdown} ----------
  output$ensure_pkgdown <- ifelse(
    config$use_rmarkdown,
    ensure_pkgdown(),
    FALSE
  )

  # Ensure ignore files state ----------
  output$ensure_renv_gitignore_state <-
    ensure_renv_gitignore_state()
  output$ensure_rbuildignore_state <-
    ensure_rbuildignore_state()

  # Ensure good start GitHub commit and push ----------
  output$ensure_github_push <- ifelse(
    push_to_github,
    ensure_github_push(),
    FALSE
  )

  output
}

# Ensure generic ----------------------------------------------------------

#' Generic function for ensuring things that `{goodstart}` can handle
#'
#' @param ensure_deps
#' @param add_to_suggested
#' @param fn
#' @param fn_dep
#' @param deps
#' @param deps_type
#' @param path
#' @param requires_restart
#'
#' @import usethis
#' @importFrom here here
#' @importFrom fs file_exists
#' @importFrom git2r commit
#' @importFrom renv install
#' @importFrom rlang enquos eval_tidy
ensure_generic <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  fn,
  fn_dep = NULL,
  deps = character(),
  deps_type = "Suggests",
  path = character(),
  requires_restart = FALSE
) {
  fn <- rlang::enquo(fn)
  if (length(path)) {
    path_0 <- path
    path <- path %>%
      handle_path()
  }

  if (!length(path) || !fs::file_exists(path)) {
    result <- try(
      if (inherits(fn, "quosure")) {
        rlang::eval_tidy(fn)
      } else {
        fn()
      },
      silent = TRUE
    )
    if (inherits(result, "try-error")) {
      if (length(deps) && ensure_deps) {
        usethis:::check_installed("renv")
        project <- if (get_package_name() != get_package_name(here::here())) {
          handle_path()
        } else {
          NULL
        }
        renv::install(deps, project = project)
        if (requires_restart) {
          return("restart")
        }
        if (add_to_suggested) {
          deps %>%
            purrr::map(~.x %>% usethis::use_package(type = deps_type))
        }
        out <- try(
          if (inherits(fn, "quosure")) {
            rlang::eval_tidy(fn)
          } else {
            fn()
          },
          silent = TRUE
        )
        out
      } else if (length(fn_dep)) {
        result <- try(fn_dep(), silent = TRUE)
        if (inherits(result, "try-error")) {
          git2r::commit()
        } else {
          stop("Not implemented yet")
        }
      } else {
        message(result)
        FALSE
      }
    } else {
      TRUE
    }
  } else {
    usethis::ui_done("{path_0} already exists")
    TRUE
  }
}

# Ensure package ----------------------------------------------------------

#' @import usethis
#' @importFrom renv install
ensure_package <- function(package) {
  if (!usethis:::is_installed(package)) {
    renv::install(package)
  }
  usethis:::is_installed(package)
}

# Ensure removed files ----------------------------------------------------

#' @importFrom fs file_exists file_delete
#' @importFrom usethis ui_done ui_oops
ensure_removed_file <- function(path) {
  path_0 <- path

  path <- path %>%
    handle_path()

  if (fs::file_exists(path)) {
    fs::file_delete(path)
    if (!fs::file_exists(path)) {
      usethis::ui_done("Succesfully removed {path_0}")
      TRUE
    } else {
      usethis::ui_oops("Unable to remove {path_0}")
      FALSE
    }
  } else {
    usethis::ui_done("{path_0} was already removed")
    TRUE
  }
}

#' @importFrom fs file_exists file_create
#' @importFrom usethis ui_done ui_oops
ensure_existing_file <- function(path, content = NULL) {
  path_0 <- path
  path <- path_0 %>%
    handle_path()
  if (!fs::file_exists(path)) {
    fs::file_create(path)

    # Write content if any was provided:
    if (!is.null(content)) {
      write(content, file = path)
    }

    if (fs::file_exists(path)) {
      usethis::ui_done("Succesfully created {path_0}")
      TRUE
    } else {
      usethis::ui_oops("Unable to create {path_0}")
      FALSE
    }
  } else {
    usethis::ui_done("{path_0} was already created")
    TRUE
  }
}

# Ensure example files are removed ----------------------------------------

ensure_removed_hello_r <- function() {
  "R/hello.R" %>%
    ensure_removed_file()
}

ensure_removed_hello_rd <- function() {
  "man/hello.Rd" %>%
    ensure_removed_file()
}

# Ensure default NAMESPACE is removed -------------------------------------

#' Ensure that default NAMESPACE is removed
#'
#' When `NAMESPACE` contains `exportPattern(\"^[[:alpha:]]+\")` it is removed to
#' allow `{roxygen2}` to control `NAMESPACE ` content.
#'
#' @importFrom fs file_exists
#' @importFrom usethis ui_done
#' @return [logical(1)]
#' @export
ensure_removed_namespace_default <- function() {
  path_0 <- "NAMESPACE"
  path <- path_0 %>%
    handle_path()

  namespace <- if (fs::file_exists(path)) {
    path %>%
      readLines()
  } else {
    ""
  }
  if (
    all(namespace %in% c("exportPattern(\"^[[:alpha:]]+\")", "")) ||
      !any(namespace %in% "# Generated by roxygen2: do not edit by hand")
    ) {
    path_0 %>%
      ensure_removed_file()
  } else {
    usethis::ui_done("NAMESPACE generated by {{roxygen2}}")
    FALSE
  }
}

# Ensure license ----------------------------------------------------------

#' Ensure license
#'
#' @param license
#' @param strict
#'
#' @return [logical(1)] or [character()] in case of failed try
#' @importFrom git2r config
#' @importFrom usethis use_gpl3_license
#' @export
ensure_license <- function(
  license = valid_licenses(flip = TRUE),
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  strict = TRUE
) {
  # TODO-20200511T1804: Check if badge for license file can be added to README
  license <- match.arg(license)

  # Construct license function
  expr <-  rlang::parse_expr(
    stringr::str_glue(
      "usethis::use_{license}_license(name = with(
        gert::git_config_global(), value[name == \"user.name\"]
      ))"
    )
  )

  result <- try({
    # deps <- c(
    #   "gert"
    # )
    # deps %>%
    #   handle_deps(
    #     install_if_missing = ensure_deps,
    #     add_to_desc = add_to_suggested,
    #     dep_type = valid_dep_types("Suggests")
    #   )

    ensure_generic(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      fn = expr %>% rlang::eval_tidy(),
      deps = deps
    )
  })

  handle_return_value(
    result = result,
    message = "Ensuring license failed",
    strict = strict
  )
}

# Ensure dependency management --------------------------------------------

#' Ensure dependency management
#'
#' @param package
#' @param ensure_deps
#' @param add_to_suggested
#' @param strict
#'
#' @return [logical(1)]
#' @export
ensure_dependency_management <- function(
  package = valid_dep_management_packages("renv"),
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  strict = TRUE
) {
  if (package == "renv") {
    list(
      ensure_renv_active =
        ensure_renv_active(
          ensure_deps = ensure_deps,
          add_to_suggested = add_to_suggested,
          strict = strict
        ),
      ensure_renv_upgraded =
        ensure_renv_upgraded(
          ensure_deps = ensure_deps,
          add_to_suggested = add_to_suggested,
          strict = strict
        )
    )
  } else {
    stop("Not supported yet")
  }
}

# Ensure dependency management: {renv} ------------------------------------

#' Ensure `{renv}` project is activated
#'
#' @param ensure_deps
#' @param add_to_suggested
#' @param strict
#'
#' @import usethis
#' @importFrom here here
#' @importFrom renv activate
#' @importFrom withr with_envvar
#' @export
ensure_renv_active <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  strict = TRUE
) {
  # usethis:::check_installed("renv")
  "renv" %>%
    handle_deps(
      install_if_missing = ensure_deps,
      add_to_desc = add_to_suggested,
      dep_type = valid_dep_types("Suggests")
    )

  # Distinction between `{goodstart}` and other packages
  path <- if (get_package_name() != get_package_name(here::here())) {
    handle_path()
  } else {
    NULL
  }

  # Ensure {renv} project is activated
  # To make this fail-safe, we need to ensure that the env var is not set/is NA
  withr::with_envvar(
    new = c("RENV_PROJECT" = NA),
    renv::activate(project = path)
  )
  usethis::ui_done("Package {{renv}} activated")

  TRUE
}

#' Ensure `{renv}` project is upgraded
#'
#' @param ensure_deps
#' @param add_to_suggested
#' @param strict
#'
#' @import usethis
#' @importFrom here here
#' @importFrom renv upgrade
#' @importFrom withr with_envvar
#' @export
ensure_renv_upgraded <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  strict = TRUE
) {
  # usethis:::check_installed("renv")
  "renv" %>%
    handle_deps(
      install_if_missing = ensure_deps,
      add_to_desc = add_to_suggested,
      dep_type = valid_dep_types("Suggests")
    )

  # Distinction between `{goodstart}` and other packages
  path <- if (get_package_name() != get_package_name(here::here())) {
    handle_path()
  } else {
    NULL
  }

  renv::upgrade(project = path)
  usethis::ui_done("Package {{renv}} upgraded")

  TRUE
}

# Ensure unit testing -----------------------------------------------------

#' Ensure unit testing package
#'
#' @param package
#' @param ensure_deps
#' @param add_to_suggested
#' @param strict
#'
#' @return [logical(1)]
#' @export
ensure_unit_testing <- function(
  package = valid_unit_test_packages("testthat"),
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  strict = TRUE
) {
  # if (package == "testthat") {
  #   ensure_unit_testing_testthat(
  #     ensure_deps = ensure_deps,
  #     add_to_suggested = add_to_suggested,
  #     strict = strict
  #   )
  # } else if (package == "tinytest") {
  #   stop("Package 'tinytest' is unfortunately not supporte yet")
  # }

  "ensure_unit_testing_{package}" %>%
    stringr::str_glue() %>%
    rlang::parse_expr() %>%
    rlang::call2(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      strict = strict
    ) %>%
    rlang::eval_tidy()
}

# Ensure unit testing: {testthat} -----------------------------------------

#' Ensure `{testthat}` infrastructure
#'
#' @param ensure_deps
#' @param add_to_suggested
#' @param open
#' @param strict
#' @importFrom usethis use_testthat
#' @export
ensure_unit_testing_testthat <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  # open = FALSE,
  strict = TRUE
) {
  result <- try({
    deps <- c(
      "testthat"
    )
    deps %>%
      handle_deps(
        install_if_missing = ensure_deps,
        add_to_desc = add_to_suggested,
        dep_type = valid_dep_types("Suggests")
      )

    ensure_generic(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      fn = usethis::use_testthat(),
      deps = deps
    )
  })

  handle_return_value(
    result = result,
    message = "Ensuring testthat infrastructure failed",
    strict = strict
  )
}

# Ensure unit testing: test coverage ----------------------------------------------------

#' Ensure test coverage package `{covr}`
#'
#' @param ensure_deps
#' @param add_to_suggested
#' @param strict
#'
#' @importFrom covr report
#' @export
ensure_unit_testing_test_coverage <- function(
  package = valid_unit_test_coverage_packages("covr"),
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  strict = TRUE
) {
  "ensure_unit_testing_test_coverage_{package}" %>%
    stringr::str_glue() %>%
    rlang::parse_expr() %>%
    rlang::call2(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      strict = strict
    ) %>%
    rlang::eval_tidy()
}

#' Ensure test coverage package `{covr}`
#'
#' @param ensure_deps
#' @param add_to_suggested
#' @param strict
#'
#' @importFrom covr report
#' @export
ensure_unit_testing_test_coverage_covr <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  strict = TRUE
) {
  result <- try({
    deps <- "covr"
    deps %>%
      handle_deps(
        install_if_missing = ensure_deps,
        add_to_desc = add_to_suggested,
        dep_type = valid_dep_types("Suggests")
      )

    ensure_generic(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      fn = covr::report()
    )
  })

  handle_return_value(
    result = result,
    message = "Ensurance of test coverage package {covr} failed",
    strict = strict
  )
}

# Ensure README -----------------------------------------------------------

#' Ensure README
#'
#' @param ensure_deps
#' @param add_to_suggested
#' @param open
#' @param strict
#'
#' @return [logical()]
#' @export
ensure_readme <- function(
  type = valid_readme_types("rmd"),
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  open = rlang::is_interactive(),
  strict = TRUE
) {
  "ensure_readme_{type}" %>%
    stringr::str_glue() %>%
    rlang::parse_expr() %>%
    rlang::call2(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      open = open,
      strict = strict
    ) %>%
    rlang::eval_tidy()
}

#' Ensure README.Rmd exists and is populated based on project data
#'
#' @param ensure_deps
#' @param add_to_suggested
#' @param open
#' @param strict
#'
#' @return [logical()]
#'
#' @importFrom fs file_exists
#' @importFrom renv install
#' @importFrom rlang is_interactive
#' @importFrom usethis use_readme_rmd use_package ui_done
#' @export
ensure_readme_rmd <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  open = rlang::is_interactive(),
  strict = TRUE
) {
  result <- try({
    deps <- c(
      "rmarkdown",
      "whisker"
    )
    deps %>%
      handle_deps(
        install_if_missing = ensure_deps,
        add_to_desc = add_to_suggested,
        dep_type = valid_dep_types("Suggests")
      )

    ensure_generic(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      fn = use_readme_rmd(open = open),
      deps = deps,
      path = "README.Rmd"
    )
  })

  handle_return_value(
    result = result,
    message = "Ensurance of README.Rmd failed",
    strict = strict
  )
}

#' Ensure README.md exists and is populated based on project data
#'
#' @param ensure_deps
#' @param add_to_suggested
#' @param open
#' @param strict
#'
#' @return [logical()]
#' @importFrom fs file_exists
#' @importFrom renv install
#' @importFrom rlang is_interactive
#' @importFrom usethis use_readme_rmd use_package ui_done
#' @export
ensure_readme_md <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  open = rlang::is_interactive(),
  strict = TRUE
) {
  result <- try({
    deps <- c(
      # "rmarkdown",
      # "whisker"
    )
    deps %>%
      handle_deps(
        install_if_missing = ensure_deps,
        add_to_desc = add_to_suggested,
        dep_type = valid_dep_types("Suggests")
      )

    ensure_generic(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      fn = use_readme_md(open = open),
      deps = deps,
      path = "README.md"
    )
  })

  handle_return_value(
    result = result,
    message = "Ensurance of README.md failed",
    strict = strict
  )
}

#' @export
ensure_knit_readme <- function() {
  suppressMessages(knit_readme())
  TRUE
}

# Ensure NEWS -------------------------------------------------------------

#' @importFrom fs file_exists
#' @importFrom usethis use_news_md
ensure_news_md <- function(
  open = rlang::is_interactive()
) {
  path_0 <- "NEWS.md"
  path <- path_0 %>%
    handle_path()

  usethis::use_news_md(open = open)
  if (fs::file_exists(path)) {
    TRUE
  } else {
    FALSE
  }
}

# Ensure BACKLOG ----------------------------------------------------------

#' Ensure BACKLOG.Rmd
#'
#' @param open
#'
#' @return [logical(1)]
#' @importFrom fs file_exists
#' @importFrom usethis use_news_md
#' @export
ensure_backlog_rmd <- function(
  open = rlang::is_interactive()
) {
  path_0 <- "BACKLOG.Rmd"
  path <- path_0 %>%
    handle_path()

  use_backlog_rmd(open = open)

  fs::file_exists(path) %>% unname()
}

# Ensure roxygen ----------------------------------------------------------

#' Ensure Roxygen documentation via `{roxygen2}` is enabled

#' @param ensure_deps
#' @param add_to_suggested
#'
#' @export
ensure_roxygen <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE
) {
  ensure_generic(
    ensure_deps = ensure_deps,
    add_to_suggested = add_to_suggested,
    fn = use_roxygen(),
    deps = "roxygen2"
  )
}

# Ensure markdown in roxygen code -----------------------------------------

#' @importFrom usethis use_roxygen_md
#' @export
ensure_roxygen_md <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE
) {
  ensure_generic(
    ensure_deps = ensure_deps,
    add_to_suggested = add_to_suggested,
    fn = usethis::use_roxygen_md(),
    deps = "roxygen2"
  )
}

#' #' @importFrom roxygen2md roxygen2md
#' ensure_roxygen2md <- function(
#'   ensure_deps = TRUE,
#'   add_to_suggested = TRUE
#' ) {
#'   ensure_generic(
#'     ensure_deps = ensure_deps,
#'     add_to_suggested = add_to_suggested,
#'     fn = roxygen2md::roxygen2md(),
#'     deps = "roxygen2md"
#'   )
#' }

# Ensure NAMESPACE by roxygen2 --------------------------------------------

#' @importFrom roxygen2 roxygenize
#' @export
ensure_roxygen_namespace <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  strict = TRUE
) {
  result <- try({
    # usethis:::check_installed("roxygen2")
    deps <- c("roxygen2", "commonmark")
    capture.output(
      deps %>%
        handle_deps(
          install_if_missing = ensure_deps,
          add_to_desc = add_to_suggested,
          dep_type = valid_dep_types("Suggests")
        )
    )
    roxygen2::roxygenize()
  })

  handle_return_value(
    result = result,
    message = "Ensurance of roxygen-based NAMESPACE failed",
    strict = strict
  )
}

# Ensure {lifecycle} ------------------------------------------------------

#' @importFrom clipr clipr_available read_clip clear_clip
#' @importFrom fs path
#' @importFrom stringr str_glue
#' @importFrom usethis use_lifecycle use_lifecycle_badge
#' @export
ensure_lifecycle <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE
) {
  deps <- c(
    "clipr"
  )
  deps %>%
    handle_deps(
      install_if_missing = ensure_deps,
      add_to_desc = add_to_suggested,
      dep_type = valid_dep_types("Suggests")
    )

  package_name <- get_package_name()

  path_0 <- fs::path("R", stringr::str_glue("{package_name}-package.R"))
  path <- path_0 %>%
    handle_path()
  path %>%
    ensure_existing_file()

  result <- ensure_generic(
    ensure_deps = ensure_deps,
    add_to_suggested = add_to_suggested,
    fn = usethis::use_lifecycle(),
    deps = "r-lib/usethis",
    requires_restart = TRUE
  )

  if (result == "restart") {
    # stop("Restart case not implemented yet")
  }
  # TODO: align with scenario that requires a restart (e.g. if wrong {usethis}
  # version is installed)

  # if (clipr::clipr_available(allow_non_interactive = TRUE)) {
  #   content <- suppressWarnings(clipr::read_clip(allow_non_interactive = TRUE))
  #   content %>%
  #     write(file = path)
  #   clipr::clear_clip(allow_non_interactive_use = TRUE)
  # } else {
  #   add_lifecycle_to_package_doc()
  # }
  # TODO-20200508T0739: Can't get the clipboard to work in a consistent manner
  # (interactive vs. non-interactive use differs)
  add_lifecycle_to_package_doc()

  usethis::use_lifecycle_badge("experimental")

  TRUE
}

# Ensure GitHub remote ----------------------------------------------------

#' @importFrom usethis use_git
#' @export
ensure_github <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  strict = TRUE
) {
  # Ensure dependency
  deps <- "gert"
  capture.output(
    deps %>%
      handle_deps(
        install_if_missing = ensure_deps,
        add_to_desc = add_to_suggested,
        dep_type = valid_dep_types("Suggests")
      )
  )

  # Initialize:
  usethis::use_git()

  # Ensure git remote:
  out <- ensure_git_remote(strict = strict)

  if (FALSE) {
    # Ensure git add all:
    ensure_git_add_all(strict = strict)

    # Ensure git fetch:
    ensure_git_fetch(strict = strict)

    # Ensure git commit:
    ensure_git_commit(strict = strict)

    # Ensure git push:
    ensure_git_push(force = TRUE, strict = strict)
  }

  out
}

# Ensure CI ---------------------------------------------------------------

#' Ensure Continuous Integration
#'
#' @param platform
#' @param ensure_deps
#' @param add_to_suggested
#' @param strict
#'
#' @return [logical(1)]
#' @export
ensure_ci <- function(
  platform = valid_ci_platforms("github_actions"),
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  # open = FALSE,
  strict = TRUE
) {
  if (platform == "github_actions") {
    ensure_github_actions(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      strict = strict
    )
  } else if (platform == "travis_ci") {
    warning("Platform '{platform}' not explicitly integrated into `{{goodstart}}`.
      Falling back on `{{usethis::use_travis()}}`" %>% stringr::str_glue())
    usethis::use_travis()
  } else if (platform == "appveyor") {
    warning("Platform '{platform}' not explicitly integrated into `{{goodstart}}`.
      Falling back on `{{usethis::use_appveyor()}}`" %>% stringr::str_glue())
    usethis::use_appveyor()
  }
}

# Ensure CI: GitHub Actions -----------------------------------------------

#' @importFrom usethis use_github_action_check_standard
#' @export
ensure_github_actions <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  strict = TRUE
) {
  result <- try({
    ensure_generic(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      # fn = usethis::use_github_actions()
      fn = usethis::use_github_action_check_standard()
    )
  })

  handle_return_value(
    result = result,
    message = "Ensurance of GitHub Actions failed",
    strict = strict
  )
}

# Ensure CI: test coverage service ----------------------------------------

#' Ensure Continuous Integration test coverage
#'
#' @param service
#' @param ensure_deps
#' @param add_to_suggested
#' @param strict
#'
#' @return [logical(1)]
#' @export
ensure_ci_test_coverage <- function(
  service = valid_ci_test_coverage_services("codecov"),
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  # open = FALSE,
  strict = TRUE
) {
  if (service %in%
      valid_ci_test_coverage_services(c("codecov", "coveralls"))
    ) {
    ensure_ci_test_coverage_(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      strict = strict
    )
  } else {
    stop("Service '{service}' not supported yet")
  }
}

#' Ensure Continuous Integration test coverage
#'
#' @param service
#' @param ensure_deps
#' @param add_to_suggested
#' @param strict
#'
#' @return [logical(1)]
#'
#' @importFrom usethis use_coverage
#' @export
ensure_ci_test_coverage_ <- function(
  service = valid_ci_test_coverage_services("codecov"),
  ensure_deps = TRUE,
  add_to_suggested = TRUE,
  strict = TRUE
) {
  result <- try({
    deps <- "covr"
    deps %>%
      handle_deps(
        install_if_missing = ensure_deps
      )

    ensure_generic(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      fn = usethis::use_coverage(type = service)
    )
  })

  handle_return_value(
    result = result,
    message = "Ensurance of CI test coverage failed",
    strict = strict
  )
}

# Ensure CI: linking platform to test coverage service --------------------

#' Ensure CI test coverage service is linked to CI platform
#'
#' @param ci_test_coverage_service
#' @param ci_platform
#'
#' @return
#' @importFrom stringr str_glue
#' @export
ensure_ci_test_coverage_link <- function(
  ci_test_coverage_service = valid_ci_test_coverage_services("codecov"),
  ci_platform = valid_ci_platforms("github_actions")
) {
  if (ci_test_coverage_service == valid_ci_test_coverage_services("codecov") &&
      ci_platform == valid_ci_platforms("github_actions")
  ) {
    # Add GitHub Actions workflow
    modify_github_actions_workflow_add_codecov()
  } else {
    "Combination of CI platform '{ci_platform}' and CI test coverage service '{ci_test_coverage_service}' is not supported yet" %>%
      stringr::str_glue()
  }
}

# Ensure {pkgdown} -------------------------------------------------------

#' @importFrom usethis use_pkgdown use_github_action
#' @export
ensure_pkgdown <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE
) {
  result <- try({
    deps <- "pkgdown"
    deps %>%
      handle_deps(
        install_if_missing = ensure_deps,
        add_to_desc = add_to_suggested,
        dep_type = valid_dep_types("Suggests")
      )

    ensure_generic(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      fn = usethis::use_pkgdown()
    )

    # fn <- purrr::partial(usethis::use_github_action, name = "pkgdown")
    ensure_generic(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      # fn = fn
      fn = usethis::use_github_action(name = "pkgdown")
    )
  })

  handle_return_value(
    result = result,
    message = "Ensurance of {{pkgdown}} setup failed",
    strict = TRUE
  )
}

# Ensure vignette ---------------------------------------------------------

#' @importFrom usethis use_vignette
#' @export
ensure_vignette <- function(
  ensure_deps = TRUE,
  add_to_suggested = TRUE
) {
  result <- try({
    # deps <- "pkgdown"
    # deps %>%
    #   handle_deps(
    #     install_if_missing = ensure_deps,
    #     add_to_desc = add_to_suggested,
    #     dep_type = valid_dep_types("Suggests")
    #   )

    use_vignette_partial <- purrr::partial(
      usethis::use_vignette,
      name = get_package_name()
    )

    ensure_generic(
      ensure_deps = ensure_deps,
      add_to_suggested = add_to_suggested,
      # fn = use_vignette_partial
      fn = usethis::use_vignette(name = get_package_name())
      # deps = deps
    )
  })

  handle_return_value(
    result = result,
    message = "Ensurance of vignette setup failed",
    strict = TRUE
  )
}

# Ensure ignore files state -----------------------------------------------

#' @export
ensure_renv_gitignore_state <- function(strict = TRUE) {
  result <- try(
    c(
      "library/",
      "python/",
      "staging/",
      "cache/",
      "cache_docker/",
      "local/"
    ) %>%
      modify_ignore_file("renv/.gitignore", escape = FALSE)
  )

  handle_return_value(
    result = result,
    message = "Ensurance of renv/.gitignore state failed",
    strict = strict
  )
}

#' @export
ensure_rbuildignore_state <- function(strict = TRUE) {
  result <- try(
    c(
      "renv",
      "renv.lock",
      ".*.Rproj",
      ".Rproj.user",
      "README.Rmd",
      "BACKLOG.Rmd",
      "codecov.yml",
      ".github",
      "LICENSE.md",
      "_pkgdown.yml",
      "docs",
      "pkgdown",
      "data",
      "scripts",
      "build.R"
    ) %>%
      modify_ignore_file(".Rbuildignore", escape = TRUE)
  )

  handle_return_value(
    result = result,
    message = "Ensurance of .Rbuildignore state failed",
    strict = strict
  )
}

# Ensure GitHub push ------------------------------------------------------

#' @export
ensure_github_push <- function(strict = TRUE) {
  ensure_git_add_all(strict = strict)
  ensure_git_fetch(strict = strict)
  ensure_git_commit(
    # message = stringr::str_glue("GitHub Actions ({Sys.time()}))"),
    strict = strict
  )
  ensure_git_push(force = TRUE, strict = strict)
}
