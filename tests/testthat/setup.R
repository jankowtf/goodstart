# Ensure DESCRIPTION is copied --------------------------------------------

fs::file_copy(
  here::here("DESCRIPTION"),
  here::here("tests/testthat/DESCRIPTION"),
  overwrite = TRUE
)
