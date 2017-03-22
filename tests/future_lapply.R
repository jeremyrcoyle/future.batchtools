source("incl/start.R")
library("listenv")

strategies <- c("sequential", "multisession",
                "batchtools_interactive", "batchtools_local")

message("*** future_lapply() ...")

message("- future_lapply(x, FUN=vector, ...) ...")

x <- list(a="integer", b="numeric", c="character", c="list")
str(list(x=x))

y0 <- lapply(x, FUN=vector, length=2L)
str(list(y0=y0))

for (scheduling in list(FALSE, TRUE)) {
  for (strategy in strategies) {
    message(sprintf("- plan('%s') ...", strategy))
    plan(strategy)
    y <- future_lapply(x, FUN=vector, length=2L, future.scheduling = scheduling)
    str(list(y=y))
    stopifnot(identical(y, y0))
  }
}


message("- future_lapply(x, FUN=base::vector, ...) ...")

x <- list(a="integer", b="numeric", c="character", c="list")
str(list(x=x))

y0 <- lapply(x, FUN=base::vector, length=2L)
str(list(y0=y0))

for (scheduling in list(FALSE, TRUE)) {
  for (strategy in strategies) {
    message(sprintf("- plan('%s') ...", strategy))
    plan(strategy)
    y <- future_lapply(x, FUN=base::vector, length=2L, future.scheduling = scheduling)
    str(list(y=y))
    stopifnot(identical(y, y0))
  }
}

message("- future_lapply(x, FUN=future:::hpaste, ...) ...")

x <- list(a=c("hello", b=1:100))
str(list(x=x))

y0 <- lapply(x, FUN=future:::hpaste, collapse="; ", maxHead=3L)
str(list(y0=y0))

for (scheduling in list(FALSE, TRUE)) {
  for (strategy in strategies) {
    message(sprintf("- plan('%s') ...", strategy))
    plan(strategy)
    y <- future_lapply(x, FUN=future:::hpaste, collapse="; ", maxHead=3L, future.scheduling = scheduling)
    str(list(y=y))
    stopifnot(identical(y, y0))
  }
}


message("- future_lapply(x, FUN=listenv::listenv, ...) ...")

x <- list()

y <- listenv()
y$A <- 3L
x$a <- y

y <- listenv()
y$A <- 3L
y$B <- c("hello", b=1:100)
x$b <- y

print(x)

y0 <- lapply(x, FUN=listenv::map)
str(list(y0=y0))

for (scheduling in list(FALSE, TRUE)) {
  for (strategy in strategies) {
    message(sprintf("- plan('%s') ...", strategy))
    plan(strategy)
    y <- future_lapply(x, FUN=listenv::map, future.scheduling = scheduling)
    str(list(y=y))
    stopifnot(identical(y, y0))
  }
}


message("- future_lapply(x, FUN, ...) for large length(x) ...")
a <- 3.14
x <- 1:1e6

y <- future_lapply(x, FUN = function(z) sqrt(z + a))
y <- unlist(y, use.names = FALSE)

stopifnot(all.equal(y, sqrt(x + a)))

message("*** future_lapply() ... DONE")

source("incl/end.R")