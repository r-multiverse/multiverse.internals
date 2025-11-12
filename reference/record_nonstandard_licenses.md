# Record nonstandard licenses

R-multiverse packages must have valid free and open-source (FOSS)
licenses to protect the intellectual property rights of the package
owners (c.f.
<https://en.wikipedia.org/wiki/Free_and_open-source_software>).
`record_nonstandard_licenses()` records packages with nonstandard
licenses.

## Usage

``` r
record_nonstandard_licenses(
  path_status = "status.json",
  path_nonstandard_licenses = "nonstandard_licenses.json"
)
```

## Arguments

- path_status:

  Character string, local path to the `status.json` file of the
  repository.

- path_nonstandard_licenses:

  Character string, output path to write JSON data with the names and
  licenses of packages with non-standard licenses.

## Value

`NULL` (invisibly). Called for its side effects.
