#' @title List package metadata
#' @export
#' @family meta
#' @description List package metadata in an R universe.
#' @return A data frame with one row per package and columns with package
#'   metadata. The most important columns are:
#'   * `package`: character vector of package names.
#'   * `version`: character vector of package versions in the repo.
#'   * `license`: character vector of license names.
#'   * `remotesha`: character vector of GitHub/GitLab commit hashes.
#'   * `remotes`: list of character vectors with dependencies in the
#'     `Remotes:` field of the `DESCRIPTION` files.
#'   * `foss`: `TRUE` if the package has a valid free open-source license,
#'     `FALSE` otherwise.
#'   * `cran`: character vector of versions. Each version is the version of
#'     the package that was on CRAN during the first day of the most recent
#'     R-multiverse staging period.
#' @inheritParams meta_checks
#' @param fields Character string of fields to query.
#' @examples
#' meta_packages(repo = "https://wlandau.r-universe.dev")
meta_packages <- function(
  repo = "https://community.r-multiverse.org",
  fields = c("Version", "License", "Remotes", "RemoteSha")
) {
  repo <- trim_url(repo)
  listing <- file.path(
    utils::contrib.url(repos = repo, type = "source"),
    paste0("PACKAGES.json?fields=", paste(fields, collapse = ","))
  )
  out <- jsonlite::stream_in(
    con = gzcon(url(listing)),
    verbose = FALSE,
    simplifyVector = TRUE,
    simplifyDataFrame = TRUE,
    simplifyMatrix = TRUE
  )
  colnames(out) <- tolower(colnames(out))
  rownames(out) <- out$package
  foss <- utils::available.packages(repos = repo, filters = "license/FOSS")
  out$foss <- FALSE
  out[as.character(foss[, "Package"]), "foss"] <- TRUE
  cran <- utils::available.packages(repos = meta_snapshot()$cran)
  cran <- data.frame(
    package = as.character(cran[, "Package"]),
    cran = as.character(cran[, "Version"])
  )
  out <- merge(x = out, y = cran, all.x = TRUE, all.y = FALSE)
  out
}
