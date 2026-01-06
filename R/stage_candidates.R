#' @title Stage release candidates
#' @export
#' @family staging
#' @description Stage release candidates for the targeted Production snapshot.
#' @details [stage_candidates()] implements the candidate freeze
#'   during the month-long period prior to the Production snapshot.
#'   Packages that pass R-multiverse checks are frozen
#'   (not allowed to update further) and staged for Production.
#'   Packages with at least one failing not staged for Production,
#'   and maintainers can update them with new source code releases.
#'
#'   [stage_candidates()] writes `packages.json` to control
#'   contents of the Staging universe.
#' @return `NULL` (invisibly)
#' @param path_staging Character string, directory path to the source
#'   files of the Staging universe.
#' @examples
#' \dontrun{
#' url_staging <- "https://github.com/r-multiverse/staging"
#' path_staging <- tempfile()
#' gert::git_clone(url = url_staging, path = path_staging)
#' stage_candidates(path_staging = path_staging)
#' }
stage_candidates <- function(path_staging) {
  write_packages_json(path_staging)
  write_snapshot_json(path_staging)
  write_config_json(path_staging)
  invisible()
}

write_packages_json <- function(path_staging) {
  file_staging <- file.path(path_staging, "packages.json")
  json_staging <- jsonlite::read_json(file_staging, simplifyVector = TRUE)
  json_staging[is.na(json_staging$branch)] <- "*release"
  file_status <- file.path(path_staging, "status.json")
  json_status <- jsonlite::read_json(file_status, simplifyVector = TRUE)
  json_successes <- Filter(\(status) isTRUE(status$success), json_status)
  hashes <- vapply(json_successes, \(status) status$remote_hash, character(1L))
  branches <- json_staging$branch
  names(branches) <- json_staging$package
  branches[names(hashes)] <- unname(hashes)
  json_staging$branch <- unname(branches)
  json_staging <- json_staging[order(json_staging$package), , drop = FALSE] # nolint
  jsonlite::write_json(json_staging, file_staging, pretty = TRUE)
}
