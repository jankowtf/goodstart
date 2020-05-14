context("Simple key-value store")

test_that("Store name", {
  is <- skeval__store_name()
  should <- "GOODSTART_KEY_VALUE_STORE" %>% stringr::str_glue()
  expect_identical(is, should)
})

test_that("Ensure store", {
  # when_testing_local_options()
  store_name <- skeval__store_name()

  old <- options()
  on.exit({
    options(old)
    "options(\"{store_name}\" = NULL)" %>%
      stringr::str_glue() %>%
      rlang::parse_expr() %>%
      rlang::eval_tidy()
  })

  is <- skeval__ensure_store()
  should <- TRUE
  expect_identical(is, should)

  expect_true(!is.null(getOption(store_name)))
  expect_is(getOption(store_name), "environment")

  is <- skeval__ensure_store()
  should <- FALSE
  expect_identical(is, should)
})

test_that("Compute key", {
  is <- skeval__compute_key(a = 1, b = TRUE, c = list(letters))
  should <- digest::digest(list(a = 1, b = TRUE, c = list(letters)))
  expect_identical(is, should)
})

test_that("Exists key", {
  key <- skeval__compute_key(a = 1, b = TRUE, c = list(letters))
  is <- skeval__exists_value(key)
  should <- FALSE
  expect_identical(is, should)
})

test_that("Create value", {
  on.exit(skeval__reset_store())
  key <- skeval__compute_key(a = 1, b = TRUE, c = list(letters))
  is <- skeval__create_value(LETTERS, key)
  should <- LETTERS
  expect_identical(is, should)
  expect_true(skeval__exists_value(key))
})

test_that("Read value", {
  on.exit(skeval__reset_store())
  key <- skeval__compute_key(a = 1, b = TRUE, c = list(letters))
  skeval__create_value(LETTERS, key)
  is <- skeval__read_value(key)
  should <- LETTERS
  expect_identical(is, should)
})

test_that("Exists key (2)", {
  on.exit(skeval__reset_store())
  key <- skeval__compute_key(a = 1, b = TRUE, c = list(letters))
  skeval__create_value(LETTERS, key)
  is <- skeval__exists_value(key)
  should <- TRUE
  expect_identical(is, should)
})

