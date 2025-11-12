# Interpret the status of a package

Summarize the status of a package in human-readable text.

## Usage

``` r
interpret_status(package, status)
```

## Arguments

- package:

  Character string, name of the package.

- status:

  A list with one status entry per package. Obtained by reading the
  results of
  [`record_status()`](https://r-multiverse.org/multiverse.internals/reference/record_status.md).

## Value

A character string summarizing the status of a package in prose.

## See also

Other status:
[`update_status()`](https://r-multiverse.org/multiverse.internals/reference/update_status.md)
