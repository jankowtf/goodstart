# Ask ---------------------------------------------------------------------

#' Ask user preferences
#'
#' @param minimal [logical(1)] Reduce the questions to just the essentials
#'
#' @return
#' @import usethis
#' @importFrom rlang is_interactive
#' @export
ask <- function(
  minimal = FALSE
) {
  if (!rlang::is_interactive()) {
    return(usethis::ui_info("I can only ask you interactively"))
  }

  step <- 0
  steps_max <- 10
  answers_default <- goodstart_config()

  # Roxygen ----------

  step <- step + 1
  if (!minimal) {
    ask_roxygen_preamble(step = step, steps_max = steps_max)
  }
  answer <- ask_roxygen(
    step = step,
    steps_max = steps_max,
    minimal = minimal
  )

  # Handle answer
  if (answer == valid_again_exit("exit", flip = TRUE)) {
    return("Exited")
  } else if (answer == valid_again_exit("again", flip = TRUE)) {
    answer <- Recall(minimal = minimal)
    if (answer == valid_again_exit("exit", flip = TRUE)) {
      return("Exited")
    }
  }

  # answer <- handle_answer(answer, type = "outer", env = environment())
  # answer %>%
  #   rlang::eval_tidy()
  # TODO-20200508T0941: Abstracting the last if ... else away would be nice, but
  # I can't get `return()` and `Recall()` to work when they're not called in the
  # "correct" frame

  # R Markdown ----------

  step <- step + 1
  if (!minimal) {
    ask_rmarkdown_preamble(step = step, steps_max = steps_max)
  }
  answer <- ask_rmarkdown(
    step = step,
    steps_max = steps_max,
    minimal = minimal
  )

  # Handle answer
  if (answer == valid_again_exit("exit", flip = TRUE)) {
    return("Exited")
  } else if (answer == valid_again_exit("again", flip = TRUE)) {
    answer <- Recall(minimal = minimal)
    if (answer == valid_again_exit("exit", flip = TRUE)) {
      return("Exited")
    }
  }

  # License ----------

  if (!minimal) {
    step <- step + 1
    ask_license_preamble(step = step, steps_max = steps_max)
  }
  answer <- ask_license(
    step = step,
    steps_max = steps_max,
    minimal = minimal
  )

  # Handle answer
  if (answer == valid_again_exit("exit", flip = TRUE)) {
    return("Exited")
  } else if (answer == valid_again_exit("again", flip = TRUE)) {
    answer <- Recall(minimal = minimal)
    if (answer == valid_again_exit("exit", flip = TRUE)) {
      return("Exited")
    }
  }

  # Unit testing ----------

  step <- step + 1
  if (!minimal) {
    ask_unit_testing_preamble(step = step, steps_max = steps_max)
  }
  answer <- ask_unit_testing(
    step = step,
    steps_max = steps_max,
    minimal = minimal
  )

  # Handle answer
  if (answer == valid_again_exit("exit", flip = TRUE)) {
    return("Exited")
  } else if (answer == valid_again_exit("again", flip = TRUE)) {
    answer <- Recall(minimal = minimal)
    if (answer == valid_again_exit("exit", flip = TRUE)) {
      return("Exited")
    }
  }

  # Unit testing: test coverage ----------

  step <- step + 1
  if (!minimal) {
    ask_unit_testing_coverage_preamble(step = step, steps_max = steps_max)
  }
  answer <- ask_unit_testing_coverage(
    step = step,
    steps_max = steps_max,
    minimal = minimal
  )

  # Handle answer
  if (answer == valid_again_exit("exit", flip = TRUE)) {
    return("Exited")
  } else if (answer == valid_again_exit("again", flip = TRUE)) {
    answer <- Recall(minimal = minimal)
    if (answer == valid_again_exit("exit", flip = TRUE)) {
      return("Exited")
    }
  }

  # Dependency management ----------

  step <- step + 1
  if (!minimal) {
    ask_dep_management_preamble(step = step, steps_max = steps_max)
  }
  answer <- ask_dep_management(
    step = step,
    steps_max = steps_max,
    minimal = minimal
  )

  # Handle answer
  if (answer == valid_again_exit("exit", flip = TRUE)) {
    return("Exited")
  } else if (answer == valid_again_exit("again", flip = TRUE)) {
    answer <- Recall(minimal = minimal)
    if (answer == valid_again_exit("exit", flip = TRUE)) {
      return("Exited")
    }
  }

  # GitHub ----------

  if (!minimal) {
    step <- step + 1
    ask_github_preamble(step = step, steps_max = steps_max)
  }
  answer <- ask_github(
    step = step,
    steps_max = steps_max,
    minimal = minimal
  )

  # Handle answer
  if (answer == valid_again_exit("exit", flip = TRUE)) {
    return("Exited")
  } else if (answer == valid_again_exit("again", flip = TRUE)) {
    answer <- Recall(minimal = minimal)
    if (answer == valid_again_exit("exit", flip = TRUE)) {
      return("Exited")
    }
  }

  # Continuous integration ----------

  if (!minimal) {
    step <- step + 1
    ask_ci_preamble(step = step, steps_max = steps_max)
  }
  answer <- ask_ci(
    step = step,
    steps_max = steps_max,
    minimal = minimal
  )

  # Handle answer
  if (answer == valid_again_exit("exit", flip = TRUE)) {
    return("Exited")
  } else if (answer == valid_again_exit("again", flip = TRUE)) {
    answer <- Recall(minimal = minimal)
    if (answer == valid_again_exit("exit", flip = TRUE)) {
      return("Exited")
    }
  }

  # Continuous integration: test coverage ----------

  step <- step + 1
  if (!minimal) {
    ask_ci_test_coverage_preamble(step = step, steps_max = steps_max)
  }
  answer <- ask_ci_test_coverage(
    step = step,
    steps_max = steps_max,
    minimal = minimal
  )

  # Handle answer
  if (answer == valid_again_exit("exit", flip = TRUE)) {
    return("Exited")
  } else if (answer == valid_again_exit("again", flip = TRUE)) {
    answer <- Recall(minimal = minimal)
    if (answer == valid_again_exit("exit", flip = TRUE)) {
      return("Exited")
    }
  }

  # # GitHub Actions ----------
  #
  # if (!minimal) {
  #   step <- step + 1
  #   ask_github_actions_preamble(step = step, steps_max = steps_max)
  # }
  # answer <- ask_github_actions(
  #   step = step,
  #   steps_max = steps_max,
  #   minimal = minimal
  # )

  # Handle answer
  # if (answer == valid_again_exit("exit", flip = TRUE)) {
  #   return("Exited")
  # } else if (answer == valid_again_exit("again", flip = TRUE)) {
  #   Recall()
  # }

  # Lifecycle ----------

  if (!minimal) {
    step <- step + 1
    ask_lifecycle_preamble(step = step, steps_max = steps_max)
  }
  answer <- ask_lifecycle(
    step = step,
    steps_max = steps_max,
    minimal = minimal
  )

  # Handle answer
  if (answer == valid_again_exit("exit", flip = TRUE)) {
    return("Exited")
  } else if (answer == valid_again_exit("again", flip = TRUE)) {
    answer <- Recall(minimal = minimal)
    if (answer == valid_again_exit("exit", flip = TRUE)) {
      return("Exited")
    }
  }

  # Return value ----------

  fields <- getOption(skeval__store_name()) %>% as.list()

  fields[answers_default %>% names()]
}

