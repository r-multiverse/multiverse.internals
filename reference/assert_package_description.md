# Assert package `DESCRIPTION`

Run basic assertions on the `DESCRIPTION` file of a package on GitHub or
GitLab.

## Usage

``` r
assert_package_description(name, url)
```

## Arguments

- name:

  Character string, name of the package listing contribution to
  R-multiverse.

- url:

  Character string, URL of the package on GitHub or GitLab.

## Value

A character string with an informative message if a problem was found.
Otherwise, `NULL` if there are no issues.
