#' @title Snapshot metadata
#' @export
#' @family meta
#' @description Show the metadata for the current targeted Production
#'   snapshot.
#' @return A data frame with one row and columns with metadata about
#'   the targeted snapshot.
#' @param today An object that [as.Date()] can convert to class `"Date"`.
#' @examples
#'   meta_snapshot(today = Sys.Date())
meta_snapshot <- function(today = Sys.Date()) {
  today <- as.Date(today)
  dependency_freeze <- date_quarter(today)
  candidate_freeze <- month_later(date = dependency_freeze)
  snapshot <- month_later(date = candidate_freeze)
  data.frame(
    dependency_freeze = dependency_freeze,
    candidate_freeze = candidate_freeze,
    snapshot = snapshot,
    r = meta_snapshot_r(date = dependency_freeze),
    cran = file.path(
      "https://packagemanager.posit.co",
      "cran",
      dependency_freeze
    ),
    r_multiverse = file.path(
      "https://production.r-multiverse.org",
      snapshot
    )
  )
}

meta_snapshot_r <- function(date) {
  versions <- r_version_list()
  versions <- versions[versions$date <= as.POSIXct(date), ]
  utils::tail(versions, n = 1L)$r
}

month_later <- function(date) {
  later <- as.Date(date) + as.difftime(30, units = "days")
  year <- format(later, "%Y")
  month <- format(later, "%m")
  paste(year, month, "15", sep = "-")
}

date_quarter <- function(today = Sys.Date()) {
  today <- as.Date(today)
  year <- as.integer(format(today, "%Y"))
  years <- as.character(rep(c(year - 1L, year, year + 1L), each = 4L))
  months <- rep(c("01-15", "04-15", "07-15", "10-15"), times = 2L)
  dates <- as.Date(paste(years, months, sep = "-"))
  as.character(max(dates[dates <= today]))
}
