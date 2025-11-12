# Report packages with version conflicts in another repository.

Report packages with higher versions in different repositories. A higher
version in a different repository could cause that repository to
override R-multiverse in
[`install.packages()`](https://rdrr.io/r/utils/install.packages.html).

## Usage

``` r
issues_version_conflicts(meta = meta_packages(), repo = "cran")
```

## Arguments

- meta:

  Package metadata from
  [`meta_packages()`](https://r-multiverse.org/multiverse.internals/reference/meta_packages.md).

- repo:

  Character string naming the repository to compare versions.

## Value

A data frame with one row for each problematic package and columns with
details.

## See also

Other issues:
[`issues_advisories()`](https://r-multiverse.org/multiverse.internals/reference/issues_advisories.md),
[`issues_dependencies()`](https://r-multiverse.org/multiverse.internals/reference/issues_dependencies.md),
[`issues_licenses()`](https://r-multiverse.org/multiverse.internals/reference/issues_licenses.md),
[`issues_r_cmd_check()`](https://r-multiverse.org/multiverse.internals/reference/issues_r_cmd_check.md),
[`issues_remotes()`](https://r-multiverse.org/multiverse.internals/reference/issues_remotes.md),
[`issues_synchronization()`](https://r-multiverse.org/multiverse.internals/reference/issues_synchronization.md),
[`issues_versions()`](https://r-multiverse.org/multiverse.internals/reference/issues_versions.md)

## Examples

``` r
if (FALSE) { # \dontrun{
issues_version_conflicts()
} # }
```
