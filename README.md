
<!-- README.md is generated from README.Rmd. Please edit that file -->

# goodstart (0.0.0.9006)

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/rappster/goodstart/workflows/R-CMD-check/badge.svg)](https://github.com/rappster/goodstart/actions)
[![Codecov test
coverage](https://codecov.io/gh/rappster/goodstart/branch/master/graph/badge.svg)](https://codecov.io/gh/rappster/goodstart?branch=master)
<!-- badges: end -->

Have a good start when developing packages

`{goodstart}` tries to set up a number of workflow aspects that are
considered best practice for R developers to provide you with an initial
package state where “everything is all set and ready to go”.

It does so by providing convenience wrappers (function family
`ensure_*()`) around best practice functionality of `{usethis}` and
friends mixed with some custom functions to ensure certain things.

The goal is basically to give developers a “one stop shop” function that
bundles all those calls to `usethis::use_*()` functions that you would
normally perform when setting up a new package project.

## Disclaimer

I developed this package to scratch my own itch as configuring each new
package project via `usethis::use_*()` calls, looking up or copying
around config files or README files, etc., usually still took me about
45 min to an hour - which I feel is way to much time to get started.

Thus, the package in **its current state is very opinionated** to
streamline **my own** development process.

However, I’ll try my best to adapt it to the needs of other developers
as I go along in case there’s interested.

## Pledge

I’m absolutely fascinated by all the great workflow tooling that has
emerged and continues to do so for R developers.

Just a couple
    examples

  - [`{devtools}`](https://devtools.r-lib.org/)
  - [`{usethis}`](https://usethis.r-lib.org/)
  - [\`{goodpractice}](http://mangothecat.github.io/goodpractice/)
  - [`{lintr}`](https://www.tidyverse.org/blog/2017/12/workflow-vs-script/)
  - [`{covr}`](http://covr.r-lib.org/index.html)
  - [`{drake}`](https://docs.ropensci.org/drake/index.html)
  - [R Hub blog post on workflow
    automation](https://blog.r-hub.io/2020/04/29/maintenance/)
  - …

While I’m not yet as familiar as I’d like to be with all of the above
paradigms, workflows and packages, I’ll try follow and support emerging
best practices and (de facto) standard workflows the best that I can as
this package evolves.

Any suggestions or help are greatly appreciated.

## Installation

### Stable releases on [CRAN](https://CRAN.R-project.org)

Not available yet.

### Stable releases on [GitHub](https://github.com/)

``` r
remotes::install_github(
  "rappster/goodstart",
  ref = "release-{release_version}"
)
```

Substitute the placeholder `{release_version}` with a [semantic version
number](https://semver.org/) of your choice (e.g. `0.0.1`).

Make sure that an actual Git branch for your desired version exists.

### Development releases on [GitHub](https://github.com/)

``` r
remotes::install_github("rappster/goodstart")
```

This installs the version in Git branch `master`

## Usage

To be added
