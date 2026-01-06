#' @title Review a package.
#' @export
#' @family Manual package reviews
#' @description Review a package for registration in R-multiverse.
#' @details [review_package()] runs all the checks from
#'   <https://r-multiverse.org/review.html#automatic-acceptance>
#'   that can be done using the package name and source code repository URL.
#' @return Invisibly returns `TRUE`
#'   if there is a problem with the package entry,
#'   otherwise `FALSE` if there are no issues.
#'   In either case, [review_package()] prints an R console message with
#'   the result.
#'
#'   For security reasons, [review_package()] might only print the first
#'   finding it encounters. If that happens, there will be an informative
#'   note at the end of the console message, and compliance with
#'   R-multiverse policies will need to be checked manually.
#'   In particular, please use [review_license()] to
#'   check the `"License:"` field in the package `DESCRIPTION` file.
#' @param name Character string, name of the package to check.
#' @param url Either a character string with the package URL or
#'   a custom JSON string with a package entry.
#' @param advisories Character vector of names of packages with advisories
#'   in the R Consortium Advisory Database.
#'   If `NULL`, then `review_package_text()` downloads the advisory database and
#'   checks if the package has a vulnerability listed there.
#'   The advisory database is cached internally for performance.
#' @examples
#'   review_package(
#'     name = "webchem",
#'     url = "https://github.com/ropensci/webchem"
#'   )
#'   review_package(
#'     name = "polars",
#'     url = "https://github.com/pola-rs/r-polars"
#'   )
review_package <- function(name, url, advisories = NULL) {
  result <- review_package_text(name, url, advisories)
  if (is.null(result)) {
    cli::cli_alert_success(
      "package {.pkg {name}} passed cursory checks for policy compliance."
    )
    return(invisible(TRUE))
  } else {
    cli::cli_alert_danger(
      paste0(
        "package {.pkg {name}} did not pass ",
        "cursory checks for policy compliance. ",
        "Findings:\n\n",
        result
      )
    )
    return(invisible(FALSE))
  }
}


review_package_text <- function(name, url, advisories = NULL) {
  skipped <- paste(
    "WARNING: for security and/or practical reasons",
    "some pre-registration checks were skipped.",
    "Please manually check the package for",
    "compliance with R-multiverse policies.",
    "In particular, please check the license with",
    "multiverse.internals::review_license()."
  )
  skip <- function(message) {
    paste(message, skipped, sep = "\n\n")
  }
  if (is.null(advisories)) {
    advisories <- unique(read_advisories()$package)
  }
  if (any(grepl(pattern = "\\}|\\{", x = url))) {
    return(
      paste(
        "Listing of package",
        shQuote(name),
        "looks like JSON, which needs to be manually reviewed.",
        "Manually supply the package name and URL to",
        "`multiverse.internals::review_package_text()`",
        "to run the rest of the checks."
      )
    )
  }
  if (!is.null(out <- assert_package_listing(name = name, url = url))) {
    return(skip(out))
  }
  if (!is.null(out <- assert_no_advisories(name, advisories = advisories))) {
    return(skip(out))
  }
  name <- trimws(name)
  url <- trimws(trim_trailing_slash(url))
  if (!is.null(out <- assert_package_security_lints(name, url))) {
    return(skip(out))
  }
  if (!is.null(out <- assert_url_exists(url = url))) {
    return(skip(out))
  }
  findings <- NULL
  if (!is.null(out <- assert_package_lints(name = name, url = url))) {
    findings <- c(findings, out)
  }
  if (!is.null(out <- assert_cran_url(name = name, url = url))) {
    findings <- c(findings, out)
  }
  if (!is.null(out <- assert_release_exists(url = url))) {
    findings <- c(findings, out)
  }
  if (!is.null(out <- assert_package_description(name = name, url = url))) {
    findings <- c(findings, out)
  }
  if (length(findings)) {
    findings <- paste(findings, collapse = "\n\n")
  }
  findings
}

assert_package_listing <- function(name, url) {
  if (!is_package_name(name)) {
    return("Invalid package name")
  }
  if (!is_character_scalar(url)) {
    return("Invalid package URL")
  }
  name <- trimws(name)
  url <- trimws(trim_trailing_slash(url))
  parsed_url <- try(url_parse(url), silent = TRUE)
  if (inherits(parsed_url, "try-error")) {
    return(
      paste("Found malformed URL", shQuote(url), "of package", shQuote(name))
    )
  }
  if (!identical(parsed_url[["scheme"]], "https")) {
    return(paste("Scheme of URL", shQuote(url), "is not https"))
  }
}

assert_no_advisories <- function(name, advisories) {
  if (name %in% advisories) {
    return(
      paste(
        "Package",
        shQuote(name),
        "has one or more advisories in the R Consortium Advisory Database",
        "at https://github.com/RConsortium/r-advisory-database"
      )
    )
  }
}

assert_package_security_lints <- function(name, url) {
  parsed_url <- try(url_parse(url), silent = TRUE)
  findings <- NULL
  domains <- c("github.com", "gitlab.com", "codeberg.org")
  if (!(parsed_url[["hostname"]] %in% domains)) {
    finding <- paste(
      "URL",
      shQuote(url),
      "is not a repository in GitHub, GitLab, or Codeberg."
    )
    findings <- c(findings, finding)
  }
  splits <- strsplit(parsed_url[["path"]], split = "/", fixed = TRUE)[[1L]]
  splits <- splits[nzchar(splits)]
  if (length(splits) < 2L) {
    finding <- paste(
      "URL",
      shQuote(url),
      "appears to be an owner, not a repository"
    )
    findings <- c(findings, finding)
  }
  findings
}

assert_package_lints <- function(name, url) {
  parsed_url <- try(url_parse(url), silent = TRUE)
  findings <- NULL
  if (!identical(name, basename(parsed_url[["path"]]))) {
    finding <- paste(
      "Package name",
      shQuote(name),
      "is different from the repository name in the URL",
      shQuote(url)
    )
    findings <- c(findings, finding)
  }
  splits <- strsplit(parsed_url[["path"]], split = "/", fixed = TRUE)[[1L]]
  splits <- splits[nzchar(splits)]
  owner <- tolower(splits[nzchar(splits)][1L])
  if (identical(owner, "cran")) {
    finding <- paste("URL", shQuote(url), "appears to use a CRAN mirror")
    findings <- c(findings, finding)
  }
  findings
}

assert_url_exists <- function(url) {
  status <- nanonext::ncurl(url, convert = FALSE)[["status"]]
  if (status != 200L) {
    return(
      paste(
        "URL",
        shQuote(url),
        "returned HTTP error",
        nanonext::status_code(status)
      )
    )
  }
}

is_package_name <- function(name) {
  is_character_scalar(name) &&
    grepl(
      pattern = "^[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9]$",
      x = trimws(name)
    )
}
