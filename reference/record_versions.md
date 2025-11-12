# Record the manifest of package versions.

Record the manifest of versions of packages and their hashes.

## Usage

``` r
record_versions(
  versions = "versions.json",
  repo = "https://community.r-multiverse.org",
  current = multiverse.internals::get_current_versions(repo = repo)
)
```

## Arguments

- versions:

  Character of length 1, file path to a JSON manifest tracking the
  history of released versions of packages.

- repo:

  URL of the repository to query.

- current:

  A data frame of current versions and hashes of packages in `repo`.
  This argument is exposed for testing only.

## Value

`NULL` (invisibly). Writes version information to a JSON file.

## Details

This function tracks a manifest containing the current version, the
current hash, the highest version ever released, and the hash of the
highest version ever released.
[`issues_versions()`](https://r-multiverse.org/multiverse.internals/reference/issues_versions.md)
uses this information to determine whether the package complies with
best practices for version numbers.

## Package status

Functions like
[`issues_versions()`](https://r-multiverse.org/multiverse.internals/reference/issues_versions.md)
and
[`issues_r_cmd_check()`](https://r-multiverse.org/multiverse.internals/reference/issues_r_cmd_check.md)
perform health checks for all packages in R-multiverse. For a complete
list of checks, see the `issues_*()` functions listed at
<https://r-multiverse.org/multiverse.internals/reference/index.html>.
`record_versions()` updates the version number history of releases in
R-multiverse, and
[`record_status()`](https://r-multiverse.org/multiverse.internals/reference/record_status.md)
gathers together all the status about R-multiverse packages.

## Examples

``` r
if (FALSE) { # \dontrun{
output <- tempfile()
versions <- tempfile()
# First snapshot:
record_versions(
  versions = versions,
  repo = repo
)
readLines(versions)
# In subsequent snapshots, we have historical information about versions.
record_versions(
  versions = versions,
  repo = repo
)
readLines(versions)
} # }
```