# Ask roxygen -------------------------------------------------------------

ask_roxygen_preamble <- function(
  title = "Roxygen",
  step = 1,
  steps_max = 1
) {
  ui_header(title = title, step = step, steps_max = steps_max)

  "Great documentation makes a huge difference - not just for others, but also for \"future you\"." %>%
    ui_glue_wrap_field() %>%
    ui_glue_wrap_line()
  message()
  "Using package {usethis::ui_code(quote(roxygen2))} (https://roxygen2.r-lib.org/) makes documenting your package easy and fun.
  It offers you a straightforward syntax (optionally including markdown), provides you with a number of convenient helpers and takes care of managing your {usethis::ui_field('NAMESPACE')} file." %>%
    ui_glue_wrap_line()
  message()

  ui_answering_yes_implies() %>%
    usethis::ui_line()
  message()
  "Package {usethis::ui_code('roxygen2')} will be installed if necessary" %>%
    ui_glue_wrap_done()
  "Package {usethis::ui_code(quote(roxygen2))} will be added to {usethis::ui_field('Suggests')} section of your {usethis::ui_field('DESCRIPTION')} file" %>%
    ui_glue_wrap_done()
  "Line {usethis::ui_field('RoxygenNote: {{x.y.z}}')} will be added to your {usethis::ui_field('DESCRIPTION')} file" %>%
    ui_glue_wrap_done()
  "[NOT ENSURED YET] RStudio settings are modified to put {usethis::ui_code(quote(roxygen2))} in charge of documenting and vignette building" %>%
    ui_glue_wrap_done()
  message()
}

