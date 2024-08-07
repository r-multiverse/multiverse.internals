#' @title Record package issues.
#' @export
#' @keywords package check data management
#' @description Record R-multiverse package issues in
#'   package-specific JSON files.
#' @section Package issues:
#'   Functions like [issues_versions()] and [issues_descriptions()]
#'   perform health checks for all packages in R-multiverse.
#'   For a complete list of checks, see
#'   the `issues_*()` functions listed at
#'   <https://r-multiverse.org/multiverse.internals/reference/index.html>.
#'   [record_versions()] updates the version number history
#'   of releases in R-multiverse, and [record_issues()] gathers
#'   together all the issues about R-multiverse packages.
#' @section Issue files:
#'   For each package with observed problems, [record_issues()] writes
#'   an issue file. This issue file is a JSON list with one element
#'   per type of failing check. Each element has an informative name
#'   (for example, `checks`, `descriptions`, or `versions`)
#'   and a list of diagnostic information.
#'
#'   Each issue file also has a `date` field. This date the day that
#'   an issue was first noticed. It automatically resets the next time
#'   all package are resolved.
#' @return `NULL` (invisibly).
#' @inheritParams issues_checks
#' @inheritParams issues_dependencies
#' @inheritParams issues_versions
#' @inheritParams meta_checks
#' @param output Character of length 1, file path to the folder to record
#'   new package issues. Each call to `record_issues()` overwrites the
#'   contents of the repo.
#' @param mock For testing purposes only, a named list of data frames
#'   for inputs to various intermediate functions.
#' @examples
#'   repo <- "https://wlandau.r-universe.dev"
#'   output <- tempfile()
#'   versions <- tempfile()
#'   record_versions(
#'     versions = versions,
#'     repo = repo
#'   )
#'   record_issues(
#'     repo = repo,
#'     versions = versions,
#'     output = output
#'   )
#'   files <- list.files(output)
#'   print(files)
#'   package <- head(files, n = 1)
#'   if (length(package)) {
#'     print(package)
#'   }
#'   if (length(package)) {
#'     print(readLines(file.path(output, package)))
#'   }
record_issues <- function(
  repo = "https://community.r-multiverse.org",
  versions = "versions.json",
  output = "issues",
  mock = NULL,
  verbose = FALSE
) {
  today <- mock$today %||% format(Sys.Date(), fmt = "yyyy-mm-dd")
  checks <- mock$checks %||% meta_checks(repo = repo)
  packages <- mock$packages %||% meta_packages(repo = repo)
  issues <- list() |>
    add_issues(issues_checks(meta = checks), "checks") |>
    add_issues(issues_descriptions(meta = packages), "descriptions") |>
    add_issues(issues_versions(versions = versions), "versions")
  issues <- issues |>
    add_issues(
      issues_dependencies(names(issues), packages, verbose = verbose),
      "dependencies"
    )
  overwrite_issues(
    issues = issues,
    output = output,
    today = today,
    packages = packages
  )
  invisible()
}

add_issues <- function(total, subset, category) {
  for (package in names(subset)) {
    total[[package]][[category]] <- subset[[package]]
  }
  total
}

overwrite_issues <- function(issues, output, today, packages) {
  with_issues <- list.files(output)
  dates <- lapply(
    X = with_issues,
    FUN = function(path) {
      jsonlite::read_json(file.path(output, path), simplifyVector = TRUE)$date
    }
  )
  names(dates) <- with_issues
  unlink(output, recursive = TRUE)
  dir.create(output)
  lapply(
    X = names(issues),
    FUN = overwrite_package_issues,
    issues = issues,
    output = output,
    today = today,
    dates = dates,
    packages = packages
  )
}

overwrite_package_issues <- function(
  package,
  issues,
  output,
  today,
  dates,
  packages
) {
  path <- file.path(output, package)
  issues[[package]]$date <- dates[[package]] %||% today
  index <- packages$package == package
  issues[[package]]$version <- packages[["version"]][index]
  issues[[package]]$remote_hash <- packages[["remotesha"]][index]
  jsonlite::write_json(
    x = issues[[package]],
    path = file.path(output, package),
    pretty = TRUE
  )
}
