# Update the package status repository

Update the repository which reports the status on individual packages.

## Usage

``` r
update_status(path_status, path_staging, path_community)
```

## Arguments

- path_status:

  Character string, directory path to the source files of the package
  status repository.

- path_staging:

  Character string, local directory path to the clone of the Staging
  universe GitHub repository.

- path_community:

  Character string, local directory path to the clone of the Community
  universe GitHub repository.

## See also

Other status:
[`interpret_status()`](https://r-multiverse.org/multiverse.internals/reference/interpret_status.md)

## Examples

``` r
if (FALSE) { # \dontrun{
url_staging <- "https://github.com/r-multiverse/staging"
url_community <- "https://github.com/r-multiverse/community"
url_status <- "https://github.com/r-multiverse/status"
path_status <- tempfile()
path_staging <- tempfile()
path_community <- tempfile()
gert::git_clone(url = url_status, path = path_status)
gert::git_clone(url = url_staging, path = path_staging)
gert::git_clone(url = url_community, path = path_community)
update_status(
  path_status = path_status,
  path_staging = path_staging,
  path_community = path_community
)
writeLines(
  readLines(
    file.path(path_status, "community", "multiverse.internals.html")
  )
)
writeLines(
  readLines(
    file.path(path_status, "community", "multiverse.internals.xml")
  )
)
} # }
```
