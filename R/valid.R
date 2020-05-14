valid_generic_ <- function(
  choice = character(),
  choices = character(),
  flip = FALSE
) {
  out <- if (length(choice)) {
    # if (choice %in% names(choices)) {
    #   choices[choice]
    # }

    # Try via names
    out <- choices[choice]
    if (any(is.na(out))) {
      # Try via element matching
      out <- choices[choices == choice]
    }
    out
  } else {
    choices
  }

  if (!flip) {
    out
  } else {
    # Flip names and values
    out <- out %>% flip_values_and_names()
  }
}

valid_yes_no <- function(choice = character(), flip = FALSE) {
  valid_generic_(
    choice = choice,
    choices = c(
      yes = "Yes",
      no = "No"
    ),
    flip = flip
  )
}

valid_again_exit <- function(choice = character(), flip = FALSE) {
  valid_generic_(
    choice = choice,
    choices = c(
      again = "Let me start over",
      exit = "Exit"
    ),
    flip = flip
  )
}

valid_none <- function(choice = character(), flip = FALSE) {
  valid_generic_(
    choice = choice,
    choices = c(
      none = "None"
    ),
    flip = flip
  )
}

valid_yes_no_again_exit <- function(choice = character(), flip = FALSE) {
  valid_generic_(
    choice = choice,
    choices = c(
      valid_yes_no(),
      valid_again_exit()
    ),
    flip = flip
  )
}

valid_licenses <- function(license = character(), flip = FALSE) {
  licenses <- c("GPL v3", "MIT", "CC0", "CCBY 4.0", "LGPL v3", "APL 2.0", "AGPL v3")
  names <- c("gpl3", "mit", "cc0", "ccby", "lgpl", "apl2", "agpl3")
  names(licenses) <- names
  valid_generic_(
    choice = license,
    choices = licenses,
    flip = flip
  )
}

valid_unit_test_packages <- function(package = character(), flip = FALSE) {
  packages <- c("testthat", "tinytest")
  names(packages) <- packages
  valid_generic_(
    choice = package,
    choices = packages,
    flip = flip
  )
}

valid_unit_test_coverage_packages <- function(package = character(), flip = FALSE) {
  packages <- c("covr")
  names(packages) <- packages
  valid_generic_(
    choice = package,
    choices = packages,
    flip = flip
  )
}

valid_dep_management_packages <- function(package = character(), flip = FALSE) {
  packages <- c("renv")
  names(packages) <- packages
  valid_generic_(
    choice = package,
    choices = packages,
    flip = flip
  )
}

valid_ci_platforms <- function(platform = character(), flip = FALSE) {
  platforms <- c("github_actions", "travis_ci", "appveyor")
  names(platforms) <- platforms
  valid_generic_(
    choice = platform,
    choices = platforms,
    flip = flip
  )
}

valid_ci_test_coverage_services <- function(platform = character(), flip = FALSE) {
  platforms <- c("codecov", "coveralls")
  names(platforms) <- platforms
  valid_generic_(
    choice = platform,
    choices = platforms,
    flip = flip
  )
}

valid_authentication <- function(auth = character(), flip = FALSE) {
  auths <- c("ssh", "https")
  names(auths) <- auths
  valid_generic_(
    choice = auth,
    choices = auths,
    flip = flip
  )
}

valid_dep_types <- function(type = character(), flip = FALSE) {
  types <- c("Suggests", "Imports", "Depends", "Enhances", "LinkingTo")
  names(types) <- types
  valid_generic_(
    choice = type,
    choices = types,
    flip = flip
  )
}

valid_readme_types <- function(type = character(), flip = FALSE) {
  types <- c("rmd", "md")
  names(types) <- types
  valid_generic_(
    choice = type,
    choices = types,
    flip = flip
  )
}
