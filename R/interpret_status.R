#' @title Interpret the status of a package
#' @export
#' @family status
#' @description Summarize the status of a package in human-readable text.
#' @return A character string summarizing the status of a package in prose.
#' @param package Character string, name of the package.
#' @param status A list with one status entry per package. Obtained by
#'   reading the results of [record_status()].
interpret_status <- function(package, status) {
  status <- status[[package]]
  if (is.null(status)) {
    return(interpret_null(package))
  }
  if (isTRUE(status$success)) {
    return(interpret_success(status, package))
  }
  out <- paste(
    c(
      interpret_title(status, package),
      interpret_advisories(status),
      interpret_licenses(status, package),
      interpret_r_cmd_check(status),
      interpret_dependencies(status, package),
      interpret_remotes(status),
      interpert_version_conflicts(status),
      interpret_versions(status),
      interpret_synchronization(status)
    ),
    collapse = ""
  )
  trimws(out)
}

interpret_null <- function(package) {
  paste0("Data not found on package ", package, ".")
}

interpret_success <- function(status, package) {
  out <- paste0(
    "R-multiverse checks passed for package ",
    package
  )
  if (is.character(status$version)) {
    out <- paste(out, "version", status$version)
  }
  if (is.character(status$remote_hash)) {
    out <- paste(out, "remote hash", status$remote_hash)
  }
  paste0(
    out,
    " (last published at ",
    status$published,
    ")."
  )
}

interpret_title <- function(status, package) {
  title <- paste0(
    "R-multiverse found issues with package ",
    package
  )
  if (is.character(status$version)) {
    title <- paste(title, "version", status$version)
  }
  if (is.character(status$remote_hash)) {
    title <- paste(title, "remote hash", status$remote_hash)
  }
  paste0(title, " (last published at ", status$published, ").<br><br>")
}

interpret_advisories <- function(status) {
  advisories <- status$advisories
  if (is.null(advisories)) {
    return(character(0L))
  }
  paste0(
    "Found the following advisories in the ",
    "<a href=\"https://github.com/RConsortium/r-advisory-database\">",
    "R Consortium Advisory Database:</a><br>",
    as.character(yaml_html(advisories))
  )
}

interpret_r_cmd_check <- function(status) {
  r_cmd_check <- status$r_cmd_check
  if (is.null(r_cmd_check)) {
    return(character(0L))
  }
  data <- data.frame(
    Platform = r_cmd_check$config,
    R = r_cmd_check$r,
    Result = sprintf(
      "<a href=\"%s\">%s</a>",
      r_cmd_check$url,
      r_cmd_check$check
    )
  )
  paste0(
    "Not all `R CMD check` runs succeeded on R-universe. ",
    "The following table links to the output log ",
    "of each `R CMD check` run.<br>",
    table_html(data),
    "<br>"
  )
}

interpret_dependencies <- function(status, package) {
  dependencies <- status$dependencies
  if (is.null(dependencies)) {
    return(character(0L))
  }
  direct <- names(dependencies)[lengths(dependencies) < 1L]
  indirect <- setdiff(names(dependencies), direct)
  text <- paste0(
    "One or more strong R package dependencies have issues: ",
    paste(names(dependencies), collapse = ", "),
    "."
  )
  if (length(direct)) {
    text <- paste0(
      text,
      ifelse(length(direct) == 1L, " Dependency ", " Dependencies "),
      paste(direct, collapse = ", "),
      ifelse(length(direct) == 1L, " is ", " are "),
      "explicitly mentioned in 'Depends:', 'Imports:', or 'LinkingTo:' ",
      "in the DESCRIPTION file of ",
      package,
      "."
    )
  }
  if (length(indirect)) {
    text <- paste0(
      text,
      ifelse(length(indirect) == 1L, " Dependency ", " Dependencies "),
      paste(indirect, collapse = ", "),
      ifelse(length(indirect) == 1L, " is ", " are "),
      "not part of 'Depends:', 'Imports:', or 'LinkingTo:' ",
      "in the DESCRIPTION file of ",
      package,
      ", but ",
      ifelse(length(indirect) == 1L, "it is", "they are"),
      " upstream of one or more strong direct dependencies:<br>",
      as.character(yaml_html(dependencies[indirect]))
    )
  } else {
    text <- paste0(text, "<br><br>")
  }
  text
}

