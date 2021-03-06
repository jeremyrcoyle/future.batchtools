% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/batchtools_local.R
\name{batchtools_local}
\alias{batchtools_local}
\alias{batchtools_interactive}
\title{batchtools local and interactive futures}
\usage{
batchtools_local(expr, envir = parent.frame(), substitute = TRUE,
  globals = TRUE, label = "batchtools", workers = 1L, ...)
}
\arguments{
\item{expr}{The R expression to be evaluated}

\item{envir}{The environment in which global environment
should be located.}

\item{substitute}{Controls whether \code{expr} should be
\code{substitute()}:d or not.}

\item{globals}{(optional) a logical, a character vector, a named list, or
a \link[globals]{Globals} object.  If TRUE, globals are identified by code
inspection based on \code{expr} and \code{tweak} searching from environment
\code{envir}.  If FALSE, no globals are used.  If a character vector, then
globals are identified by lookup based their names \code{globals} searching
from environment \code{envir}.  If a named list or a Globals object, the
globals are used as is.}

\item{label}{(optional) Label of the future (where applicable, becomes the
job name for most job schedulers).}

\item{workers}{(optional) Additional specification for the batchtools
backend.}

\item{\ldots}{Additional arguments passed to
\code{\link{BatchtoolsFuture}()}.}
}
\value{
An object of class \code{BatchtoolsFuture}.
}
\description{
A batchtools local future is an synchronous uniprocess future that
will be evaluated in a background R session.
A batchtools interactive future is an synchronous uniprocess future
that will be evaluated in the current R session (and variables will
be assigned to the calling environment rather than to a local one).
Both types of futures will block until the futures are resolved.
}
\details{
batchtools local futures rely on the batchtools backend set up by
\code{\link[batchtools]{makeClusterFunctionsInteractive}(external = TRUE)}
and batchtools interactive futures on the one set up by
\code{\link[batchtools]{makeClusterFunctionsInteractive}()}.
These are supported by all operating systems.

An alternative to batchtools local futures is to use
\link[future:cluster]{cluster} futures of the \pkg{future}
package with a single local background session, i.e.
\code{plan(cluster, workers = "localhost")}.

An alternative to batchtools interactive futures is to use
\link[future:transparent]{transparent} futures of the
\pkg{future} package.
}
\examples{
## Use local batchtools futures
plan(batchtools_local)

## A global variable
a <- 1

## Create explicit future
f <- future({
  b <- 3
  c <- 2
  a * b * c
})
v <- value(f)
print(v)


## Create implicit future
v \%<-\% {
  b <- 3
  c <- 2
  a * b * c
}
print(v)
}
