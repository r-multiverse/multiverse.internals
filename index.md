# multiverse.internals

[![check](https://github.com/r-multiverse/multiverse.internals/actions/workflows/check.yaml/badge.svg)](https://github.com/r-multiverse/multiverse.internals/actions?query=workflow%3Acheck)

The `multiverse.internals` supports:

1.  Interactive tools to help developers and moderators contribute
    packages to [R-multiverse](https://r-multiverse.org).
2.  Internal infrastructure to support the automation that powers
    [R-multiverse](https://r-multiverse.org).

Please visit
<https://r-multiverse.org/multiverse.internals/reference/index.html> for
documentation. To ask questions and post issues about this package or
[R-multiverse](https://r-multiverse.org) in general, please visit
<https://github.com/r-multiverse/help>.

## Installation

You can install the latest release of `multiverse.internals` from
[R-multiverse](https://r-multiverse.org).

``` r
install.packages(
  "multiverse.internals",
  repos = c("https://community.r-multiverse.org", getOption("repos"))
)
```

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("r-multiverse/multiverse.internals")
```

## Manual package reviews

The
[`review_package()`](https://r-multiverse.org/multiverse.internals/reference/review_package.md)
function helps contributors and moderators check packages for compliance
with [R-multiverse policies](https://r-multiverse.org/policies.html). It
attempts to run all the checks at
<https://r-multiverse.org/review.html#automatic-acceptance> which can be
performed using the package name and URL alone. These checks are not
exhaustive, and it might not be feasible to run them all, but they do
help with manual reviews.

``` r
library(multiverse.internals)
review_package(
  name = "webchem",
  url = "https://github.com/ropensci/webchem"
)
#> ✔ package webchem passed cursory checks for policy compliance.
```

``` r
review_package(
  name = "polars",
  url = "https://github.com/pola-rs/r-polars"
)
#> ✖ package polars did not pass cursory checks for policy compliance. Findings:
#> 
#> Package name 'polars' is different from the repository name in the URL 'https://github.com/pola-rs/r-polars'
```

Sometimes,
[`review_package()`](https://r-multiverse.org/multiverse.internals/reference/review_package.md)
may not be able to run all its checks.

``` r
review_package(
  name = "wrongpackage",
  url = "https://github.com/ropensci/invalid-repo-name"
)
#> ✖ package wrongpackage did not pass cursory checks for policy compliance. Findings:
#> 
#> URL 'https://github.com/ropensci/invalid-repo-name' returned HTTP error 404 | Not Found
#> 
#> WARNING: for security and/or practical reasons some pre-registration checks were skipped. Please manually check the package for compliance with R-multiverse policies. In particular, please check the license with multiverse.internals::review_license().
```

In those cases, it is critical to manually run
[`review_license()`](https://r-multiverse.org/multiverse.internals/reference/review_license.md)
on the `"License:"` string in the package’s `DESCRIPTION` file.
[R-multiverse](https://r-multiverse.org) requires that each package has
a valid free open-source (FOSS) license.

``` r
review_license("MIT + file LICENSE")
#> ✔ License "MIT + file LICENSE" is okay.
```

``` r
review_license("file LICENSE")
#> ✖ License "file LICENSE" is prohibited.
```