ask_roxygen <- function(
  title = "Roxygen",
  step = 1,
  steps_max = 1,
  minimal = Sys.getenv("R_GOODSTART_MINIMAL", "FALSE") %>% as.logical()
) {
  # Inform
  if (minimal) {
    ui_header(title = title, step = step, steps_max = steps_max)
  }

  # Ask
  # use_roxygen <-
  #   "Do you want to use package {usethis::ui_code(quote(roxygen2))} for documenting tasks?" %>%
  #   stringr::str_glue() %>%
  #   stringr::str_wrap() %>%
  #   usethis::ui_field() %>%
  #   usethis::ui_yeah(
  #     yes = "Yes",
  #     no = "No",
  #     n_yes = 1,
  #     n_no = 1,
  #     shuffle = FALSE
  #   )
  # Keep for reference

  # Ask
  answer <-
    select.list(
      choices = valid_yes_no_again_exit(),
      preselect = valid_yes_no_again_exit("yes"),
      title = {
        "Do you want to use package {usethis::ui_code(quote(roxygen2))} for documenting tasks?" %>%
          ui_glue_wrap_field()
      }
    )
  message()

  # Handle answer
  answer <- answer %>% handle_answer()
  if (answer %in% valid_again_exit(flip = TRUE)) {
    return(answer)
  }

  # Persist answer
  use_roxygen <- answer %>% is_answer_true_false()
  skeval__create_value(use_roxygen)
}

# Ask R Markdown ----------------------------------------------------------

