% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/record_versions.R
\name{record_versions}
\alias{record_versions}
\title{Record the manifest of package versions.}
\usage{
record_versions(
  versions = "versions.json",
  repo = "https://community.r-multiverse.org",
  current = multiverse.internals::get_current_versions(repo = repo)
)
}
\arguments{
\item{versions}{Character of length 1, file path to a JSON manifest
tracking the history of released versions of packages.}

\item{repo}{URL of the repository to query.}

\item{current}{A data frame of current versions and hashes of packages
in \code{repo}. This argument is exposed for testing only.}
}
\value{
\code{NULL} (invisibly). Writes version information to a JSON file.
}
\description{
Record the manifest of versions of packages
and their hashes.
}
\details{
This function tracks a manifest containing the current version,
the current hash, the highest version ever released, and
the hash of the highest version ever released.
\code{\link[=issues_versions]{issues_versions()}} uses this information
to determine whether the package complies with best
practices for version numbers.
}
\section{Package status}{

Functions like \code{\link[=issues_versions]{issues_versions()}} and \code{\link[=issues_r_cmd_check]{issues_r_cmd_check()}}
perform health checks for all packages in R-multiverse.
For a complete list of checks, see
the \verb{issues_*()} functions listed at
\url{https://r-multiverse.org/multiverse.internals/reference/index.html}.
\code{\link[=record_versions]{record_versions()}} updates the version number history
of releases in R-multiverse, and \code{\link[=record_status]{record_status()}} gathers
together all the status about R-multiverse packages.
}

\examples{
\dontrun{
output <- tempfile()
versions <- tempfile()
# First snapshot:
record_versions(
  versions = versions,
  repo = repo
)
readLines(versions)
# In subsequent snapshots, we have historical information about versions.
record_versions(
  versions = versions,
  repo = repo
)
readLines(versions)
}
}
\concept{package check data management}
