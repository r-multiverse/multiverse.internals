#' @title Propose snapshot
#' @export
#' @family staging
#' @description Propose a Production snapshot of Staging.
#' @details [propose_snapshot()] proposes a snapshot of Staging
#'   to migrate to Production. The recommended snapshot is the list of
#'   packages for which (1) the build and check results of the current
#'   release are in Staging, and (2) there are no issues.
#'   Writes `snapshot.json` with an R-universe-like manifest
#'   of the packages recommended for the snapshot, and a
#'   `snapshot.url` file containing an R-universe snapshot API URL
#'   to download those packages. Both these files are written to the
#'   directory given by the `path_staging` argument.
#' @return `NULL` (invisibly). Called for its side effects.
#'   [propose_snapshot()] writes `snapshot.json` with an R-universe-like
#'   manifest of the packages recommended for the snapshot, and a
#'   `snapshot.url` file containing an R-universe snapshot API URL
#'   to download those packages. Both these files are written to the
#'   directory given by the `path_staging` argument.
#' @inheritParams update_staging
#' @param repo_staging Character string, URL of the staging universe.
#' @param types Character vector, what to pass to the `types` field in the
#'   snapshot API URL. Controls the types of binaries and documentation
#'   included in the snapshot.
#' @param r_versions Character vector of `major.minor` versions of R
#'   to download binaries. For example, `r_versions = c("4.4", "4.3")`.
#'   Set to `NULL` to let R-universe choose default versions.
#' @examples
#' \dontrun{
#' url_staging = "https://github.com/r-multiverse/staging"
#' path_staging <- tempfile()
#' gert::git_clone(url = url_staging, path = path_staging)
#' propose_snapshot(
#'   path_staging = path_staging,
#'   repo_staging = "https://staging.r-multiverse.org"
#' )
#' }
propose_snapshot <- function(
  path_staging,
  repo_staging = "https://staging.r-multiverse.org",
  types = c("src", "win", "mac"),
  r_versions = NULL,
  mock = NULL
) {
  issues <- list.files(
    file.path(path_staging, "issues"),
    all.files = TRUE,
    no.. = TRUE
  )
  file_staging <- file.path(path_staging, "packages.json")
  json_staging <- jsonlite::read_json(file_staging, simplifyVector = TRUE)
  json_staging <- json_staging[, c("package", "url", "branch")]
  meta_staging <- mock$staging %||% meta_packages(repo_staging)
  meta_staging <- meta_staging[, c("package", "remotesha")]
  staging <- merge(
    x = json_staging,
    y = meta_staging,
    all.x = FALSE,
    all.y = FALSE
  )
  staging <- staging[staging$branch == staging$remotesha,, drop = FALSE] # nolint
  staging <- staging[!(staging$package %in% issues),, drop = FALSE] # nolint
  staging$remotesha <- NULL
  file_snapshot <- file.path(path_staging, "snapshot.json")
  jsonlite::write_json(staging, file_snapshot, pretty = TRUE)
  if (!is.null(r_versions)) {
    r_versions <- paste0("&binaries=", paste(r_versions, collapse = ","))
  }
  url <- paste0(
    "https://staging.r-multiverse.org/api/snapshot/zip",
    "?types=",
    paste(types, collapse = ","),
    r_versions,
    "&packages=",
    paste(staging$package, collapse = ",")
  )
  writeLines(url, file.path(path_staging, "snapshot.url"))
  invisible()
}
