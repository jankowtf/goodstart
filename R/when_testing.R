when_testing_copy_template <- function(
  template_name
) {
  from <- usethis:::find_template(template_name, "goodstart")
  stopifnot(from %>% fs::file_exists())

  to <- usethis::proj_path() %>%
    fs::path(
      "inst",
      "templates"
    ) %>%
    fs::dir_create() %>%
    fs::path(template_name)
  fs::file_copy(from, to, overwrite = TRUE)
  fs::file_exists(to)
}

when_testing_ensure_man_dir <- function() {
  "man" %>%
    usethis::proj_path() %>%
    fs::dir_create()
}

when_testing_load_local_package <- function(
  env = parent.frame()
) {
  devtools::load_all(usethis::proj_path())
  withr::defer(devtools::unload(gs_package_name()), env = env)
}

when_testing_ensure_example_function_and_unit_test <- function() {
  path <- "R/foo.R"
  foo <- path %>% usethis::proj_path()
  foo %>% fs::file_create()

  def <-
    '#\' Hello world
#\' @param x Hello world
#\' @export
#\' @example
#\' foo()
foo <- function(x = "hello world") x
'
  def %>% write(foo)

  usethis::use_test("foo", open = FALSE)

  TRUE
}

when_testing_namespace_default <- function() {
  "exportPattern(\"^[[:alpha:]]+\")" %>%
    write("NAMESPACE" %>% usethis::proj_path())
}

when_testing_local_options <- function(
  env = parent.frame()
) {
  old <- options()
  withr::defer(withr:::reset_options(old), envir = env)
}
