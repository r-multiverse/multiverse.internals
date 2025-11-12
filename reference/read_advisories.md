# Read R Consortium advisories

Read the R Consortium R Advisory database and cache it in memory for
performance.

## Usage

``` r
read_advisories(timeout = 6e+05, retries = 3L)
```

## Arguments

- timeout:

  Number of milliseconds until the database download times out.

- retries:

  Number of retries to download the database.
