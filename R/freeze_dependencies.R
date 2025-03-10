#' @title Freeze dependencies
#' @export
#' @family staging
#' @description Freeze the targeted versions of base R and CRAN packages.
#' @details [freeze_dependencies()] runs during the month-long
#'   dependency freeze phase of Staging in which base R and CRAN packages
#'   are locked in the Staging universe until after the next Production
#'   snapshot. This establishes checks in the Staging universe
#'   using the exact set of dependencies that will be used in the
#'   candidate freeze (see [stage_candidates()]).
#'
#'   [freeze_dependencies()] writes a `config.json` file with the date
#'   of the targeted CRAN snapshot. It also empties `staged.json`
#'   to allow a completely new set of packages to staged in the subsequent
#'   candidate freeze.
#' @return `NULL` (invisibly)
#' @inheritParams stage_candidates
#' @examples
#' \dontrun{
#' url_staging = "https://github.com/r-multiverse/staging"
#' url_community = "https://github.com/r-multiverse/community"
#' path_staging <- tempfile()
#' path_community <- tempfile()
#' gert::git_clone(url = url_staging, path = path_staging)
#' gert::git_clone(url = url_community, path = path_community)
#' freeze_dependencies(
#'   path_staging = path_staging,
#'   path_community = path_community
#' )
#' }
freeze_dependencies <- function(path_staging, path_community) {
  write_config_json(path_staging)
  unlink(file.path(path_staging, "staged.json"), force = TRUE)
  file.copy(
    file.path(path_community, "packages.json"),
    file.path(path_staging, "packages.json"),
    overwrite = TRUE
  )
  invisible()
}

write_config_json <- function(path_staging) {
  file_config <- file.path(path_staging, "config.json")
  snapshot <- meta_snapshot()
  json_config <- list(cran_version = snapshot$dependency_freeze)
  jsonlite::write_json(
    json_config,
    file_config,
    pretty = TRUE,
    auto_unbox = TRUE
  )
}
