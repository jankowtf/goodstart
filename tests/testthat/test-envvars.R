context("Environment variables")

env_vars = list(
  TEST_HELLO = "hello",
  TEST_WORLD = "world!"
)

test_that("Making of Sys.setevn() expressions works", {
  is <- envvars__make_set_expressions(env_vars = env_vars)
  should <- list(
    TEST_HELLO = quote(Sys.setenv(TEST_HELLO = "hello")),
    TEST_WORLD = quote(Sys.setenv(TEST_WORLD = "world!"))
  )
  expect_identical(is, should)
})

test_that("Making of Sys.getevn() expressions works", {
  is <- envvars__make_get_expressions(env_vars = env_vars)
  should <- list(
    TEST_HELLO = quote(Sys.getenv("TEST_HELLO")),
    TEST_WORLD = quote(Sys.getenv("TEST_WORLD"))
  )
  expect_identical(is, should)
})

test_that("Making of Sys.unsetevn() expressions works", {
  is <- envvars__make_unset_expressions(env_vars = env_vars)
  should <- list(
    TEST_HELLO = quote(Sys.unsetenv("TEST_HELLO")),
    TEST_WORLD = quote(Sys.unsetenv("TEST_WORLD"))
  )
  expect_identical(is, should)
})

test_that("Evaluation of env var expressions works", {
  set_expressions <- envvars__make_set_expressions(env_vars = env_vars)
  get_expressions <- envvars__make_get_expressions(env_vars = env_vars)
  is <- envvars__eval_set_expressions(env_var_expressions = set_expressions)
  should <- envvars__eval_get_expressions(env_var_expressions = get_expressions)
  expect_identical(is, should)
  unset_expressions <- envvars__make_unset_expressions(env_vars = env_vars)
  is <- envvars__eval_unset_expressions(env_var_expressions = unset_expressions)
  should <- list(
    TEST_HELLO = TRUE,
    TEST_WORLD = TRUE
  )
  expect_identical(is, should)
  on.exit(
    env_vars %>%
      envvars__make_unset_expressions() %>%
      envvars__eval_unset_expressions()
  )
})

test_that("Ensurance of env vars works", {
  is <- ensure_env_vars(env_vars = env_vars)
  set_expressions <- envvars__make_set_expressions(env_vars = env_vars)
  should <- env_vars %>%
    envvars__make_get_expressions() %>%
    envvars__eval_get_expressions()
  expect_identical(is, should)
  on.exit(
    env_vars %>%
      envvars__make_unset_expressions() %>%
      envvars__eval_unset_expressions()
  )
})
