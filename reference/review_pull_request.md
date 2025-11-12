# Review an R-multiverse contribution pull request.

Review a pull request to add packages to R-multiverse.

## Usage

``` r
review_pull_request(
  owner = "r-multiverse",
  repo = "contributions",
  number,
  advisories = NULL,
  organizations = NULL
)
```

## Arguments

- owner:

  Character of length 1, name of the package repository owner.

- repo:

  URL of the repository to query.

- number:

  Positive integer of length 1, index of the pull request in the repo.

- advisories:

  Character vector of names of packages with advisories in the R
  Consortium Advisory Database. If `NULL`, the function reads the
  database.

- organizations:

  Character vector of names of GitHub organizations. Pull requests from
  authors who are not members of at least one of these organizations
  will be flagged for manual review. If `NULL`, the function reads the
  list of trusted organizations.

## Value

`NULL` (invisibly).

## See also

Other Automated package reviews:
[`review_pull_requests()`](https://r-multiverse.org/multiverse.internals/reference/review_pull_requests.md)
