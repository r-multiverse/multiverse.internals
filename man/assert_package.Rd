% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/assert_package.R
\name{assert_package}
\alias{assert_package}
\title{Validate a Package Entry}
\usage{
assert_package(name, url)
}
\arguments{
\item{name}{Character of length 1, package name.}

\item{url}{Usually a character of length 1 with the package URL.}
}
\value{
A character string if there is a problem with the package entry,
otherwise \code{NULL} if there are no issues.
}
\description{
Validate a package entry.
}
\keyword{internal}
