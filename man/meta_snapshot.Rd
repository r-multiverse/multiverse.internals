% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/meta_snapshot.R
\name{meta_snapshot}
\alias{meta_snapshot}
\title{Snapshot metadata}
\usage{
meta_snapshot(today = Sys.Date())
}
\arguments{
\item{today}{An object that \code{\link[=as.Date]{as.Date()}} can convert to class \code{"Date"}.}
}
\value{
A data frame with one row and columns with metadata about
the targeted snapshot.
}
\description{
Show the metadata for the current targeted Production
snapshot.
}
\examples{
  meta_snapshot(today = Sys.Date())
}
\seealso{
Other meta: 
\code{\link{meta_packages}()}
}
\concept{meta}
