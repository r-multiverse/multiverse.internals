# Stage release candidates

Stage release candidates for the targeted Production snapshot.

## Usage

``` r
stage_candidates(path_staging)
```

## Arguments

- path_staging:

  Character string, directory path to the source files of the Staging
  universe.

## Value

`NULL` (invisibly)

## Details

`stage_candidates()` implements the candidate freeze during the
month-long period prior to the Production snapshot. Packages that pass
R-multiverse checks are frozen (not allowed to update further) and
staged for Production. Packages with at least one failing not staged for
Production, and maintainers can update them with new GitHub/GitLab
releases.

`stage_candidates()` writes `packages.json` to control contents of the
Staging universe.

## See also

Other staging:
[`filter_meta()`](https://r-multiverse.org/multiverse.internals/reference/filter_meta.md),
[`freeze_dependencies()`](https://r-multiverse.org/multiverse.internals/reference/freeze_dependencies.md),
[`rclone_includes()`](https://r-multiverse.org/multiverse.internals/reference/rclone_includes.md)

## Examples

``` r
if (FALSE) { # \dontrun{
url_staging <- "https://github.com/r-multiverse/staging"
path_staging <- tempfile()
gert::git_clone(url = url_staging, path = path_staging)
stage_candidates(path_staging = path_staging)
} # }
```