interpret_licenses <- function(status, package) {
  license <- status$license
  if (is.null(license)) {
    return(character(0L))
  }
  paste(
    "Package",
    package,
    "declares license",
    shQuote(license),
    "in its DESCRIPTION file. R-multiverse cannot verify that",
    "this license is a",
    paste0(
      "<a href=\"https://en.wikipedia.org/wiki/",
      "Free_and_open-source_software\">",
      "valid free and open-source license</a>."
    ),
    "Each package contributed to R-multiverse must have a valid",
    "open-source license to protect the intellectual property",
    "rights of the package owners.<br><br>"
  )
}

interpret_remotes <- function(status) {
  remotes <- status$remotes
  if (is.null(remotes)) {
    return(character(0L))
  }
  paste0(
    "Package releases should not use the 'Remotes:' field. Found:<br>",
    as.character(yaml_html(remotes))
  )
}

interpret_versions <- function(status) {
  versions <- status$versions
  if (is.null(versions)) {
    return(character(0L))
  }
  paste0(
    "The version number of the current release ",
    "should be highest version of all the releases so far. ",
    "Here is the current version of the package, ",
    "the highest version number ever recorded by R-multiverse, ",
    "and the latest remote hash of each:<br>",
    as.character(yaml_html(versions))
  )
}

interpert_version_conflicts <- function(status) {
  out <- character(0L)
  if (!is.null(status$cran)) {
    out <- paste(
      out,
      "On CRAN, this package had version",
      status$cran,
      "during the first day of the most recent R-multiverse",
      "dependency freeze. The version on R-multiverse is lower,",
      "which causes install.packages() to prefer CRAN.",
      "If you have not already done so, please ensure the latest",
      "source code release of your package has a suitably recent version",
      "in the DESCRIPTION file.<br><br>"
    )
  }
  trimws(out)
}

interpret_synchronization <- function(status) {
  if (is.null(status$synchronization)) {
    return()
  } else if (status$synchronization == "recent") {
    paste(
      "This package updated so recently that",
      "checks on reverse dependencies may not have started yet.",
      "Please wait for the next",
      "<a href=\"https://github.com/r-multiverse/status/actions/workflows/update.yaml\">", # nolint
      "R-multiverse status refresh</a>.<br><br>"
    )
  } else {
    sprintf(
      paste(
        "An <a href=\"%s\"><code>R CMD check</code> job</a>",
        "is either running or about to run.",
        "Please wait for <a href=\"%s\">this check</a>",
        "to finish, then wait for the next",
        "<a href=\"https://github.com/r-multiverse/status/actions/workflows/update.yaml\">", # nolint
        "R-multiverse status refresh</a>.",
        "If the check is stuck in a pre-running state (such as \"queued\")",
        "for more than a day, then R-multiverse will ignore it.<br><br>"
      ),
      status$synchronization,
      status$synchronization
    )
  }
}

table_html <- function(x) {
  header <- paste(sprintf("<th>%s</th>", colnames(x)), collapse = "")
  for (name in names(x)) {
    x[[name]] <- sprintf("<th>%s</th>", x[[name]])
  }
  lines <- sprintf("<tr>%s</tr>", c(header, do.call(paste0, x)))
  sprintf(
    "<table class=\"checks-table\">%s</table>",
    paste(lines, collapse = "")
  )
}

yaml_html <- function(x) {
  out <- yaml::as.yaml(x, line.sep = "\n")
  out <- sprintf("<pre>%s</pre>", out)
}
