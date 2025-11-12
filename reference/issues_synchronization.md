# Report package check synchronization issues.

Ensure the reported R-universe checks are synchronized. Report the
packages whose checks have not been synchronized.

## Usage

``` r
issues_synchronization(meta = meta_packages(), verbose = FALSE)
```

## Arguments

- meta:

  Package metadata from
  [`meta_packages()`](https://r-multiverse.org/multiverse.internals/reference/meta_packages.md).

- verbose:

  `TRUE` to print progress messages, `FALSE` otherwise.

## Value

A `tibble` with one row per package and the following columns:

- `package`: Name of the package.

- `synchronization`: Synchronization status: `"success"` if the checks
  are synchronized, `"incomplete"` if checks are still running on
  R-universe GitHub Actions, and `"recent"` if the package was last
  published so recently that downstream checks may not have started yet.

## Details

R-universe automatically rechecks downstream packages if an upstream
dependency increments its version number. R-multiverse needs to wait for
these downstream checks to finish before it makes decisions about
accepting packages into Production. `issues_synchronization()` scrapes
the GitHub Actions API to find out if any R-universe checks are still
running for a package. In addition, to give rechecks enough time to post
on GitHub Actions, it flags packages published within the last 5
minutes.

## See also

Other issues:
[`issues_advisories()`](https://r-multiverse.org/multiverse.internals/reference/issues_advisories.md),
[`issues_dependencies()`](https://r-multiverse.org/multiverse.internals/reference/issues_dependencies.md),
[`issues_licenses()`](https://r-multiverse.org/multiverse.internals/reference/issues_licenses.md),
[`issues_r_cmd_check()`](https://r-multiverse.org/multiverse.internals/reference/issues_r_cmd_check.md),
[`issues_remotes()`](https://r-multiverse.org/multiverse.internals/reference/issues_remotes.md),
[`issues_version_conflicts()`](https://r-multiverse.org/multiverse.internals/reference/issues_version_conflicts.md),
[`issues_versions()`](https://r-multiverse.org/multiverse.internals/reference/issues_versions.md)

## Examples

``` r
  if (FALSE) { # \dontrun{
  meta <- meta_packages(repo = "https://wlandau.r-universe.dev")
  issues_synchronization(meta)
  } # }
```
