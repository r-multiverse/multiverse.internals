# Validate the URL of a package on CRAN.

If the package is on CRAN, validate that the contributed URL appears in
the CRAN-hosted DESCRIPTION file.

## Usage

``` r
assert_cran_url(name, url)
```

## Arguments

- name:

  Character of length 1, contributed name of the package.

- url:

  Character of length 1, contributed URL of the package.

## Value

A character string if there is a problem with the package entry,
otherwise `NULL` if there are no issues.
