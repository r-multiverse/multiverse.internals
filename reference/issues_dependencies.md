# Report package dependency issues

Flag packages which have issues in their strong dependencies
(`Imports:`, `Depends:`, and `LinkingTo:` in the `DESCRIPTION`.) These
include indirect/upstream dependencies, as well, not just the explicit
mentions in the `DESCRIPTION` file.

## Usage

``` r
issues_dependencies(packages, meta = meta_packages(), verbose = FALSE)
```

## Arguments

- packages:

  Character vector of names of packages with other issues.

- meta:

  Package metadata from
  [`meta_packages()`](https://r-multiverse.org/multiverse.internals/reference/meta_packages.md).

- verbose:

  `TRUE` to print progress while checking dependency status, `FALSE`
  otherwise.

## Value

A data frame with one row for each package impacted by upstream
dependencies. Each element of the `dependencies` column is a nested list
describing the problems upstream.

To illustrate the structure of this list, suppose Package `tarchetypes`
depends on package `targets`, and packages `jagstargets` and
`stantargets` depend on `tarchetypes`. In addition, package `targets`
has a problem in `R CMD check` which might cause problems in
`tarchetypes` and packages downstream.

`status_dependencies()` represents this information in the following
list:

    list(
      jagstargets = list(targets = "tarchetypes"),
      tarchetypes = list(targets = character(0)),
      stantargets = list(targets = "tarchetypes")
    )

In general, the returned list is of the form:

    list(
      impacted_reverse_dependency = list(
        upstream_culprit = c("direct_dependency_1", "direct_dependency_2")
      )
    )

where `upstream_culprit` causes problems in
`impacted_reverse_dependency` through direct dependencies
`direct_dependency_1` and `direct_dependency_2`.

## See also

Other issues:
[`issues_advisories()`](https://r-multiverse.org/multiverse.internals/reference/issues_advisories.md),
[`issues_licenses()`](https://r-multiverse.org/multiverse.internals/reference/issues_licenses.md),
[`issues_r_cmd_check()`](https://r-multiverse.org/multiverse.internals/reference/issues_r_cmd_check.md),
[`issues_remotes()`](https://r-multiverse.org/multiverse.internals/reference/issues_remotes.md),
[`issues_synchronization()`](https://r-multiverse.org/multiverse.internals/reference/issues_synchronization.md),
[`issues_version_conflicts()`](https://r-multiverse.org/multiverse.internals/reference/issues_version_conflicts.md),
[`issues_versions()`](https://r-multiverse.org/multiverse.internals/reference/issues_versions.md)

## Examples

``` r
if (FALSE) { # \dontrun{
issues_dependencies(packages = "targets")
} # }
```