ask_rmarkdown_preamble <- function(
  title = "NEWS.md",
  step = 1,
  steps_max = 1
) {
  ui_header(title = title, step = step, steps_max = steps_max)

  "Using R Markdown (https://rmarkdown.rstudio.com/) makes your developer life so much easier." %>%
    ui_glue_wrap_field() %>%
    ui_glue_wrap_line()
  message()
  "It offers you a very expressive syntax, makes it easy to write vignettes and ties in excellently
  with {usethis::ui_code(quote(roxygen2))} code (see https://roxygen2.r-lib.org/articles/markdown.html)." %>%
    ui_glue_wrap_line()
  message()

  ui_answering_yes_implies() %>%
    usethis::ui_line()
  message()
  "Packages {usethis::ui_code(quote(rmarkdown))}, {usethis::ui_code(quote(whisker))} and {usethis::ui_code(quote(knitr))} will be installed if necessary" %>%
    ui_glue_wrap_done()
  "Packages {usethis::ui_code(quote(rmarkdown))}, {usethis::ui_code(quote(whisker))} and {usethis::ui_code(quote(knitr))} will be added to the {usethis::ui_field('Suggests')} section of your {usethis::ui_field('DESCRIPTION')} file" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "Line {usethis::ui_field('VignetteBuilder: knitr')} will be added to your {usethis::ui_field('DESCRIPTION')} file" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "If you said {usethis::ui_field('Yes')} to {usethis::ui_code('roxygen2')} then line {usethis::ui_field(\"Roxygen: list(markdown = TRUE)\")} will be added to your {usethis::ui_field('DESCRIPTION')} file" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  message()
}

ask_rmarkdown <- function(
  title = "R Markdown",
  step = 1,
  steps_max = 1,
  minimal = Sys.getenv("R_GOODSTART_MINIMAL", "FALSE") %>% as.logical()
) {
  # Inform
  if (minimal) {
    ui_header(title = title, step = step, steps_max = steps_max)
  }

  # use_rmarkdown <-
  #   "Do you want to use R Markdown throughout your package?" %>%
  #   stringr::str_glue() %>%
  #   stringr::str_wrap() %>%
  #   usethis::ui_field() %>%
  #   usethis::ui_yeah(
  #     yes = "Yes",
  #     no = "No",
  #     n_yes = 1,
  #     n_no = 1,
  #     shuffle = FALSE
  #   )
  # message()
  #
  # skeval__create_value(use_rmarkdown)

  # Ask
  answer <-
    select.list(
      choices = valid_yes_no_again_exit(),
      preselect = valid_yes_no_again_exit("yes"),
      title = {
        "Do you want to use R Markdown throughout your package?" %>%
          ui_glue_wrap_field()
      }
    )
  message()

  # Handle answer
  answer <- answer %>% handle_answer()
  if (answer %in% valid_again_exit(flip = TRUE)) {
    return(answer)
  }

  # Persist answer
  use_rmarkdown <- answer %>% is_answer_true_false()
  skeval__create_value(use_rmarkdown)
}


# Ask license -------------------------------------------------------------

ask_license_preamble <- function(
  title = "License",
  step = 1,
  steps_max = 1
) {
  ui_header(title = title, step = step, steps_max = steps_max)

  "You should be using a license to make it explicit how you would like your code to be used and shared." %>%
    ui_glue_wrap_field() %>%
    ui_glue_wrap_line()
  message()
  "Check out" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_line()
  "- http://r-pkgs.had.co.nz/description.html#license" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "- https://www.r-project.org/Licenses/" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "for details on open source software licenses." %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_line()
  message()

  ui_answering_yes_implies() %>%
    usethis::ui_line()
  message()
  "You are asked which license type you want to use. If you are not sure then {usethis::ui_field('GPL-3')} is a good choice" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "The line {usethis::ui_field('License: {{license_type}}')} will added to your {usethis::ui_field('DESCRIPTION')} file" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()

  message()
}

ask_license <- function(
  title = "License",
  step = 1,
  steps_max = 1,
  minimal = Sys.getenv("R_GOODSTART_MINIMAL", "FALSE") %>% as.logical()
) {
  # Inform
  if (minimal) {
    ui_header(title = title, step = step, steps_max = steps_max)
  }
  "Which license would you like to use?" %>%
    ui_glue_wrap_field()
  "(If you're not sure then {usethis::ui_field('gpl3')} is a good choice)" %>%
    ui_glue_wrap_field()

  # Ask
  answer <- select.list(
    choices = c(valid_licenses(), valid_none(), valid_again_exit()),
    preselect = valid_licenses("gpl3"),
    title = {
      "Which license would you like to use?" %>%
        ui_glue_wrap_field()
    }
  )
  message()

  # Handle answer
  answer <- answer %>% handle_answer()
  if (answer %in% valid_again_exit(flip = TRUE)) {
    return(answer)
  }

  # Persist answer
  use_license <- answer %>% is_answer_true_false()
  skeval__create_value(use_license)
  skeval__create_value(answer %>% flip_values_and_names() %>% unname(),
    "use_license_license")
}

# Ask unit testing --------------------------------------------------------

ask_unit_testing_preamble <- function(
  title = "Unit testing",
  step = 1,
  steps_max = 1
) {
  ui_header(title = title, step = step, steps_max = steps_max)

  "Unit testing is crucial if you're serious about continuous integration (CI) as it gives you the confidence of iteratively improving code and adding new features. If you break things, you'll immediately know and can triage where and why things went wrong." %>%
    ui_glue_wrap_field() %>%
    ui_glue_wrap_line()
  message()
  "Package {usethis::ui_code('testthat')} offers you a sophisticated framework for unit testing and plays nice with all major continuous integration (CI) platforms such as" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_line()
  "- https://travis-ci.org/" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "- https://www.appveyor.com/" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "- https://github.com/features/actions " %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "via integration with https://codecov.io/ or https://coveralls.io/" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_line()
  message()
  "Package {usethis::ui_code('tinytest')} is an alternative, but it is currently not further integrated with {usethis::ui_code('goodstart')}." %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_line()
  message()

  ui_answering_yes_implies() %>%
    usethis::ui_line()
  message()
  "The selected package will be installed if necessary" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "Unit test infrastructure will be created within directory {usethis::ui_path('tests')}" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "The selected package will be added to the {usethis::ui_field('Suggests')} section of your {usethis::ui_field('DESCRIPTION')} file" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()

  message()
}

ask_unit_testing <- function(
  title = "Unit testing",
  step = 1,
  steps_max = 1,
  minimal = Sys.getenv("R_GOODSTART_MINIMAL", "FALSE") %>% as.logical()
) {
  # Inform
  if (minimal) {
    ui_header(title = title, step = step, steps_max = steps_max)
  }

  # Ask
  answer <- select.list(
    choices = c(valid_unit_test_packages(), valid_none(), valid_again_exit()),
    preselect = packages("testthat"),
    title = {
      "Which unit test package would you like to use?
      If you're not sure then 'testthat' is a good choice." %>%
        ui_glue_wrap_field()
    }
  )
  message()

  # Handle answer
  answer <- answer %>% handle_answer()
  if (answer %in% valid_again_exit(flip = TRUE)) {
    return(answer)
  }

  # Persist answer
  use_unit_testing <- answer %>% is_answer_true_false()
  skeval__create_value(use_unit_testing)
  skeval__create_value(answer %>% unname(), "use_unit_testing_package")
}

# Ask unit testing coverage -----------------------------------------------

ask_unit_testing_coverage_preamble <- function(
  title = "Unit testing: test coverage",
  step = 1,
  steps_max = 1
) {
  ui_header(title = title, step = step, steps_max = steps_max)

  "An important part of sincere continuous integration (CI) efforts is keeping tabs on the proportion of your code that is tested via unit tests - or test coverage in short." %>%
    ui_glue_wrap_field() %>%
    ui_glue_wrap_line()
  message()
  "Package {usethis::ui_code(quote(covr))} provides an excellent framework for that.
  It also integrates nicely with CI test coverage services such as" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_line()
  "- https://codecov.io/" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "- https://coveralls.io/" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  message()

  ui_answering_yes_implies() %>%
    usethis::ui_line()
  message()
  "Prerequisites:" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "- You've said {usethis::ui_field('Yes')} to unit testing" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  message()
}

ask_unit_testing_coverage <- function(
  title = "Unit testing: test coverage",
  step = 1,
  steps_max = 1,
  minimal = Sys.getenv("R_GOODSTART_MINIMAL", "FALSE") %>% as.logical()
) {
  # Inform
  if (minimal) {
    ui_header(title = title, step = step, steps_max = steps_max)
  }

  # Ask
  answer <- select.list(
    choices = c(valid_unit_test_coverage_packages(), valid_none(), valid_again_exit()),
    preselect = valid_unit_test_coverage_packages("covr"),
    title = {
      "Do you want to use a test coverage package?" %>%
      ui_glue_wrap_field()
    }
  )
  message()

  # Handle answer
  answer <- answer %>% handle_answer()
  if (answer %in% valid_again_exit(flip = TRUE)) {
    return(answer)
  }

  # Persist answer
  use_unit_testing_coverage <- answer %>% is_answer_true_false()
  skeval__create_value(use_unit_testing_coverage)
  skeval__create_value(answer %>% unname(), "use_unit_testing_coverage_package")
}

# Ask dependency management -----------------------------------------------

ask_dep_management_preamble <- function(
  title = "Dependency management",
  step = 1,
  steps_max = 1
) {
  ui_header(title = title, step = step, steps_max = steps_max)

  "Systematically tracking tracking the exact state (i.e. version and where it was installed from) of all the packages that your package depends on is highly recommended. Using a dependency management framework greatly facilitates colloboration as it lets others easily reproduce the exact same dependency state when you share your code with them." %>%
    ui_glue_wrap_field() %>%
    ui_glue_wrap_line()
  message()
  "Using package {usethis::ui_code(quote(renv))} (https://rstudio.github.io/renv/) is a great way of managing your package dependencies." %>%
    ui_glue_wrap_line()
  message()

  ui_answering_yes_implies() %>%
    usethis::ui_line()
    message()
  "The selected package  will be installed if necessary" %>%
    ui_glue_wrap_done()
  "The selected package will be added to the {usethis::ui_field('Suggests')} section of your {usethis::ui_field('DESCRIPTION')} file" %>%
    ui_glue_wrap_done()
  "[RENV SPECIFIC] From now on, any package that you install will be installed to your package's local library at {usethis::ui_path('renv/library/R-{{version}}/{{os_architecture>}}')} " %>%
    ui_glue_wrap_done()

  message()
}

ask_dep_management <- function(
  title = "Dependency management",
  step = 1,
  steps_max = 1,
  minimal = Sys.getenv("R_GOODSTART_MINIMAL", "FALSE") %>% as.logical()
) {
  # Inform
  if (minimal) {
    ui_header(title = title, step = step, steps_max = steps_max)
  }

  # Ask
  answer <-
    select.list(
      choices = c(valid_dep_management_packages(), valid_none(), valid_again_exit()),
      preselect = valid_dep_management_packages("renv"),
      title = "Which dependency management package would you like to use?" %>%
        ui_glue_wrap_field()
    )
  message()

  # Handle answer
  answer <- answer %>% handle_answer()
  if (answer %in% valid_again_exit(flip = TRUE)) {
    return(answer)
  }

  # Persist answer
  use_dep_management <- answer %>% is_answer_true_false()
  skeval__create_value(use_dep_management)
  skeval__create_value(answer %>% unname(), "use_dep_management_package")
}

# Ask GitHub --------------------------------------------------------------

ask_github_preamble <- function(
  title = "GitHub",
  step = 1,
  steps_max = 1
) {
  ui_header(title = title, step = step, steps_max = steps_max)

  "{usethis::ui_field('GitHub')} (https://github.com) is a great way to collaborate and share your code with others. Others can install your package from GitHub and also systematically contribute to your package by reporting issues or even orovide pull requests." %>%
    ui_glue_wrap_field() %>%
    ui_glue_wrap_line()
  message()

  ui_answering_yes_implies() %>%
    usethis::ui_line()
  message()
  "Prerequisites:" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "- You have a GitHub account and know your account's {usethis::ui_field('user name')}" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "[Next step] You'll be asked for your {usethis::ui_field('GitHub user name')}" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "[Next step] You'll be asked for a {usethis::ui_field('GitHub repository name')} that will be set as your remote Git repository with name {usethis::ui_field('origin')}" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "[Next step] You'll be asked how you want to authenticate to GitHub: via {usethis::ui_field('SSH')} (recommended) or via {usethis::ui_field('HTTPS')} authentication.
    Your answer determines the URL structure of the remote Git repository that is added:" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "- SSH: {usethis::ui_path('ssh://git@github.com:{{user_name}}/{{repo_name}}.git')}" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "- HTTPS: {usethis::ui_path('https://github.com/{{user_name}}/{{repo_name}}.git')}" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  message()
}

ask_github <- function(
  title = "GitHub",
  step = 1,
  steps_max = 1,
  minimal = Sys.getenv("R_GOODSTART_MINIMAL", "FALSE") %>% as.logical()
) {
  # Inform
  if (minimal) {
    ui_header(title = title, step = step, steps_max = steps_max)
  }

  # Ask
  answer <-
    select.list(
      choices = valid_yes_no_again_exit(),
      preselect = valid_yes_no_again_exit("yes"),
      title = "Do you want to use GitHub?" %>% ui_glue_wrap_field()
    )
  message()

  # Handle answer
  answer <- answer %>% handle_answer()
  if (answer %in% valid_again_exit(flip = TRUE)) {
    return(answer)
  }

  # Persist answer
  use_github <- answer %>% is_answer_true_false()
  skeval__create_value(use_github)

  # Ask additional infos in case GitHub should be used
  if (use_github) {
    # Ask for GitHub user name
    use_github_user_name <- readline(usethis::ui_field("What's your GitHub user name? Enter without quotes: "))
    message()

    # Persist GitHub user name
    skeval__create_value(use_github_user_name)

    # Ask about default GitHub repo name
    answer <-
      select.list(
        choices = valid_yes_no_again_exit(),
        preselect = valid_yes_no_again_exit("yes"),
        title = "Is your GitHub repository name the same as your package's name ('{get_package_name()}')?" %>% ui_glue_wrap_field()
      )
    message()

    # Handle answer
    answer <- answer %>% handle_answer()
    if (answer %in% valid_again_exit(flip = TRUE)) {
      return(answer)
    }

    # Handle actual GitHub repo name
    use_github_repo_default <- answer %>% is_answer_true_false()
    use_github_repo_name <- if (use_github_repo_default) {
      get_package_name()
    } else {
      "What's your GitHub repository name? Enter without quotes: " %>%
        usethis::ui_field() %>%
        readline()
    }
    message()

    # Persist GitHub repo name
    skeval__create_value(use_github_repo_name)

    # Ask about authentication
    answer <-
      select.list(
        choices = c(valid_authentication(), valid_again_exit()),
        preselect = valid_authentication("ssh"),
        title = "How would you like to authenticate to GitHub?" %>%
          ui_glue_wrap_field()
      )
    message()

    # Handle answer
    answer <- answer %>% handle_answer()
    if (answer %in% valid_again_exit(flip = TRUE)) {
      return(answer)
    }
    skeval__create_value(answer %>% unname(), "use_github_auth")
  }
}

# Ask CI platform ---------------------------------------------------------

ask_ci_preamble <- function(
  title = "Continuous integration",
  step = 1,
  steps_max = 1
) {
  ui_header(title = title, step = step, steps_max = steps_max)

  "Continuous integration (CI) is extremely important as it helps you deploy early and often with the confidence of automatically checking your package on different OS platforms (optionally also running your unit tests)." %>%
    ui_glue_wrap_field() %>%
    ui_glue_wrap_line()
  message()
  "You can currently choose from the following CI platforms that support R packages:" %>%
    ui_glue_wrap_line()
  "- GitHub Actions (https://github.com/features/actions)" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "- Travis CI (https://travis-ci.org/)" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "- Appveyor (https://www.appveyor.com/)" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  message()

  ui_answering_yes_implies() %>%
    usethis::ui_line()
  message()
  "Different side effects (creation of necessary artefacts such as configuration files, etc.) depending on your platform choice" %>%
    ui_glue_wrap_done()
  message()
}

ask_ci <- function(
  title = "Continuous integration",
  step = 1,
  steps_max = 1,
  minimal = Sys.getenv("R_GOODSTART_MINIMAL", "FALSE") %>% as.logical()
) {
  # Inform
  if (minimal) {
    ui_header(title = title, step = step, steps_max = steps_max)
  }

  # Ask
  answer <- select.list(
    choices = c(valid_ci_platforms(), valid_again_exit()),
    preselect = valid_ci_platforms("github_actions"),
    title = {
      "Do you want to use a CI platform?" %>%
        ui_glue_wrap_field()
    }
  )
  message()

  # Handle answer
  answer <- answer %>% handle_answer()
  if (answer %in% valid_again_exit(flip = TRUE)) {
    return(answer)
  }

  # Persist answer
  use_ci <- answer %>% is_answer_true_false()
  skeval__create_value(use_ci)
  skeval__create_value(answer %>% unname(), "use_ci_platform")
}

# Ask CI platform: test coverage ------------------------------------------

ask_ci_test_coverage_preamble <- function(
  title = "Continuous integration: test coverage service",
  step = 1,
  steps_max = 1
) {
  ui_header(title = title, step = step, steps_max = steps_max)

  "If you use unit tests, quantify test coverage locally and use a continuous integration platform, then it makes sense to include test coverage in your CI pipeline" %>%
    ui_glue_wrap_field() %>%
    ui_glue_wrap_line()
  message()
  "You can currently choose from the following CI platforms that are specialized on test coverage and that support R packages:" %>%
    ui_glue_wrap_line()
  "- Codecov (https://codecov.io/)" %>%
    ui_glue_wrap_line(indent = 2)
  "- Coveralls (https://coveralls.io/)" %>%
    ui_glue_wrap_line(indent = 2)
  message()

  ui_answering_yes_implies() %>%
    usethis::ui_line()
  message()
  "Prerequisites:" %>%
    ui_glue_wrap_done()
  "- You've said {usethis::ui_field('Yes')} to unit testing" %>%
    ui_glue_wrap_line(indent = 2)
  "- You've said {usethis::ui_field('Yes')} to reporting test coverage" %>%
    ui_glue_wrap_line(indent = 2)
  "- You've said {usethis::ui_field('Yes')} to using continuous integration (CI)" %>%
    ui_glue_wrap_line(indent = 2)
  "Under the hood {usethis::ui_code('use_coverage({{type}})')} is called which triggers CI platform specific side effects (e.g. creating config YAML files, etc.)" %>%
    ui_glue_wrap_done()
  message()
}

ask_ci_test_coverage <- function(
  title = "Continuous integration: test coverage service",
  step = 1,
  steps_max = 1,
  minimal = Sys.getenv("R_GOODSTART_MINIMAL", "FALSE") %>% as.logical()
) {
  # Inform
  if (minimal) {
    ui_header(title = title, step = step, steps_max = steps_max)
  }

  # Ask
  answer <- select.list(
    choices = c(valid_ci_test_coverage_services(), valid_none(), valid_again_exit()),
    preselect = valid_ci_test_coverage_services("codecov"),
    title = {
      "Which CI test coverage service would you like to integrate with?" %>%
        ui_glue_wrap_field()
    }
  )
  message()

  # Handle answer
  answer <- answer %>% handle_answer()
  if (answer %in% valid_again_exit(flip = TRUE)) {
    return(answer)
  }

  # Persist answer
  use_ci_test_coverage <- answer %>% is_answer_true_false()
  skeval__create_value(use_ci_test_coverage)
  skeval__create_value(answer %>% unname(), "use_ci_test_coverage_service")
}

# Ask GitHub Actions ------------------------------------------------------

ask_github_actions_preamble <- function(
  title = "GitHub Actions",
  step = 1,
  steps_max = 1
) {
  ui_header(title = title, step = step, steps_max = steps_max)

  "Continuous integration (CI) is super important and {usethis::ui_field('GitHub Actions')} (https://github.com/features/actions) is a great way of doing it." %>%
    ui_glue_wrap_field() %>%
    ui_glue_wrap_line()
  message()
  "There are arguably equally good alternatives such as" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "- https://travis-ci.org/" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "- https://www.appveyor.com/" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "but what makes GitHub Actions stand out is the fact that it lives under the same roof as your code revisioning system and is thus very well integrated" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_line()
  message()

  ui_answering_yes_implies() %>%
    usethis::ui_line()
  message()
  "Prerequisites:" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "- You've said {usethis::ui_field('Yes')} to GitHub" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "Under the hood, {usethis::ui_code('usethis::use_github_action_check_standard()')} is called which triggers the following side effects:" %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_done()
  "- File {usethis::ui_path('.github/.gitignore')} is created" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  "- File {usethis::ui_path('.github/workflows/R-CMD-check.yaml')} is created" %>%
    stringr::str_glue() %>%
    stringr::str_wrap(indent = 2) %>%
    usethis::ui_line()
  message()
}

ask_github_actions <- function(
  title = "GitHub Actions",
  step = 1,
  steps_max = 1,
  minimal = Sys.getenv("R_GOODSTART_MINIMAL", "FALSE") %>% as.logical()
) {
  # Inform
  if (minimal) {
    ui_header(title = title, step = step, steps_max = steps_max)
  }

  # Ask
  answer <-
    select.list(
      choices = valid_yes_no_again_exit(),
      preselect = valid_yes_no_again_exit("yes"),
      title = "Do you want to use GitHub Actions?" %>% ui_glue_wrap_field()
    )
  message()

  # Handle answer
  answer <- answer %>% handle_answer()
  if (answer %in% valid_again_exit(flip = TRUE)) {
    return(answer)
  }

  # Persist answer
  use_github_actions <- answer %>% is_answer_true_false()
  skeval__create_value(use_github_actions)
}

# Ask lifecycle -----------------------------------------------------------

ask_lifecycle_preamble <- function(
  title = "Code life cycle",
  step = 1,
  steps_max = 1
) {
  ui_header(title = title, step = step, steps_max = steps_max)

  "Using package {usethis::ui_code(quote(lifecycle))} (https://lifecycle.r-lib.org/) helps inform others about the life cycle state of your development" %>%
    ui_glue_wrap_field() %>%
    ui_glue_wrap_line()
  message()
  "It provides a set of tools and conventions to manage the life cycle of your exported functions and the package as a whole." %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_line()
  message()

  ui_answering_yes_implies() %>%
    usethis::ui_line()
  message()
  "Package {usethis::ui_code(quote(lifecycle))} will be installed if necessary" %>%
    ui_glue_wrap_done()
  "Package {usethis::ui_code(quote(lifecycle))} will be added to the {usethis::ui_field('Suggests')} section of your {usethis::ui_field('DESCRIPTION')} file" %>%
    ui_glue_wrap_done()
  "Necessary infrastructure components such as graphics for badges etc. will be created within the {usethis::ui_path('man')} directory" %>%
    ui_glue_wrap_done()
  message()
}

ask_lifecycle <- function(
  title = "Code life cycle",
  step = 1,
  steps_max = 1,
  minimal = Sys.getenv("R_GOODSTART_MINIMAL", "FALSE") %>% as.logical()
) {
  # Inform
  if (minimal) {
    ui_header(title = title, step = step, steps_max = steps_max)
  }

  # Ask
  answer <- select.list(
    choices = valid_yes_no_again_exit(),
    preselect = valid_yes_no_again_exit("yes"),
    title = {
      "Do you want to use package {usethis::ui_code(quote(lifecycle))} to better inform users of your package?" %>%
        ui_glue_wrap_field()
    }
  )
  message()

  # Handle answer
  answer <- answer %>% handle_answer()
  if (answer %in% valid_again_exit(flip = TRUE)) {
    return(answer)
  }

  # Persist answer
  use_lifecycle <- answer %>% is_answer_true_false()
  skeval__create_value(use_lifecycle)
}
