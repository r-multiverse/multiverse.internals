% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stage_candidates.R
\name{stage_candidates}
\alias{stage_candidates}
\title{Stage release candidates}
\usage{
stage_candidates(path_staging)
}
\arguments{
\item{path_staging}{Character string, directory path to the source
files of the Staging universe.}
}
\value{
\code{NULL} (invisibly)
}
\description{
Stage release candidates for the targeted Production snapshot.
}
\details{
\code{\link[=stage_candidates]{stage_candidates()}} implements the candidate freeze
during the month-long period prior to the Production snapshot.
Packages that pass R-multiverse checks are frozen
(not allowed to update further) and staged for Production.
Packages with at least one failing not staged for Production,
and maintainers can update them with new GitHub/GitLab releases.

\code{\link[=stage_candidates]{stage_candidates()}} writes \code{packages.json} to control
contents of the Staging universe.
}
\examples{
\dontrun{
url_staging <- "https://github.com/r-multiverse/staging"
path_staging <- tempfile()
gert::git_clone(url = url_staging, path = path_staging)
stage_candidates(path_staging = path_staging)
}
}
\seealso{
Other staging: 
\code{\link{filter_meta}()},
\code{\link{freeze_dependencies}()},
\code{\link{rclone_includes}()}
}
\concept{staging}
