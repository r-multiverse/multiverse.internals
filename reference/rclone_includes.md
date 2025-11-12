# Write Rclone includes.

Write text files to pass to the `--include-from` flag in Rclone when
uploading snapshots.

## Usage

``` r
rclone_includes(path_staging)
```

## Arguments

- path_staging:

  Character string, directory path to the source files of the Staging
  universe.

## See also

Other staging:
[`filter_meta()`](https://r-multiverse.org/multiverse.internals/reference/filter_meta.md),
[`freeze_dependencies()`](https://r-multiverse.org/multiverse.internals/reference/freeze_dependencies.md),
[`stage_candidates()`](https://r-multiverse.org/multiverse.internals/reference/stage_candidates.md)

## Examples

``` r
if (FALSE) { # \dontrun{
url_staging = "https://github.com/r-multiverse/staging"
path_staging <- tempfile()
path_community <- tempfile()
gert::git_clone(url = url_staging, path = path_staging)
stage_candidates(path_staging = path_staging)
rclone_includes(path_staging)
} # }
```
