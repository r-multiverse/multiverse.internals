# Report package advisories

Report packages whose current versions have advisories in the R
Consortium Advisory Database:
<https://github.com/RConsortium/r-advisory-database>

## Usage

``` r
issues_advisories(meta = meta_packages())
```

## Arguments

- meta:

  Package metadata from
  [`meta_packages()`](https://r-multiverse.org/multiverse.internals/reference/meta_packages.md).

## Value

A data frame with one row for each problematic package and columns with
details.

## See also

Other issues:
[`issues_dependencies()`](https://r-multiverse.org/multiverse.internals/reference/issues_dependencies.md),
[`issues_licenses()`](https://r-multiverse.org/multiverse.internals/reference/issues_licenses.md),
[`issues_r_cmd_check()`](https://r-multiverse.org/multiverse.internals/reference/issues_r_cmd_check.md),
[`issues_remotes()`](https://r-multiverse.org/multiverse.internals/reference/issues_remotes.md),
[`issues_synchronization()`](https://r-multiverse.org/multiverse.internals/reference/issues_synchronization.md),
[`issues_version_conflicts()`](https://r-multiverse.org/multiverse.internals/reference/issues_version_conflicts.md),
[`issues_versions()`](https://r-multiverse.org/multiverse.internals/reference/issues_versions.md)

## Examples

``` r
if (FALSE) { # \dontrun{
issues_advisories()
} # }
```
