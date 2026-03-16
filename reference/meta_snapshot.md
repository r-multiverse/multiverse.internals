# Snapshot metadata

Show the metadata for the current targeted Production snapshot.

## Usage

``` r
meta_snapshot(today = Sys.Date())
```

## Arguments

- today:

  An object that [`as.Date()`](https://rdrr.io/r/base/as.Date.html) can
  convert to class `"Date"`.

## Value

A data frame with one row and columns with metadata about the targeted
snapshot.

## See also

Other meta:
[`meta_packages()`](https://r-multiverse.org/multiverse.internals/reference/meta_packages.md)

## Examples

``` r
  meta_snapshot(today = Sys.Date())
#>   dependency_freeze candidate_freeze   snapshot   r
#> 1        2026-01-15       2026-02-15 2026-03-15 4.5
#>                                              cran
#> 1 https://packagemanager.posit.co/cran/2026-01-15
#>                                     r_multiverse
#> 1 https://production.r-multiverse.org/2026-03-15
```
