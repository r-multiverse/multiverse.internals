#' @title Update staging
#' @export
#' @family staging
#' @description Update the staging universe.
#' @details [update_staging()] controls how packages enter and leave
#'   the staging universe. It updates the staging `packages.json`
#'   manifest depending on the contents of the community
#'   universe and issues with package checks.
#' @return `NULL` (invisibly)
#' @inheritParams record_issues
#' @param path_staging Character string, directory path to the source
#'   files of the staging universe.
#' @param path_community Character string, directory path to the source
#'   files of the community universe.
#' @param repo_community Character string, URL of the community universe.
#' @examples
#' \dontrun{
#' url_staging = "https://github.com/r-multiverse/staging"
#' url_community = "https://github.com/r-multiverse/community"
#' path_staging <- tempfile()
#' path_community <- tempfile()
#' gert::git_clone(url = url_staging, path = path_staging)
#' gert::git_clone(url = url_community, path = path_community)
#' update_staging(
#'   path_staging = path_staging,
#'   path_community = path_community,
#'   repo_community = "https://community.r-multiverse.org"
#' )
#' }
update_staging <- function(
  path_staging,
  path_community,
  repo_community = "https://community.r-multiverse.org",
  mock = NULL
) {
  file_staging <- file.path(path_staging, "packages.json")
  file_community <- file.path(path_community, "packages.json")
  if (file.exists(file_staging)) {
    json_staging <- as.data.frame(
      jsonlite::read_json(file_staging, simplifyVector = TRUE),
      stringsAsFactors = FALSE
    )
  } else {
    json_staging <- data.frame()
  }
  json_community <- jsonlite::read_json(file_community, simplifyVector = TRUE)
  meta_community <- mock$community %||% meta_packages(repo_community)
  issues <- list.files(
    file.path(path_staging, "issues"),
    all.files = TRUE,
    no.. = TRUE
  )
  freeze <- setdiff(json_staging$package, issues)
  update <- setdiff(json_community$package, freeze)
  should_freeze <- json_staging$package %in% freeze
  json_freeze <- json_staging[should_freeze, ]
  json_update <- json_community[json_community$package %in% update, ]
  json_freeze$subdir <- json_freeze$subdir %||%
    rep(NA_character_, nrow(json_freeze))
  json_update$subdir <- json_update$subdir %||%
    rep(NA_character_, nrow(json_update))
  branches <- meta_community[
    meta_community$package %in% update,
    c("package", "remotesha")
  ]
  json_update <- merge(
    x = json_update,
    y = branches,
    by = "package",
    all.x = TRUE,
    all.y = FALSE
  )
  json_update <- json_update[!is.na(json_update$remotesha),, drop = FALSE] # nolint
  json_update$branch <- json_update$remotesha
  json_update$remotesha <- NULL
  json_new <- rbind(json_freeze, json_update)
  json_new <- json_new[order(json_new$package), ]
  jsonlite::write_json(json_new, file_staging, pretty = TRUE)
  invisible()
}
