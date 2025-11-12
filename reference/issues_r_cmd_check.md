# R-universe package `R CMD check` issues.

Report issues from `R CMD check` on R-universe.

## Usage

``` r
issues_r_cmd_check(meta = meta_packages())
```

## Arguments

- meta:

  Package metadata from
  [`meta_packages()`](https://r-multiverse.org/multiverse.internals/reference/meta_packages.md).

## Value

A data frame with one row for each problematic package and columns for
the package names and `R CMD check` issues.

## Details

`issues_r_cmd_check()` reads output from the R-universe `R CMD check`
results API to scan all R-multiverse packages for status that may have
happened during building and testing.

## Package status

Functions like
[`issues_versions()`](https://r-multiverse.org/multiverse.internals/reference/issues_versions.md)
and `issues_r_cmd_check()` perform health checks for all packages in
R-multiverse. For a complete list of checks, see the `issues_*()`
functions listed at
<https://r-multiverse.org/multiverse.internals/reference/index.html>.
[`record_versions()`](https://r-multiverse.org/multiverse.internals/reference/record_versions.md)
updates the version number history of releases in R-multiverse, and
[`record_status()`](https://r-multiverse.org/multiverse.internals/reference/record_status.md)
gathers together all the status about R-multiverse packages.

## See also

Other issues:
[`issues_advisories()`](https://r-multiverse.org/multiverse.internals/reference/issues_advisories.md),
[`issues_dependencies()`](https://r-multiverse.org/multiverse.internals/reference/issues_dependencies.md),
[`issues_licenses()`](https://r-multiverse.org/multiverse.internals/reference/issues_licenses.md),
[`issues_remotes()`](https://r-multiverse.org/multiverse.internals/reference/issues_remotes.md),
[`issues_synchronization()`](https://r-multiverse.org/multiverse.internals/reference/issues_synchronization.md),
[`issues_version_conflicts()`](https://r-multiverse.org/multiverse.internals/reference/issues_version_conflicts.md),
[`issues_versions()`](https://r-multiverse.org/multiverse.internals/reference/issues_versions.md)

## Examples

``` r
if (FALSE) { # \dontrun{
issues_r_cmd_check()
} # }
```
