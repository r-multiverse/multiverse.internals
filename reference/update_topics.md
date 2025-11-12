# Update topics

Update the list of packages for each R-multiverse topic.

## Usage

``` r
update_topics(path, repo = "https://community.r-multiverse.org", mock = NULL)
```

## Arguments

- path:

  Character string, local file path to the topics repository source
  code.

- repo:

  Character string, URL of the Community universe.

- mock:

  List of named objects for testing purposes only.

## Value

`NULL` (invisibly). Called for its side effects.

## Examples

``` r
if (FALSE) { # \dontrun{
path <- tempfile()
gert::git_clone("https://github.com/r-multiverse/topics", path = path)
update_topics(path = path, repo = "https://community.r-multiverse.org")
} # }
```
