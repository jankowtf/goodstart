
<!-- README.md is generated from README.Rmd. Please edit that file -->

# goodstart (0.0.0.9007)

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/rappster/goodstart/workflows/R-CMD-check/badge.svg)](https://github.com/rappster/goodstart/actions)
[![Codecov test
coverage](https://codecov.io/gh/rappster/goodstart/branch/master/graph/badge.svg)](https://codecov.io/gh/rappster/goodstart?branch=master)
<!-- badges: end -->

Have a good start when developing new R packages

## tl;dr

In a “factory fresh” new package project as, e.g., created from within
RStudio via

    File -> New Project... -> New Directory -> R Package

or via

``` r
usethis::create_package()
```

you call

``` r
library(goodstart)

ensure_good_start()
```

This will get you to a state where your package follows most (at least
some) of the (arguable) best practices when developing R packages.

If you’d like to first understand what’s actually going on under the
hood before calling that function, then read on (especially section
[Usage](#usage))

-----

## What?

`{goodstart}` tries to ensure a number of development and workflow
aspects that are arguably considered best practice for R developers to
provide you with an initial package state where everything is “all set
and ready to go”.

It does so by providing convenience wrappers (function family
`ensure_*()`) around functionality of
[{usethis}](https://usethis.r-lib.org/) & friends (see section
*Acknowledgments*) mixed with some custom functions for trying to
automate most of the stuff I usually do when starting a new development
project.

The goal is basically to give you - the R developer - a “one-stop-shop”
function (`ensure_good_start()`) that bundles all those different calls
to `usethis::use_*()` functions and associated setup steps that you
would normally perform when setting up a new package project.

## Why?

Reduce the ramp-up time when developing new packages\!

Even with the (ever evolving) great tooling around
[{usethis}](https://usethis.r-lib.org/) & friends, setting up and
configuring each new package project usually still takes me about 30 to
60 minutes until I feel like “ok, now I’m ready to actually go and write
the first line of code of what the package will be all about”.

That’s **way** too long.

For me, the main reason it takes so long is me being pretty bad at
actually **remembering** all the steps I have to do - all the cool
`usethis::use_*()` functions I have to call, all my other packages where
“I used something that I’d like to use again”, all the nitty gritty
details of setting up config files to use things like [Travis
CI](https://travis-ci.org/), [GitHub
Actions](https://github.com/features/actions) or
[Codecov](https://codecov.io/), etc.

`{goodstart}` tries to take that mental burden off of you.

## Disclaimer

I started developing this package to “scratch my own itch”.

Thus, while do I try to respect, follow and support as many of the
emerging best practices, the package in its current state

  - is **(somewhat) opinionated** to streamline my own development
    process.
  - is certainly still based on a number of assumptions and
    prerequisites that might still be implicit (e.g. having and using a
    GitHub account, having SSH keys in place, etc.). I hope to make each
    of them very explicit as I go along.
  - is still **fairly experimental**, therefore has a lot of rough edges
    (see my approach with `ask()` regarding rounding these off a bit)
    and “stuff” is still very likely to change as I go along
    (e.g. function names, the mechanism to store and retrieve
    configuration setups, etc.).

**However, I hope it is already useful for someone out there and I’ll
try my best to adapt `{goodstart}` to the needs of other developers as I
go along in case there’s expressed interested.**

## Acknowledgments

I’m **absolutely** fascinated by all the great workflow tooling that has
emerged and continues to do so for R developers and huge thanks go out
to all the developers and teams that create and maintain it.

Just a couple of awesome examples:

  - [{usethis}](https://usethis.r-lib.org/)
  - [{devtools}](https://devtools.r-lib.org/)
  - [{renv}](https://rstudio.github.io/renv/)
  - [{goodpractice}](http://mangothecat.github.io/goodpractice/)
  - [{lintr}](https://www.tidyverse.org/blog/2017/12/workflow-vs-script/)
  - [{testthat}](https://testthat.r-lib.org/)
  - [{tinytest}](https://github.com/markvanderloo/tinytest)
  - [{covr}](http://covr.r-lib.org/index.html)
  - [{assertr}](https://github.com/ropensci/assertr)
  - [{daff}](http://paulfitz.github.io/daff/)
  - [{lumberjack}](https://github.com/markvanderloo/lumberjack)
  - [{precommit}](https://lorenzwalthert.github.io/precommit/)
  - [{drake}](https://docs.ropensci.org/drake/index.html)
  - <https://happygitwithr.com/>
  - Blog posts & Co.
      - [R Hub: Workflow automation tools for package
        developers](https://blog.r-hub.io/2020/04/29/maintenance/)
      - [R Hub: Why and how maintain a NEWS file for your R
        package?](https://blog.r-hub.io/2020/05/08/pkg-news/)
      - [Tidyverse: Self-cleaning test
        fixtures](https://www.tidyverse.org/blog/2020/04/self-cleaning-test-fixtures/)
      - [Miles McBain: Benefits of a function-based
        diet](https://milesmcbain.xyz/the-drake-post/)
      - [Mark van der Loo: Lumberjack JSS
        paper](https://cran.r-project.org/web/packages/lumberjack/vignettes/JSS_4008.pdf)
  - …

While I’m not yet as familiar as I’d like to be with all of the above
paradigms, workflows and packages, I’ll try follow and support emerging
best practices and (de facto) standard workflows the best that I can as
this package evolves.

As Microsoft CEO Satya Nadella has once put it:

> If any engineer has to choose between working on a feature or working
> on dev productivity, always choose dev productivity.

So in that spirit, I hope that `{goodstart}` can eventually contribute
its 2 cents in the quest of establishing clean and reproducible
development workflows in R.

Any suggestions or help along the way are greatly appreciated.

-----

## Installation

### Stable releases on [CRAN](https://CRAN.R-project.org)

Not available yet.

### Stable releases on [GitHub](https://github.com/)

Not available yet.

### Development releases on [GitHub](https://github.com/)

``` r
remotes::install_github("rappster/goodstart")
```

This installs the version in Git branch `master`

-----

## Usage

### Configuration

The main function of `{goodstart}` is `ensure_good_start()`.

It bundles calls to a number of `ensure_*()` functions that in turn
either call `usethis::use_*()` functions with some bells and whistles
added or custom functions that ensure a certain workflow aspect.

Which functions of that bundle will actually be called depends on the
configuration that you can pass along via argument `config`.

You can generate such “good start configuration” object like this:

``` r
gs_config <- goodstart_config(
  use_github_user_name = "your_github_name",
  use_github_repo_name = "your_package_name",
  use_github_auth = "ssh"
)

gs_config
#> $use_roxygen
#> [1] TRUE
#> 
#> $use_rmarkdown
#> [1] TRUE
#> 
#> $use_readme
#> [1] TRUE
#> 
#> $use_news
#> [1] TRUE
#> 
#> $use_backlog
#> [1] TRUE
#> 
#> $use_license
#> [1] TRUE
#> 
#> $use_license_license
#> [1] "gpl3"
#> 
#> $use_unit_testing
#> [1] TRUE
#> 
#> $use_unit_testing_package
#> [1] "testthat"
#> 
#> $use_unit_testing_coverage
#> [1] TRUE
#> 
#> $use_unit_testing_coverage_package
#> [1] "covr"
#> 
#> $use_dep_management
#> [1] TRUE
#> 
#> $use_dep_management_package
#> [1] "renv"
#> 
#> $use_github
#> [1] TRUE
#> 
#> $use_github_user_name
#> [1] "your_github_name"
#> 
#> $use_github_repo_name
#> [1] "your_package_name"
#> 
#> $use_github_auth
#> [1] "ssh"
#> 
#> $use_ci
#> [1] TRUE
#> 
#> $use_ci_platform
#> [1] "github_actions"
#> 
#> $use_ci_test_coverage
#> [1] TRUE
#> 
#> $use_ci_test_coverage_service
#> [1] "codecov"
#> 
#> $use_lifecycle
#> [1] TRUE
```

> A note on the `use_github_auth = "ssh"` part:
> 
> I personally would recommend SSH over HTTPS authentication and thus
> HTTPS currently isn’t implemented yet. Check this [GitHub
> documentation](https://docs.github.com/en/github/using-git/which-remote-url-should-i-use)
> for details

If you pass that configuration as is, you say “Yes” to all ensuring
steps. To better understand what each step actually does, refer to the
section [Be nice and ask](#be-nice-and-ask) below.

As `gs_config` is a simple list, you can easily opt out of certain
ensuring steps by setting the corresponding list element to `FALSE`.

For example, if you don’t want to use
[{renv}](https://rstudio.github.io/renv/) to handle your dependency
management, then set

``` r
gs_config$use_dep_management <- FALSE
```

Don’t do that, though, as [{renv}](https://rstudio.github.io/renv/) is
simply awesome and you should use it ;-)

### Managing configurations

You can save your configuration in your user’s `HOME` directory via

``` r
write_goodstart_config(config = gs_config)
#> ~/.r_goodstart/config
```

and load it via

``` r
gs_config_cached <- read_goodstart_config()
#> Reading config ~/.r_goodstart/config
```

the next time you start a new package project.

You can also save different configs by assigning different IDs to them:

``` r
# Config 1
gs_config_1 <- gs_config

# Config 2
gs_config_2 <- gs_config
gs_config_2$use_dep_management <- TRUE

write_goodstart_config(
  config = gs_config_1,
  id = "1"
)
#> ~/.r_goodstart/config_1
write_goodstart_config(
  config = gs_config_2,
  id = "2"
)
#> ~/.r_goodstart/config_2
```

And then read the config by specifying the ID that you want

``` r
gs_config_1 <- read_goodstart_config(id = "1")
#> Reading config ~/.r_goodstart/config_1
gs_config_2 <- read_goodstart_config(id = "2")
#> Reading config ~/.r_goodstart/config_2

gs_config_1$use_dep_management
#> [1] FALSE
gs_config_2$use_dep_management
#> [1] TRUE
```

List available saved configurations via

``` r
list_goodstart_configs()
# /home/janko/.r_goodstart/config           /home/janko/.r_goodstart/config_1         
# /home/janko/.r_goodstart/config_2         
```

### Test drive

I put a lot of effort into making `{goodstart}` and all its side effects
as transparent and testable as possible.

> Side note: In that regard once more, a big shout out to the awesome
> developers behind [{usethis}](https://usethis.r-lib.org/) and to
> [Jenny Bryan](https://github.com/jennybc) (\[@JennyBryan on
> Twitter\](<https://twitter.com/JennyBryan>)) in particular for her
> extremely insightful and useful blog post on [Self-cleaning text
> fixtures](https://www.tidyverse.org/blog/2020/04/self-cleaning-test-fixtures/)
> which helped **enormously** in writing unit tests.

One nice side effect of my unit testing endavours is that you can easily
set up a temporary package and thus “a sandbox to play with” - without
having to risk that you corrupt one of your actual projects while doing
so - by calling `create_sandbox_package()`.

Following this up with a call to `mimick_rstudio_package()` lets you
start off with a sandbox package structure that looks very similar to
what you would get when creating a new package project in RStudio via
`File -> New Project... -> New Directory -> R Package`. The only
difference is that it also already contains certain template files in
`./inst/templates` and added a dummy function and its `{testthat]` unit
test.

You can then safely call `ensure_good_start()`:

``` r
library(goodstart)

# Create temporary package
pkg <- create_sandbox_package()
```

``` r
pkg
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac

setwd(pkg)
# NOTE
# Explicitly changing the working directory is only required due to the behavior
# of {knitr} regarding resetting the working directory to the original one in
# each chunk. You DO NOT need to do this if your're calling
# `create_sandbox_package()` in an regular R script when trying out the
# {goodstart}. See the `Note` section in the documentation page of knitr::knit()
# for details on this

# Inspect the package directory
pkg %>% fs::dir_ls(all = TRUE, recurse = TRUE)
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/DESCRIPTION
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/NAMESPACE
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/R

# Mimick typical initial state of a package project when using RStudio
mimick_rstudio_package()
#> Loading goodstarttest
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac

# Inspect the package directory again
pkg %>% fs::dir_ls(all = TRUE, recurse = TRUE)
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/DESCRIPTION
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/NAMESPACE
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/R
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/R/hello.R
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/inst
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/inst/templates
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/inst/templates/package-BACKLOG
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/inst/templates/package-README
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/man
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/man/hello.Rd

# Tweak the config
gs_config <- goodstart_config(
  use_github_user_name = "rappster",
  use_github_repo_name = "goodstarttest",
  use_github_auth = "ssh"
)

# Ensure good start
gs_result <- try(ensure_good_start(config = gs_config, info = TRUE))
#> ✓ Adding 'magrittr' to Suggests field in DESCRIPTION
#> ● Use `requireNamespace("magrittr", quietly = TRUE)` to test if package is installed
#> ● Then directly refer to functons like `magrittr::fun()` (replacing `fun()`).
#> ℹ ensure_removed_hello_r()
#> ✓ Succesfully removed R/hello.R
#> ℹ ensure_removed_hello_rd()
#> ✓ Succesfully removed man/hello.Rd
#> ℹ ensure_dependency_management()
#> ✓ Adding 'renv' to Suggests field in DESCRIPTION
#> ● Use `requireNamespace("renv", quietly = TRUE)` to test if package is installed
#> ● Then directly refer to functons like `renv::fun()` (replacing `fun()`).
#> ✓ Package {renv} activated
#> Installing renv [0.12.2] ...
#>  OK [copied cache]
#> ● Use `requireNamespace("renv", quietly = TRUE)` to test if package is installed
#> ● Then directly refer to functons like `renv::fun()` (replacing `fun()`).
#> * renv [0.12.2] is already installed and active for this project.
#> ✓ Package {renv} upgraded
#> ℹ ensure_unit_testing()
#> Installing brio [1.1.0] ...
#>  OK [copied cache]
#> Installing ps [1.4.0] ...
#>  OK [copied cache]
#> Installing R6 [2.5.0] ...
#>  OK [copied cache]
#> Installing processx [3.4.4] ...
#>  OK [copied cache]
#> Installing callr [3.5.1] ...
#>  OK [copied cache]
#> Installing assertthat [0.2.1] ...
#>  OK [copied cache]
#> Installing crayon [1.3.4] ...
#>  OK [copied cache]
#> Installing glue [1.4.2] ...
#>  OK [copied cache]
#> Installing fansi [0.4.1] ...
#>  OK [copied cache]
#> Installing cli [2.1.0] ...
#>  OK [copied cache]
#> Installing backports [1.2.0] ...
#>  OK [copied cache]
#> Installing rprojroot [1.3-2] ...
#>  OK [copied cache]
#> Installing desc [1.2.0] ...
#>  OK [copied cache]
#> Installing digest [0.6.27] ...
#>  OK [copied cache]
#> Installing rlang [0.4.8] ...
#>  OK [copied cache]
#> Installing ellipsis [0.3.1] ...
#>  OK [copied cache]
#> Installing evaluate [0.14] ...
#>  OK [copied cache]
#> Installing jsonlite [1.7.1] ...
#>  OK [copied cache]
#> Installing lifecycle [0.2.0] ...
#>  OK [copied cache]
#> Installing magrittr [1.5] ...
#>  OK [copied cache]
#> Installing prettyunits [1.1.1] ...
#>  OK [copied cache]
#> Installing withr [2.3.0] ...
#>  OK [copied cache]
#> Installing pkgbuild [1.1.0] ...
#>  OK [copied cache]
#> Installing rstudioapi [0.12] ...
#>  OK [copied cache]
#> Installing pkgload [1.1.0] ...
#>  OK [copied cache]
#> Installing praise [1.0.0] ...
#>  OK [copied cache]
#> Installing diffobj [0.3.2] ...
#>  OK [copied cache]
#> Installing utf8 [1.1.4] ...
#>  OK [copied cache]
#> Installing vctrs [0.3.4] ...
#>  OK [copied cache]
#> Installing pillar [1.4.6] ...
#>  OK [copied cache]
#> Installing pkgconfig [2.0.3] ...
#>  OK [copied cache]
#> Installing tibble [3.0.4] ...
#>  OK [copied cache]
#> Installing rematch2 [2.1.2] ...
#>  OK [copied cache]
#> Installing waldo [0.2.3] ...
#>  OK [copied cache]
#> Installing testthat [3.0.0] ...
#>  OK [copied cache]
#> The following package(s) have been updated:
#> 
#>  rstudioapi [installed version 0.12 != loaded version 0.11]
#> 
#> Consider restarting the R session and loading the newly-installed packages.
#> ✓ Adding 'testthat' to Suggests field in DESCRIPTION
#> ● Use `requireNamespace("testthat", quietly = TRUE)` to test if package is installed
#> ● Then directly refer to functons like `testthat::fun()` (replacing `fun()`).
#> ✓ Creating 'tests/testthat/'
#> Installing testthat [3.0.0] ...
#>  OK [copied cache]
#> ● Use `requireNamespace("testthat", quietly = TRUE)` to test if package is installed
#> ● Then directly refer to functons like `testthat::fun()` (replacing `fun()`).
#> Error : Ensuring testthat infrastructure failed:
#> Error in loadNamespace(name) : there is no package called 'whisker'
```

And inspect the results

``` r
gs_result
#> [1] "Error : Ensuring testthat infrastructure failed:\nError in loadNamespace(name) : there is no package called 'whisker'\n"
#> attr(,"class")
#> [1] "try-error"
#> attr(,"condition")
#> <usethis_error: Ensuring testthat infrastructure failed:
#> Error in loadNamespace(name) : there is no package called 'whisker'>
pkg %>% fs::dir_ls(all = TRUE)
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/.Rbuildignore
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/.Rprofile
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/DESCRIPTION
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/NAMESPACE
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/R
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/inst
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/man
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/renv
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac/tests
```

Make sure to clean up things with

``` r
withr::deferred_run()
```

to get back to your previous state (working directory, loaded projects,
etc.)

``` r
usethis::proj_get()
#> /tmp/Rtmp5Husuu/testpkgac82eeaeaac
getwd()
#> [1] "/home/data/Code/R/Packages/goodstart"
```

### Be nice and ask

I also developed `ask()` as my first attempt to giving developers other
than me more transparency and choice regarding what’s actually happening
once you call `ensure_good_start()`

It asks you interactively about the setup you’d like to use, either in
“full verbosity” or reduced to the essentials once you know what’s
going on.

Either call `ask()` or `ask(minimal = TRUE)`:

``` r
ask()
ask(minimal = TRUE)
```

This question/answer process results in a `config` object that has the
same structure as the one returned by `goodstart_config()`.

This is how each step will look like:

### Step 1

``` r
ℹ Roxygen (step 1 of 10)

Great documentation makes a huge difference - not just for others, but also
for "future you".

Using package `roxygen2` (https://roxygen2.r-lib.org/) makes documenting
your package easy and fun. It offers you a straightforward syntax (optionally
including markdown), provides you with a number of convenient helpers and takes
care of managing your NAMESPACE file.

Answering Yes implies the following when subsequently calling `ensure_good_start()`:

✓ Package `roxygen2` will be installed if necessary
✓ Package `roxygen2` will be added to Suggests section of your
  DESCRIPTION file
✓ Line RoxygenNote: {x.y.z} will be added to your DESCRIPTION
  file
✓ [NOT ENSURED YET] RStudio settings are modified to put `roxygen2` in
  charge of documenting and vignette building

Do you want to use package `roxygen2` for documenting tasks? 

1: Yes
2: No
3: Let me start over
4: Exit
```

### Step 2

``` r
ℹ NEWS.md (step 2 of 10)

Using R Markdown (https://rmarkdown.rstudio.com/) makes your developer life
so much easier.

It offers you a very expressive syntax, makes it easy to write vignettes and
ties in excellently with `roxygen2` code (see https://roxygen2.r-
lib.org/articles/markdown.html).

Answering Yes implies the following when subsequently calling `ensure_good_start()`:

✓ Packages `rmarkdown`, `whisker` and `knitr` will be
  installed if necessary
✓ Packages `rmarkdown`, `whisker` and `knitr` will be
  added to the Suggests section of your DESCRIPTION file
✓ Line VignetteBuilder: knitr will be added to your DESCRIPTION
  file
✓ If you said Yes to `roxygen2` then line Roxygen:
  list(markdown = TRUE) will be added to your DESCRIPTION file

Do you want to use R Markdown throughout your package? 

1: Yes
2: No
3: Let me start over
4: Exit
```

### Step 3

``` r
ℹ License (step 3 of 10)

You should be using a license to make it explicit how you would like your
code to be used and shared.

Check out
  - http://r-pkgs.had.co.nz/description.html#license
  - https://www.r-project.org/Licenses/
for details on open source software licenses.

Answering Yes implies the following when subsequently calling `ensure_good_start()`:

✓ You are asked which license type you want to use. If you are not sure then
  GPL-3 is a good choice
✓ The line License: {license_type} will added to your
  DESCRIPTION file

Which license would you like to use? 

 1: GPL v3
 2: MIT
 3: CC0
 4: CCBY 4.0
 5: LGPL v3
 6: APL 2.0
 7: AGPL v3
 8: None
 9: Let me start over
10: Exit
```

### Step 4

``` r
ℹ Unit testing (step 4 of 10)

Unit testing is crucial if you're serious about continuous integration (CI)
as it gives you the confidence of iteratively improving code and adding new
features. If you break things, you'll immediately know and can triage where and
why things went wrong.

Package `testthat` offers you a sophisticated framework for unit testing
and plays nice with all major continuous integration (CI) platforms such as
  - https://travis-ci.org/
  - https://www.appveyor.com/
  - https://github.com/features/actions
via integration with https://codecov.io/ or https://coveralls.io/

Package `tinytest` is an alternative, but it is currently not further
integrated with `goodstart`.

Answering Yes implies the following when subsequently calling `ensure_good_start()`:

✓ The selected package will be installed if necessary
✓ Unit test infrastructure will be created within directory 'tests/'
✓ The selected package will be added to the Suggests section of your
  DESCRIPTION file

Which unit test package would you like to use? If you're not sure then
'testthat' is a good choice. 

1: testthat
2: tinytest
3: None
4: Let me start over
5: Exit
```

### Step 5

``` r
ℹ Unit testing: test coverage (step 5 of 10)

An important part of sincere continuous integration (CI) efforts is keeping
tabs on the proportion of your code that is tested via unit tests - or test
coverage in short.

Package `covr` provides an excellent framework for that. It also
integrates nicely with CI test coverage services such as
  - https://codecov.io/
  - https://coveralls.io/

Answering Yes implies the following when subsequently calling `ensure_good_start()`:

✓ Prerequisites:
  - You've said Yes to unit testing

Do you want to use a test coverage package? 

1: covr
2: None
3: Let me start over
4: Exit
```

### Step 6

``` r
ℹ Dependency management (step 6 of 10)

Systematically tracking tracking the exact state (i.e. version and where
it was installed from) of all the packages that your package depends on is
highly recommended. Using a dependency management framework greatly facilitates
colloboration as it lets others easily reproduce the exact same dependency state
when you share your code with them.

Using package `renv` (https://rstudio.github.io/renv/) is a great way of
managing your package dependencies.

Answering Yes implies the following when subsequently calling `ensure_good_start()`:

✓ The selected package will be installed if necessary
✓ The selected package will be added to the Suggests section of your
  DESCRIPTION file
✓ [RENV SPECIFIC] From now on, any package that you install will be installed
  to your package's local library at 'renv/library/R-{version}/
  {os_architecture>}'

Which dependency management package would you like to use? 

1: renv
2: None
3: Let me start over
4: Exit
```

### Step 7

``` r
ℹ GitHub (step 7 of 10)

GitHub (https://github.com) is a great way to collaborate and share
your code with others. Others can install your package from GitHub and also
systematically contribute to your package by reporting issues or even orovide
pull requests.

Answering Yes implies the following when subsequently calling `ensure_good_start()`:

✓ Prerequisites:
  - You have a GitHub account and know your account's user name
✓ [Next step] You'll be asked for your GitHub user name
✓ [Next step] You'll be asked for a GitHub repository name that will be
  set as your remote Git repository with name origin
✓ [Next step] You'll be asked how you want to authenticate to GitHub: via
  SSH (recommended) or via HTTPS authentication. Your answer
  determines the URL structure of the remote Git repository that is added:
  - SSH: 'ssh:/git@github.com:{user_name}/{repo_name}.git'
  - HTTPS: 'https:/github.com/{user_name}/{repo_name}.git'

Do you want to use GitHub? 

1: Yes
2: No
3: Let me start over
4: Exit
```

#### Step 7.1

``` r
What's your GitHub user name? Enter without quotes: rappster
```

#### Step 7.2

``` r
Is your GitHub repository name the same as your package's name ('goodstart')? 

1: Yes
2: No
3: Let me start over
4: Exit
```

#### Step 7.3

``` r
How would you like to authenticate to GitHub? 

1: ssh
2: https
3: Let me start over
4: Exit
```

### Step 8

``` r
ℹ Continuous integration (step 8 of 10)

Continuous integration (CI) is extremely important as it helps you deploy
early and often with the confidence of automatically checking your package on
different OS platforms (optionally also running your unit tests).

You can currently choose from the following CI platforms that support R
packages:
  - GitHub Actions (https://github.com/features/actions)
  - Travis CI (https://travis-ci.org/)
  - Appveyor (https://www.appveyor.com/)

Answering Yes implies the following when subsequently calling `ensure_good_start()`:

✓ Different side effects (creation of necessary artefacts such as configuration
  files, etc.) depending on your platform choice

Do you want to use a CI platform? 

1: github_actions
2: travis_ci
3: appveyor
4: Let me start over
5: Exit
```

### Step 9

``` r
ℹ Continuous integration: test coverage service (step 9 of 10)

If you use unit tests, quantify test coverage locally and use a continuous
integration platform, then it makes sense to include test coverage in your CI
pipeline

You can currently choose from the following CI platforms that are specialized on
test coverage and that support R packages:
  - Codecov (https://codecov.io/)
  - Coveralls (https://coveralls.io/)

Answering Yes implies the following when subsequently calling `ensure_good_start()`:

✓ Prerequisites:
  - You've said Yes to unit testing
  - You've said Yes to reporting test coverage
  - You've said Yes to using continuous integration (CI)
✓ Under the hood `use_coverage({type})` is called which triggers CI
  platform specific side effects (e.g. creating config YAML files, etc.)

Which CI test coverage service would you like to integrate with? 

1: codecov
2: coveralls
3: None
4: Let me start over
5: Exit
```

### Step 10

``` r
ℹ Code life cycle (step 10 of 10)

Using package `lifecycle` (https://lifecycle.r-lib.org/) helps
inform others about the life cycle state of your development

It provides a set of tools and conventions to manage the life cycle of your
exported functions and the package as a whole.

Answering Yes implies the following when subsequently calling `ensure_good_start()`:

✓ Package `lifecycle` will be installed if necessary
✓ Package `lifecycle` will be added to the Suggests section of
  your DESCRIPTION file
✓ Necessary infrastructure components such as graphics for badges etc. will be
  created within the 'man/' directory

Do you want to use package `lifecycle` to better inform users of your
package? 

1: Yes
2: No
3: Let me start over
4: Exit
```

## Future development

Going forward, amongst many other things, I’d like to:

1.  Improve the management of “goodstart configuration” that either came
    out of `goodstart_config()` or `ask()` in you user’s home directory.
    
    See `write_goodstart_config()`, `read_goodstart_config()` and
    `exists_goodstart_config()`. Not nearly done, but it’s a start.

2.  Bundle all “intrusive actions with side effects” such as installing
    required packages, setting up Git/GitHub stuff etc. in order to make
    them much more transparent, easier for developers to assess and to
    customize to their needs.

3.  Follow even more of the emerging best practices regarding paradigms,
    workflows and actual tasks/steps/tools
