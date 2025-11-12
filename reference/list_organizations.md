# List trusted GitHub organizations.

List trusted GitHub organizations for the purposes of automated
contribution reviews.

## Usage

``` r
list_organizations(owner = "r-multiverse", repo = "contributions")
```

## Arguments

- owner:

  Character string, name of the R-multiverse GitHub organization.

- repo:

  Character string, name of the R-multiverse contribution GitHub
  repository.

## Value

A character vector of the names of trusted GitHub organizations.

## Details

The R-multiverse contribution review bot flags contributions for manual
review whose pull request authors are not public members of one of the
trusted GitHub organizations.
