handle_answer <- function(answer, type = c("inner", "outer"), env = parent.frame()) {
  type <- match.arg(type)
  answer <- if (type == "inner") {
    tmp <- switch(
      names(answer),
      yes = TRUE,
      no = FALSE,
      again = "again",
      exit = "exit"
    )
    if (!is.null(tmp)) {
      tmp
    } else {
      answer
    }
  } else if (type == "outer") {
    if (is.null(answer)) {
      # quote(return(usethis::ui_oops("Exited")))
      # withr::with_environment(
      #   env = env,
      #   return(usethis::ui_oops("Exited"))
      # )
      rlang::quo((rlang::eval_tidy(
        return(usethis::ui_oops("Exited")),
        env = env
      )))
    } else if (is.na(answer)) {
      rlang::eval_tidy(Recall(), env = env)
    }
  }
}

ui_answering_yes_implies <- function() {
  "Answering {usethis::ui_field('Yes')} implies the following when subsequently calling {usethis::ui_code('ensure_good_start()')}:"
}

ui_header <- function(title, step, steps_max) {
  "{title} (step {step} of {steps_max})" %>%
    rlang::eval_tidy() %>%
    stringr::str_glue() %>%
    stringr::str_wrap() %>%
    usethis::ui_info()
  message()
}

is_answer_true_false <- function(answer) {
  answer %>%
    not_in(
      c(valid_again_exit(flip = TRUE), valid_none())
    )
}
