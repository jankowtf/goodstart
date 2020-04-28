---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# goodstart

<!-- badges: start -->
[![R build status](https://github.com/rappster/goodstart/workflows/R-CMD-check/badge.svg)](https://github.com/rappster/goodstart/actions)
[![Codecov test coverage](https://codecov.io/gh/rappster/goodstart/branch/master/graph/badge.svg)](https://codecov.io/gh/rappster/goodstart?branch=master)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

Trying to give package developers a good start when creating a brand new
package.- by taking care that best.

`{goodstart}` tries to take care of a number of aspects that are considered best
practice for R developers. Largely, this means simply calling functionality of
`{usethis}` via convenience wrapper, but it also involves such things as making
sure that the initial `R/hello.R` and `man/hello.Rd` files are removed.

## Disclaimer

I developed this package to scratch my own itch as configuring each new package
project via `usethis` and friends usually still took me about 45 min to an hour.

Thus, the purpose of this package is currently to streamline **my own**
development process and thus it's still very opinionated.

However, I'll try my best to adapt it to the needs of other developers as I go
along.

## Installation

You can install the development version with:


```r
remotes::install_github("rappster/goodstart")
```

## Off to a good start

Load the package


```r
library(goodstart)
```

Calling the following function will set you off to a good start:


```r
ensure_good_start()
```

Also check the more fine granular `ensure_*` functions if you'd like more control over what's happening.
