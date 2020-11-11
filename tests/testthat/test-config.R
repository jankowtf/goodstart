context("Goodstart config")

test_that("Path to config file", {
  current <- path_config_file()
  target <- "~/.r_goodstart/config" %>% fs::path()
  expect_identical(current, target)
})

test_that("Write config", {
  current <- goodstart_config() %>%
    write_goodstart_config()
  target <- path_config_file()
  expect_identical(current, target)
})

test_that("Write config with ID", {
  current <- goodstart_config() %>%
    write_goodstart_config(id = "abcd")
  target <- path_config_file() %>%
    stringr::str_c("_abcd") %>%
    fs::path()
  expect_identical(current, target)
})

test_that("Check if config exists", {
  current <- exists_goodstart_config()
  target <- TRUE %>%
    purrr::set_names(path_config_file())
  expect_identical(current, target)
})

test_that("Check if config with ID exists", {
  current <- exists_goodstart_config(id = "abcd")
  target <- TRUE %>%
    purrr::set_names(path_config_file(id = "abcd"))
  expect_identical(current, target)
})

test_that("Read config", {
  if (exists_goodstart_config()) {
    current <- read_goodstart_config()
    target <- goodstart_config()
    # setdiff(names(current), names(target))
    # setdiff(names(target), names(current))
    expect_identical(current, target)
  }
})

test_that("Read config with ID", {
  if (exists_goodstart_config()) {
    current <- read_goodstart_config(id = "abcd")
    target <- goodstart_config()
    # setdiff(names(current), names(target))
    # setdiff(names(target), names(current))
    expect_identical(current, target)
  }
})

test_that("List configs", {
  current <- list_goodstart_configs()
  expect_is(current, "fs_path")
  expect_true(length(current) > 0)
})
