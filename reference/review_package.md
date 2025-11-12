# Review a package.

Review a package for registration in R-multiverse.

## Usage

``` r
review_package(name, url, advisories = NULL)
```

## Arguments

- name:

  Character string, name of the package to check.

- url:

  Either a character string with the package URL or a custom JSON string
  with a package entry.

- advisories:

  Character vector of names of packages with advisories in the R
  Consortium Advisory Database. If `NULL`, then `review_package_text()`
  downloads the advisory database and checks if the package has a
  vulnerability listed there. The advisory database is cached internally
  for performance.

## Value

Invisibly returns `TRUE` if there is a problem with the package entry,
otherwise `FALSE` if there are no issues. In either case,
`review_package()` prints an R console message with the result.

For security reasons, `review_package()` might only print the first
finding it encounters. If that happens, there will be an informative
note at the end of the console message, and compliance with R-multiverse
policies will need to be checked manually. In particular, please use
[`review_license()`](https://r-multiverse.org/multiverse.internals/reference/review_license.md)
to check the `"License:"` field in the package `DESCRIPTION` file.

## Details

`review_package()` runs all the checks from
<https://r-multiverse.org/review.html#automatic-acceptance> that can be
done using the package name and source code repository URL.

## See also

Other Manual package reviews:
[`review_license()`](https://r-multiverse.org/multiverse.internals/reference/review_license.md)

## Examples

``` r
  review_package(
    name = "webchem",
    url = "https://github.com/ropensci/webchem"
  )
#> ✔ package webchem passed cursory checks for policy compliance.
  review_package(
    name = "polars",
    url = "https://github.com/pola-rs/r-polars"
  )
#> ✖ package polars did not pass cursory checks for policy compliance. Findings:
#> 
#> Package name 'polars' is different from the repository name in the URL 'https://github.com/pola-rs/r-polars'
```
