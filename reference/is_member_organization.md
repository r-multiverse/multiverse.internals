# Check GitHub organization membership

Check if a GitHub user is a member of at least one of the organizations
given.

## Usage

``` r
is_member_organization(user, organizations)
```

## Arguments

- user:

  Character string, GitHub user name.

- organizations:

  Character vector of names of GitHub organizations.

## Value

`TRUE` if the user is a member of at least one of the given GitHub
organizations, `FALSE` otherwise.
