#' @title List metadata about R-universe package checks
#' @export
#' @family meta
#' @description List package checks results reported by the
#'   R-universe package API.
#' @return A data frame with one row per package and columns with
#'   package check details.
#' @param repo Character of length 1, URL of the package repository.
#'   R-multiverse uses `"https://community.r-multiverse.org"`.
#' @examples
#' meta_checks(repo = "https://wlandau.r-universe.dev")
meta_checks <- function(repo = "https://community.r-multiverse.org") {
  base <- file.path(trim_url(repo), "api", "packages?stream=true&fields=")
  json <- jsonlite::stream_in(
    con = gzcon(url(paste0(base, "_buildurl,_binaries,_failure"))),
    verbose = FALSE,
    simplifyVector = TRUE,
    simplifyDataFrame = TRUE,
    simplifyMatrix = TRUE
  )
  meta_checks_process_json(json)
}

meta_checks_process_json <- function(json) {
  json$url <- json[["_failure"]]$buildurl %||% rep(NA_character_, nrow(json))
  success_source <- is.na(json$url)
  json$url[success_source] <- json[["_buildurl"]][success_source]
  json$issues <- lapply(json[["_binaries"]], meta_checks_issues_binaries)
  for (index in which(!success_source)) {
    json$issues[[index]]$source <- "FAILURE"
  }
  colnames(json) <- tolower(colnames(json))
  rownames(json) <- json$package
  json[, c("package", "url", "issues")]
}

meta_checks_issues_binaries <- function(binaries) {
  check <- .subset2(binaries, "check")
  os <- .subset2(binaries, "os")
  arch <- .subset2(binaries, "arch")
  r <- .subset2(binaries, "r")
  devel <- is_r_devel(r)
  release <- is_r_release(r)
  results <- c(
    target_check("linux", "R-devel", os, arch, r, devel, check),
    target_check("mac", "R-release", os, arch, r, release, check),
    target_check("win", "R-release", os, arch, r, release, check)
  )
  as.list(results)
}

target_check <- function(
  target_os,
  target_r,
  os,
  arch,
  r,
  is_target_r,
  check
) {
  is_target <- (target_os == os) & is_target_r
  if (!any(is_target) || all(is.na(check[is_target]))) {
    out <- "MISSING"
    names(out) <- paste0(target_os, " ", target_r)
    return(out)
  }
  is_failure <- is_target & check %in% c("WARNING", "ERROR")
  if (!any(is_failure)) {
    return()
  }
  check <- check[is_failure]
  os <- os[is_failure]
  r <- paste0("R-", r[is_failure])
  if (!is.null(arch)) {
    arch <- arch[is_failure]
    os <- paste(os, arch, sep = " ")
  }
  names(check) <- paste(os, r, sep = " ")
  check
}

is_r_release <- function(r) {
  if (is.null(r_versions_envir$release)) {
    r_versions_envir$release <- rversions::r_release(dots = TRUE)$version
  }
  r == r_versions_envir$release
}

is_r_devel <- function(r) {
  if (is.null(r_versions_envir$all)) {
    history <- rversions::r_versions(dots = TRUE)
    cutoff <- as.POSIXct(Sys.Date() - as.difftime(104, units = "weeks"))
    r_versions_envir$all <- history$version[history$date > cutoff]
  }
  !(r %in% r_versions_envir$all)
}

r_versions_envir <- new.env(parent = emptyenv())
