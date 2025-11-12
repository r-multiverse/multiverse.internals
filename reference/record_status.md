# Record package status.

Record R-multiverse package status in package-specific JSON files.

## Usage

``` r
record_status(
  repo = "https://community.r-multiverse.org",
  versions = "versions.json",
  output = "status.json",
  staging = NULL,
  mock = NULL,
  verbose = FALSE
)
```

## Arguments

- repo:

  URL of the repository to query.

- versions:

  Character of length 1, file path to a JSON manifest tracking the
  history of released versions of packages.

- output:

  Character string, file path to the JSON file to record new package
  status. Each call to `record_status()` overwrites the contents of the
  file.

- staging:

  Character string, file path to the JSON manifest of package versions
  in the Staging universe. Used to identify staged packages. Set to
  `NULL` (default) to ignore when processing the Community universe.

- mock:

  For testing purposes only, a named list of data frames for inputs to
  various intermediate functions.

- verbose:

  `TRUE` to print progress while checking dependency status, `FALSE`
  otherwise.

## Value

`NULL` (invisibly).

## Package status

Functions like
[`issues_versions()`](https://r-multiverse.org/multiverse.internals/reference/issues_versions.md)
and
[`issues_r_cmd_check()`](https://r-multiverse.org/multiverse.internals/reference/issues_r_cmd_check.md)
perform health checks for all packages in R-multiverse. For a complete
list of checks, see the `issues_*()` functions listed at
<https://r-multiverse.org/multiverse.internals/reference/index.html>.
[`record_versions()`](https://r-multiverse.org/multiverse.internals/reference/record_versions.md)
updates the version number history of releases in R-multiverse, and
`record_status()` gathers together all the status about R-multiverse
packages.

## Examples

``` r
if (FALSE) { # \dontrun{
output <- tempfile()
versions <- tempfile()
repo <- "https://community.r-multiverse.org"
record_versions(versions = versions, repo = repo)
record_status(repo = repo, versions = versions, output = output)
writeLines(readLines(output))
} # }
```
