# Build an R-universe `packages.json` manifest from a collection of text file contributions with individual package URLs.

Build an R-universe `packages.json` manifest from a collection of text
file contributions with individual package URLs.

## Usage

``` r
aggregate_contributions(
  input = getwd(),
  output = "packages.json",
  owner_exceptions = character(0L)
)
```

## Arguments

- input:

  Character of length 1, directory path with the text file listings of R
  releases.

- output:

  Character of length 1, file path where the R-universe `packages.json`
  file will be written.

- owner_exceptions:

  Character vector of URLs of GitHub owners where `"branch": "*release"`
  should be omitted. Example: `"https://github.com/cran"`.

## Value

NULL (invisibly)
