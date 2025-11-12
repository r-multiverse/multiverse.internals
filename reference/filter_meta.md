# Filter `PACKAGES` and `PACKAGES.gz` metadata files.

Filter the `PACKAGES` and `PACKAGES.gz` files to only list certain
packages.

## Usage

``` r
filter_meta(path_meta, path_staging)
```

## Arguments

- path_meta:

  Directory path where `PACKAGES` and `PACKAGES.gz` files reside
  locally.

- path_staging:

  Path to a GitHub clone of the Staging universe.

## See also

Other staging:
[`freeze_dependencies()`](https://r-multiverse.org/multiverse.internals/reference/freeze_dependencies.md),
[`rclone_includes()`](https://r-multiverse.org/multiverse.internals/reference/rclone_includes.md),
[`stage_candidates()`](https://r-multiverse.org/multiverse.internals/reference/stage_candidates.md)

## Examples

``` r
if (FALSE) { # \dontrun{
path_meta <- tempfile()
dir.create(path_meta)
mock <- system.file(
  file.path("mock", "meta"),
  package = "multiverse.internals",
  mustWork = TRUE
)
file.copy(mock, path_meta, recursive = TRUE)
path_staging <- tempfile()
url_staging <- "https://github.com/r-multiverse/staging"
gert::git_clone(url = url_staging, path = path_staging)
filter_meta(path_meta, path_staging)
} # }
```
