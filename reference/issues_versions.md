# Package version issues.

Check package version number history for compliance.

## Usage

``` r
issues_versions(versions)
```

## Arguments

- versions:

  Character of length 1, file path to a JSON manifest tracking the
  history of released versions of packages.

## Value

A data frame with one row for each problematic package and columns with
the package names and version issues.

## Details

This function checks the version number history of packages in
R-multiverse and reports any packages with issues. The current released
version of a given package must be unique, and it must be greater than
all the versions of all the previous package releases.

## See also

Other issues:
[`issues_advisories()`](https://r-multiverse.org/multiverse.internals/reference/issues_advisories.md),
[`issues_dependencies()`](https://r-multiverse.org/multiverse.internals/reference/issues_dependencies.md),
[`issues_licenses()`](https://r-multiverse.org/multiverse.internals/reference/issues_licenses.md),
[`issues_r_cmd_check()`](https://r-multiverse.org/multiverse.internals/reference/issues_r_cmd_check.md),
[`issues_remotes()`](https://r-multiverse.org/multiverse.internals/reference/issues_remotes.md),
[`issues_synchronization()`](https://r-multiverse.org/multiverse.internals/reference/issues_synchronization.md),
[`issues_version_conflicts()`](https://r-multiverse.org/multiverse.internals/reference/issues_version_conflicts.md)

## Examples

``` r
  lines <- c(
    "[",
    " {",
    " \"package\": \"package_unmodified\",",
    " \"version_current\": \"1.0.0\",",
    " \"hash_current\": \"hash_1.0.0\",",
    " \"version_highest\": \"1.0.0\",",
    " \"hash_highest\": \"hash_1.0.0\"",
    " },",
    " {",
    " \"package\": \"version_decremented\",",
    " \"version_current\": \"0.0.1\",",
    " \"hash_current\": \"hash_0.0.1\",",
    " \"version_highest\": \"1.0.0\",",
    " \"hash_highest\": \"hash_1.0.0\"",
    " },",
    " {",
    " \"package\": \"version_incremented\",",
    " \"version_current\": \"2.0.0\",",
    " \"hash_current\": \"hash_2.0.0\",",
    " \"version_highest\": \"2.0.0\",",
    " \"hash_highest\": \"hash_2.0.0\"",
    " },",
    " {",
    " \"package\": \"version_unmodified\",",
    " \"version_current\": \"1.0.0\",",
    " \"hash_current\": \"hash_1.0.0-modified\",",
    " \"version_highest\": \"1.0.0\",",
    " \"hash_highest\": \"hash_1.0.0\"",
    " }",
    "]"
  )
  versions <- tempfile()
  writeLines(lines, versions)
  out <- issues_versions(versions)
  str(out)
#> 'data.frame':    2 obs. of  2 variables:
#>  $ package : chr  "version_decremented" "version_unmodified"
#>  $ versions:List of 2
#>   ..$ :List of 4
#>   .. ..$ version_current: chr "0.0.1"
#>   .. ..$ hash_current   : chr "hash_0.0.1"
#>   .. ..$ version_highest: chr "1.0.0"
#>   .. ..$ hash_highest   : chr "hash_1.0.0"
#>   ..$ :List of 4
#>   .. ..$ version_current: chr "1.0.0"
#>   .. ..$ hash_current   : chr "hash_1.0.0-modified"
#>   .. ..$ version_highest: chr "1.0.0"
#>   .. ..$ hash_highest   : chr "hash_1.0.0"
```
