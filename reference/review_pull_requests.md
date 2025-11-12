# Review R-multiverse contribution pull requests.

Review pull requests which add packages to `packages.json`.

## Usage

``` r
review_pull_requests(owner = "r-multiverse", repo = "contributions")
```

## Arguments

- owner:

  Character of length 1, name of the package repository owner.

- repo:

  URL of the repository to query.

## Value

`NULL` (invisibly).

## See also

Other Automated package reviews:
[`review_pull_request()`](https://r-multiverse.org/multiverse.internals/reference/review_pull_request.md)
