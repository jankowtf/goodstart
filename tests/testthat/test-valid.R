context("Valid")

test_that("Valid generic", {
  is <- valid_generic_()
  should <- character()
  expect_identical(is, should)
})

test_that("Valid generic selection via match", {
  is <- valid_generic_(choice = letters[1], choices = letters)
  should <- letters[1]
  expect_identical(is, should)
})

test_that("Valid generic selection via name", {
  is <- valid_generic_(choice = LETTERS[1], choices = letters %>% purrr::set_names(LETTERS))
  should <- letters[1] %>% purrr::set_names(LETTERS[1])
  expect_identical(is, should)
})

test_that("Generic function multiple", {
  is <- valid_generic_(choice = letters[1:2], choices = letters)
  should <- letters[1:2]
  expect_identical(is, should)
})

# Custom function ---------------------------------------------------------

context("Valid custom")

test_that("Generic function multiple", {
  is <- valid_generic_(choice = letters[1:2], choices = letters)
  should <- letters[1:2]
  expect_identical(is, should)
})

test_that("Custom function selection via match", {
  valid_custom <- function(choice = character()) {
    valid_generic_(
      choice = choice,
      choices = c(
        yes = "Yes",
        no = "No",
        again = "Let me start over",
        exit = "Exit"
      )
    )
  }
  is <- valid_custom(choice = "Yes")
  should <- c(yes = "Yes")
  expect_identical(is, should)
})

test_that("Custom function selection via name", {
  valid_custom <- function(choice = character()) {
    valid_generic_(
      choice = choice,
      choices = c(
        yes = "Yes",
        no = "No",
        again = "Let me start over",
        exit = "Exit"
      )
    )
  }
  is <- valid_custom(choice = "yes")
  should <- c(yes = "Yes")
  expect_identical(is, should)
})

# Flip --------------------------------------------------------------------

context("Valid flip")

test_that("Valid generic flip", {
  is <- valid_generic_(choices = letters %>% purrr::set_names(LETTERS), flip = TRUE)
  should <- LETTERS %>% purrr::set_names(letters)
  expect_identical(is, should)
})

test_that("Valid generic flip with choice", {
  is <- valid_generic_(choice = letters[1],
    choices = letters %>% purrr::set_names(LETTERS), flip = TRUE)
  should <- LETTERS[1] %>% purrr::set_names(letters[1])
  expect_identical(is, should)
})

test_that("Valid generic flip with choice", {
  valid_custom <- function(choice = character(), flip = FALSE) {
    valid_generic_(
      choice = choice,
      choices = c(
        yes = "Yes",
        no = "No",
        again = "Let me start over",
        exit = "Exit"
      ),
      flip = flip
    )
  }
  is <- valid_custom(choice = "Yes", flip = TRUE)
  should <- c(Yes = "yes")
  expect_identical(is, should)
})
