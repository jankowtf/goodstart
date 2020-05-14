context("Environment variables")

env_vars = list(
  TEST_HELLO = "hello",
  TEST_WORLD = "world!"
)

test_that("Deparse", {
  current <- env_vars %>% envvy__deparse()
  target <- list(
    TEST_HELLO = "TEST_HELLO=hello" %>% stringr::str_glue(),
    TEST_WORLD = "TEST_WORLD=world!" %>% stringr::str_glue()
  )
  expect_identical(current, target)
})

test_that("Parse", {
  env_vars_deparsed <- env_vars %>% envvy__deparse()
  current <- env_vars_deparsed %>% envvy__parse()
  target <- list(
    TEST_HELLO = "hello",
    TEST_WORLD = "world!"
  )
  expect_identical(current, target)
})

test_that("Making of Sys.setevn() expressions works", {
  current <- envvy__make_set_expressions(env_vars = env_vars)
  target <- list(
    TEST_HELLO = quote(Sys.setenv(TEST_HELLO = "hello")),
    TEST_WORLD = quote(Sys.setenv(TEST_WORLD = "world!"))
  )
  expect_identical(current, target)
})

test_that("Making of Sys.getevn() expressions works", {
  current <- envvy__make_get_expressions(env_vars = env_vars)
  target <- list(
    TEST_HELLO = quote(Sys.getenv("TEST_HELLO")),
    TEST_WORLD = quote(Sys.getenv("TEST_WORLD"))
  )
  expect_identical(current, target)
})

test_that("Making of Sys.unsetevn() expressions works", {
  current <- envvy__make_unset_expressions(env_vars = env_vars)
  target <- list(
    TEST_HELLO = quote(Sys.unsetenv("TEST_HELLO")),
    TEST_WORLD = quote(Sys.unsetenv("TEST_WORLD"))
  )
  expect_identical(current, target)
})

test_that("Evaluation of env var expressions works", {
  set_expressions <- envvy__make_set_expressions(env_vars = env_vars)
  get_expressions <- envvy__make_get_expressions(env_vars = env_vars)
  current <- envvy__eval_set_expressions(env_var_expressions = set_expressions)
  target <- envvy__eval_get_expressions(env_var_expressions = get_expressions)
  expect_identical(current, target)
  unset_expressions <- envvy__make_unset_expressions(env_vars = env_vars)
  current <- envvy__eval_unset_expressions(env_var_expressions = unset_expressions)
  target <- list(
    TEST_HELLO = TRUE,
    TEST_WORLD = TRUE
  )
  expect_identical(current, target)
  on.exit(
    env_vars %>%
      envvy__make_unset_expressions() %>%
      envvy__eval_unset_expressions()
  )
})

test_that("Ensurance of env vars works", {
  current <- ensure_env_vars(env_vars = env_vars)
  set_expressions <- envvy__make_set_expressions(env_vars = env_vars)
  target <- env_vars %>%
    envvy__make_get_expressions() %>%
    envvy__eval_get_expressions()
  expect_identical(current, target)
  on.exit(
    env_vars %>%
      envvy__make_unset_expressions() %>%
      envvy__eval_unset_expressions()
  )
})
