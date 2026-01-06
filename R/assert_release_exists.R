#' @title Check for a release.
#' @export
#' @keywords internal
#' @description Check for a release.
#' @return A character string if there is a problem with the package entry,
#'   otherwise `NULL` if there are no issues.
#' @inheritParams review_package
assert_release_exists <- function(url) {
  host <- tolower(url_parse(url)[["hostname"]])
  if (host == "github.com") {
    assert_release_github(url)
  } else if (host == "gitlab.com") {
    assert_release_gitlab(url)
  } else if (host == "codeberg.org") {
    assert_release_codeberg(url)
  }
}

assert_release_github <- function(url) {
  parsed_url <- url_parse(url)
  releases <- try(
    gh::gh(
      endpoint = "/repos/:owner/:repo/releases",
      owner = basename(dirname(parsed_url[["path"]])),
      repo = basename(parsed_url[["path"]])
    ),
    silent = TRUE
  )
  if (inherits(releases, "try-error")) {
    return(try_message(releases))
  }
  releases <- Filter(
    f = function(release) {
      !isTRUE(release$prerelease)
    },
    x = releases
  )
  if (!length(releases)) {
    return(no_release_message(url))
  }
}

assert_release_gitlab <- function(url) {
  parsed_url <- url_parse(url)
  owner <- basename(dirname(parsed_url[["path"]]))
  repo <- basename(parsed_url[["path"]])
  endpoint <- sprintf(
    "https://gitlab.com/api/v4/projects/%s%s%s/releases",
    owner,
    "%2F",
    repo
  )
  releases <- try(
    suppressWarnings(
      jsonlite::stream_in(
        con = gzcon(url(endpoint)),
        simplifyVector = TRUE,
        simplifyDataFrame = TRUE
      )
    ),
    silent = TRUE
  )
  if (inherits(releases, "try-error")) {
    return(try_message(releases))
  }
  if (!nrow(releases) || !any(!releases$upcoming_release)) {
    return(no_release_message(url))
  }
}

assert_release_codeberg <- function(url) {
  parsed_url <- url_parse(url)
  owner <- basename(dirname(parsed_url[["path"]]))
  repo <- basename(parsed_url[["path"]])
  endpoint <- sprintf(
    "https://codeberg.org/api/v1/repos/%s/%s/releases",
    owner,
    repo
  )
  releases <- try(
    suppressWarnings(
      jsonlite::stream_in(
        con = gzcon(url(endpoint)),
        simplifyVector = TRUE,
        simplifyDataFrame = TRUE
      )
    ),
    silent = TRUE
  )
  if (inherits(releases, "try-error")) {
    return(try_message(releases))
  }
  if (!nrow(releases) || !any(!releases$prerelease)) {
    return(no_release_message(url))
  }
}

no_release_message <- function(url) {
  github <- file.path(
    "https://docs.github.com/en/repositories",
    "releasing-projects-on-github/managing-releases-in-a-repository"
  )
  paste0(
    "No full release found at URL ",
    shQuote(url),
    ".\n\nThe R-multiverse project relies on releases from",
    "GitHub, GitLab, and Codeberg.",
    "to distribute deployed versions of R packages, so we must ",
    "ask that each contributed package host a release for its ",
    "latest non-development version.\n\n",
    "For GitHub, maintainers can refer to ",
    github,
    " for instructions. Please see ",
    "https://docs.gitlab.com/ee/user/project/releases/ for GitLab and ",
    "https://docs.codeberg.org/git/using-tags/ for Codeberg.\n\n",
    "Pre-releases (GitHub and Codeberg) and upcoming releases (GitLab) ",
    "are ignored to ensure each release has the ",
    "full endorsement of its maintainer."
  )
}
