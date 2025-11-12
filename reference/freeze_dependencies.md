# Freeze dependencies

Freeze the targeted versions of base R and CRAN packages.

## Usage

``` r
freeze_dependencies(path_staging, path_community)
```

## Arguments

- path_staging:

  Character string, directory path to the source files of the Staging
  universe.

- path_community:

  Character string, local directory path to the clone of the Community
  universe GitHub repository.

## Value

`NULL` (invisibly)

## Details

`freeze_dependencies()` runs during the month-long dependency freeze
phase of Staging in which base R and CRAN packages are locked in the
Staging universe until after the next Production snapshot. This
establishes checks in the Staging universe using the exact set of
dependencies that will be used in the candidate freeze (see
[`stage_candidates()`](https://r-multiverse.org/multiverse.internals/reference/stage_candidates.md)).

`freeze_dependencies()` copies the Community repository `packages.json`
into the Staging repository to reset the Staging process. It also writes
a `config.json` file with the date of the targeted CRAN snapshot.

## See also

Other staging:
[`filter_meta()`](https://r-multiverse.org/multiverse.internals/reference/filter_meta.md),
[`rclone_includes()`](https://r-multiverse.org/multiverse.internals/reference/rclone_includes.md),
[`stage_candidates()`](https://r-multiverse.org/multiverse.internals/reference/stage_candidates.md)

## Examples

``` r
if (FALSE) { # \dontrun{
url_staging = "https://github.com/r-multiverse/staging"
url_community = "https://github.com/r-multiverse/community"
path_staging <- tempfile()
path_community <- tempfile()
gert::git_clone(url = url_staging, path = path_staging)
gert::git_clone(url = url_community, path = path_community)
freeze_dependencies(
  path_staging = path_staging,
  path_community = path_community
)
} # }
```
