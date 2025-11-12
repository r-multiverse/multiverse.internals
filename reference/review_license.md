# Review a package license.

Review a package license string from the `DESCRIPTION` file to make sure
the package has a valid free open-source (FOSS) license. This is vital
to make sure R-multiverse has legal permission to distribute the package
source code.

## Usage

``` r
review_license(license)
```

## Arguments

- license:

  Character string with the `"License:"` field of the `DESCRIPTION` file
  of the package in question.

## Value

Invisibly returns `TRUE` if the package has a valid free open-source
(FOSS) license according to
[`tools::analyze_license()`](https://rdrr.io/r/tools/licensetools.html).
`FALSE` otherwise. `review_license()` also prints an R console message
to the communicate the result. Licenses for which `review_license()`
returns `FALSE` are prohibited in R-multiverse.

## See also

Other Manual package reviews:
[`review_package()`](https://r-multiverse.org/multiverse.internals/reference/review_package.md)

## Examples

``` r
  review_license("MIT + file LICENSE")
#> ✔ License "MIT + file LICENSE" is okay.
  review_license("just file LICENSE")
#> ✖ License "just file LICENSE" is prohibited.
```
