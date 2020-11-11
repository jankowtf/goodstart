sys_reqs_manual <- c(
  # {gert} -----
  "libgit2-dev ",
  # {textshaping} -----
  "libharfbuzz-dev",
  "libfribidi-dev",
  # {ragg} -----
  "libfreetype6-dev",
  "libpng-dev",
  "libtiff5-dev",
  "libjpeg-dev"
) %>%
  stringr::str_c(collapse = " ")

apt_install <- "sudo -kS apt install -y {sys_reqs_manual}" %>%
  stringr::str_glue()

system(apt_install, input = readline("Password: "))

if (FALSE) {
  sys_reqs <- getsysreqs::get_sysreqs("renv.lock")
  sys_reqs_collapsed <- sys_reqs %>% stringr::str_c(collapse = " ")

  apt_install <- "sudo -kS apt install -y {sys_reqs_collapsed}" %>%
    stringr::str_glue()

  system(apt_install, input = readline("Password: "))

  # sudo apt install -y libsodium-dev
}
