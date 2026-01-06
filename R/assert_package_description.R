#' @title Assert package `DESCRIPTION`
#' @keywords internal
#' @description Run basic assertions on the `DESCRIPTION` file of a potential
#'   package contribution.
#' @return A character string with an informative message if a problem
#'   was found. Otherwise, `NULL` if there are no issues.
#' @param name Character string, name of the package listing contribution
#'   to R-multiverse.
#' @param url Character string, URL of the package on a supported
#'   source code repository.
assert_package_description <- function(name, url) {
  text <- try(get_repo_file(url, "DESCRIPTION"), silent = TRUE)
  if (inherits(text, "try-error")) {
    return(
      paste(
        "Could not read a DESCRIPTION file at the top-level of",
        url,
        sprintf("(error: %s)", conditionMessage(attr(text, "condition")))
      )
    )
  }
  if (!is.null(out <- assert_description_local(name, text))) {
    return(out)
  }
  license <- desc::description$new(text = text)$get("License")
  if (any(grepl("LICENSE", license))) {
    path <- "LICENSE"
  } else if (any(grepl("LICENCE", license))) {
    path <- "LICENCE"
  } else {
    return()
  }
  text <- try(get_repo_file(url, path), silent = TRUE)
  if (inherits(text, "try-error")) {
    return(
      paste(
        "Could not download license file",
        path,
        "of package",
        name,
        sprintf("(error: %s)", conditionMessage(attr(text, "condition")))
      )
    )
  }
  if (!is.null(out <- assert_license_local(name, path, text))) {
    return(out)
  }
}

assert_description_local <- function(name, text) {
  description <- try(
    desc::description$new(text = text),
    silent = TRUE
  )
  if (inherits(description, "try-error")) {
    return(
      paste(
        "DESCRPTION file could not be parsed. Original error:",
        conditionMessage(attr(description, "condition"))
      )
    )
  }
  assert_parsed_description(name, description)
}

assert_parsed_description <- function(name, description) {
  if (!identical(name, as.character(description$get("Package")))) {
    return(
      paste(
        "R-multiverse listing name",
        shQuote(name),
        "is different from the package name in the DESCRIPTION FILE:",
        shQuote(description$get("Package"))
      )
    )
  }
  authors <- c(
    description$get("Authors@R"),
    description$get("Author"),
    description$get("Maintainer")
  )
  if (!length(authors) || all(is.na(authors))) {
    return(
      paste(
        "DESCRIPTION of package",
        name,
        "does not list an author or maintainer.",
        "Each package contributed to R-multiverse must correctly attribute",
        "authorship and ownership to protect the intellectual property",
        "rights of the package owners."
      )
    )
  }
  authors_r <- try(
    suppressWarnings(eval(parse(text = description$get("Authors@R")))),
    silent = TRUE
  )
  if (inherits(authors_r, "try-error")) {
    return("Could not parse the Authors@R field of the package DESCRIPTION.")
  }
  if (any(grepl("first[ \t]*last", tolower(authors_r)))) {
    return(
      paste(
        "'First Last' is not a serious author name.",
        "Packages must correctly attribute ownership and authorship in",
        "the DESCRIPTION and license."
      )
    )
  }
  license <- description$get("License")
  if (!all(license_okay(license))) {
    return(
      paste(
        "Detected license",
        shQuote(license),
        "which requires review by a moderator.",
        "Each package contributed to R-multiverse must have a valid",
        "open-source license to protect the intellectual property",
        "rights of the package owners."
      )
    )
  }
}

assert_license_local <- function(name, path, text) {
  lines <- unlist(strsplit(text, split = "\n"))
  keys <- trimws(gsub(":.*$", "", lines))
  acceptable <- c("COPYRIGHT HOLDER", "ORGANISATION", "ORGANIZATION", "YEAR")
  if (!all(keys %in% acceptable)) {
    return(
      paste(
        "Package",
        name,
        "license file",
        path,
        "contains text more complicated than the usual",
        "'YEAR', 'COPYRIGHT HOLDER', and 'ORGANIZATION' key-value pairs."
      )
    )
  }
  values <- trimws(gsub("^.*:", "", lines))
  if (!all(nzchar(values))) {
    return(
      paste(
        "Package",
        name,
        "license file",
        path,
        "contains colon-separated key-value pairs with empty values."
      )
    )
  }
}
