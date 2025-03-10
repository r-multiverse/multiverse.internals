#' @title Stage release candidates
#' @export
#' @family staging
#' @description Stage release candidates for the targeted Production snapshot.
#' @details [stage_candidates()] implements the candidate freeze
#'   during the month-long period prior to the Production snapshot.
#'   Packages that pass R-multiverse checks are frozen
#'   (not allowed to update further) and staged for Production.
#'   Packages with at least one failing not staged for Production,
#'   and maintainers can update them with new GitHub/GitLab releases.
#'
#'   [stage_candidates()] writes `packages.json` to control
#'   contents of the Staging universe.
#'   It also writes `staged.json` to track packages staged for Production,
#'   a `snapshot.json` file with metadata on the snapshot,
#'   and `snapshot.url` with an API call to download staged packages.
#' @return `NULL` (invisibly)
#' @inheritParams record_issues
#' @param path_staging Character string, directory path to the source
#'   files of the staging universe.
#' @param path_community Character string, directory path to the source
#'   files of the community universe.
#' @param repo_community Character string, URL of the community universe.
#' @param types Character vector, what to pass to the `types` field in the
#'   snapshot API URL. Controls the types of binaries and documentation
#'   included in the snapshot.
#' @examples
#' \dontrun{
#' url_staging = "https://github.com/r-multiverse/staging"
#' url_community = "https://github.com/r-multiverse/community"
#' path_staging <- tempfile()
#' path_community <- tempfile()
#' gert::git_clone(url = url_staging, path = path_staging)
#' gert::git_clone(url = url_community, path = path_community)
#' stage_candidates(
#'   path_staging = path_staging,
#'   path_community = path_community,
#'   repo_community = "https://community.r-multiverse.org"
#' )
#' }
stage_candidates <- function(
  path_staging,
  path_community,
  repo_community = "https://community.r-multiverse.org",
  types = c("src", "win", "mac"),
  mock = NULL
) {
  file_staging <- file.path(path_staging, "packages.json")
  file_community <- file.path(path_community, "packages.json")
  meta_community <- mock$community %||% meta_packages(repo_community)
  meta_community <- meta_community[!is.na(meta_community$remotesha),, drop = FALSE] # nolint
  json_community <- merge(
    x = jsonlite::read_json(file_community, simplifyVector = TRUE),
    y = meta_community[, c("package", "remotesha"), drop = FALSE],
    by = "package",
    all.x = TRUE, # Must be in Community packages.json.
    all.y = TRUE # Must be built on the Community universe.
  )
  json_community$branch <- json_community$remotesha
  json_community$remotesha <- NULL
  path_issues <- file.path(path_staging, "issues.json")
  json_issues <- list()
  if (file.exists(path_issues)) {
    json_issues <- jsonlite::read_json(path_issues, simplifyVector = TRUE)
  }
  staged <- names(
    Filter(
      x = json_issues,
      f = function(issue) isTRUE(issue$success)
    )
  )
  file_staged <- file.path(path_staging, "staged.json")
  # If a Staging cycle is already underway,
  if (file.exists(file_staged) && file.exists(file_staging)) {
    # then the no packages can enter or leave the Staging universe,
    json_staging <- as.data.frame(
      jsonlite::read_json(file_staging, simplifyVector = TRUE),
      stringsAsFactors = FALSE
    )
    # and staged packages stay staged.
    staged <- base::union(
      staged,
      jsonlite::read_json(file_staged, simplifyVector = TRUE)
    )
  } else  {
    json_staging <- json_community # Otherwise, refresh Staging from Community.
  }
  candidates <- json_staging$package
  update <- setdiff(candidates, staged)
  should_stage <- json_staging$package %in% staged
  json_staged <- json_staging[should_stage,, drop = FALSE] # nolint
  json_update <- json_community[json_community$package %in% update,, drop = FALSE] # nolint
  json_staged$subdir <- json_staged$subdir %||%
    rep(NA_character_, nrow(json_staged))
  json_update$subdir <- json_update$subdir %||%
    rep(NA_character_, nrow(json_update))
  json_new <- rbind(json_staged, json_update)
  json_new <- json_new[order(json_new$package), ]
  jsonlite::write_json(json_new, file_staging, pretty = TRUE)
  jsonlite::write_json(staged, file_staged, pretty = TRUE)
  snapshot <- meta_snapshot()
  url <- paste0(
    "https://staging.r-multiverse.org/api/snapshot/tar",
    "?types=",
    paste(types, collapse = ","),
    paste0("&binaries=", snapshot$r),
    "&skip_packages=",
    paste(setdiff(candidates, staged), collapse = ",")
  )
  writeLines(url, file.path(path_staging, "snapshot.url"))
  jsonlite::write_json(
    snapshot,
    file.path(path_staging, "snapshot.json"),
    pretty = TRUE
  )
  write_config_json(path_staging)
  invisible()
}
