#' @title Report `DESCRIPTION`-level issues.
#' @export
#' @family issues
#' @description Report issues with `DESCRIPTION`-level metadata of packages.
#' @details [issues_descriptions()] reports specific issues in the
#'   `DESCRIPTION`-level metadata of packages:
#'   1. Security advisories at
#'     <https://github.com/RConsortium/r-advisory-database>.
#'   2. Licenses that cannot be verified as free and open-source.
#'   3. The presence of a `"Remotes"` field.
#'   4. A lower version number on R-multiverse than on CRAN,
#'     if the package is also published on the latter.
#' @inheritSection record_issues Package issues
#' @return A named list of information about packages which do not comply
#'   with `DESCRPTION` checks. Each name is a package name,
#'   and each element contains specific information about
#'   non-compliance.
#' @param meta A data frame with R-universe package check results
#'   returned by [meta_checks()].
#' @examples
#'   meta <- meta_packages(repo = "https://wlandau.r-universe.dev")
#'   issues <- issues_descriptions(meta = meta)
#'   str(issues)
issues_descriptions <- function(meta = meta_packages()) {
  meta$issue <- FALSE
  meta <- issues_descriptions_advisories(meta)
  meta <- issues_descriptions_licenses(meta)
  meta <- issues_descriptions_remotes(meta)
  meta <- issues_descriptions_version_conflict(meta, repo = "cran")
  meta <- meta[meta$issue,, drop = FALSE] # nolint
  fields <- c(
    "package",
    "advisories",
    "license",
    "remotes",
    "cran"
  )
  issues_list(meta[, fields])
}

issues_descriptions_advisories <- function(meta) {
  advisories <- read_advisories(timeout = 600000, retries = 3L)
  meta <- merge(
    x = meta,
    y = advisories,
    by = c("package", "version"),
    all.x = TRUE,
    all.y = FALSE
  )
  meta$issue <- meta$issue | !vapply(meta$advisories, anyNA, logical(1L))
  meta
}

issues_descriptions_licenses <- function(meta) {
  meta$license[meta$foss] <- NA_character_
  meta$issue <- meta$issue | !meta$foss
  meta
}

issues_descriptions_remotes <- function(meta) {
  meta[["remotes"]] <- meta[["remotes"]] %||% replicate(nrow(meta), NULL)
  meta$remotes <- lapply(meta$remotes, function(x) x[nzchar(x)])
  meta$issue <- meta$issue | vapply(meta$remotes, length, integer(1L)) > 0L
  meta
}

issues_descriptions_version_conflict <- function(meta, repo) {
  conflict <- vapply(
    X = seq_len(nrow(meta)),
    FUN = function(index) {
      utils::compareVersion(
        a = meta$version[index],
        b = meta[[repo]][index]
      ) < 0L
    },
    FUN.VALUE = logical(1L)
  )
  meta[[repo]][!conflict] <- NA_character_
  meta$issue <- meta$issue | conflict
  meta
}
