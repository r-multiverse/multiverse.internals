#' @title Check for a release.
#' @export
#' @keywords internal
#' @description Check for a release.
#' @return A character string if there is a problem with the package entry,
#'   otherwise `NULL` if there are no issues.
#' @inheritParams assert_package
assert_release_exists <- function(url) {
  host <- url_parse(url)[["host"]]
  if (host == "github.com") {
    assert_release_github(url)
  } else if (host == "gitlab.com") {
    assert_release_gitlab(url)
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

no_release_message <- function(url) {
  github <- file.path(
    "https://docs.github.com/en/repositories",
    "releasing-projects-on-github/managing-releases-in-a-repository"
  )
  paste0(
    "No full release found at URL ",
    shQuote(url),
    ".\n\nThe R-multiverse project relies on GitHub/GitLab releases ",
    "to distribute deployed versions of R packages, so we must ",
    "ask that each contributed package host a release for its ",
    "latest non-development version.\n\n",
    "For GitHub, maintainers can refer to ",
    github,
    " for instructions. For GitLab, the directions are at ",
    "https://docs.gitlab.com/ee/user/project/releases/.\n\n",
    "Pre-releases (GitHub) and upcoming releases (GitLab) ",
    "are ignored to ensure each release has the ",
    "full endorsement of its maintainer."
  )
}
