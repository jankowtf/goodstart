repo <- git2r::repository(".git")
git2r::config(
  repo,
  user.name = "Janko Thyson",
  user.email = "janko.thyson@rappster.io"
)
git2r::config(repo)
gert::git_config()

git2r::is_empty(repo)
# git2r::init(usethis::proj_path())

paths <- git2r::status(repo)
git2r::remote_add(repo, name = "origin", url = "https://github.com/rappster/goodstart")
git2r::add(repo, path = paths$untracked %>% as.character())
git2r::commit(repo, message = "Off to a good start")
creds <- git2r::cred_ssh_key(
  "~/.ssh/id_rsa.pub",
  "~/.ssh/id_rsa"
)
# creds$publickey %>% fs::file_exists()
repo %>%
  saveRDS("/home/data/repo.Rds")
git2r::push(repo, credentials = creds)
git2r::push(
  repo,
  name = "origin",
  refspec = "refs/heads/master",
  credentials = creds,
  set_upstream = TRUE
)
gert::git_push("origin", refspec = "refs/heads/master")


# GitHub issue ------------------------------------------------------------

library(git2r)
push()
push(credentials = cred_ssh_key())
