% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/list_organizations.R
\name{list_organizations}
\alias{list_organizations}
\title{List trusted GitHub organizations.}
\usage{
list_organizations(owner = "r-multiverse", repo = "contributions")
}
\arguments{
\item{owner}{Character string, name of the R-multiverse GitHub
organization.}

\item{repo}{Character string, name of the R-multiverse contribution
GitHub repository.}
}
\value{
A character vector of the names of trusted GitHub organizations.
}
\description{
List trusted GitHub organizations for the purposes
of automated contribution reviews.
}
\details{
The R-multiverse contribution review bot flags contributions
for manual review whose pull request authors are not public members of
one of the trusted GitHub organizations.
}
\keyword{internal}
