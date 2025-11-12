# List package metadata

List package metadata in an R universe.

## Usage

``` r
meta_packages(repo = "https://community.r-multiverse.org")
```

## Arguments

- repo:

  URL of the repository to query.

## Value

A data frame with one row per package and columns with package metadata.

## See also

Other meta:
[`meta_snapshot()`](https://r-multiverse.org/multiverse.internals/reference/meta_snapshot.md)

## Examples

``` r
if (FALSE) { # \dontrun{
meta_packages()
} # }
```
