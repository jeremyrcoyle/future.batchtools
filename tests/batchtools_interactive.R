source("incl/start.R")
library("listenv")

message("*** batchtools_interactive() ...")

message("*** batchtools_interactive() without globals")

f <- batchtools_interactive({
  42L
})
stopifnot(inherits(f, "BatchtoolsFuture"))

## Check whether a batchtools_interactive future is resolved
## or not will force evaluation
print(resolved(f))
stopifnot(resolved(f))

y <- value(f)
print(y)
stopifnot(y == 42L)


message("*** batchtools_interactive() with globals")
## A global variable
a <- 0
f <- batchtools_interactive({
  b <- 3
  c <- 2
  a * b * c
})
print(f)

## Although 'f' is a batchtools_interactive future and therefore
## resolved/evaluates the future expression only
## when the value is requested, any global variables
## identified in the expression (here 'a') are
## "frozen" at the time point when the future is
## created.  Because of this, 'a' preserved the
## zero value although we reassign it below
a <- 7  ## Make sure globals are frozen
v <- value(f)
print(v)
stopifnot(v == 0)


message("*** batchtools_interactive() with globals (tricky)")
x <- listenv()
for (ii in 1:5) x[[ii]] <- batchtools_interactive({ ii }, globals = TRUE)
v <- sapply(x, FUN = value)
stopifnot(all(v == 1:5))  ## Make sure globals are frozen


message("*** batchtools_interactive() and errors")
f <- batchtools_interactive({
  stop("Whoops!")
  1
})
print(f)
v <- value(f, signal = FALSE)
print(v)
stopifnot(inherits(v, "simpleError"))

res <- try({ v <- value(f) }, silent = TRUE)
print(res)
stopifnot(inherits(res, "try-error"))

## Error is repeated
res <- try(value(f), silent = TRUE)
print(res)
stopifnot(inherits(res, "try-error"))

message("*** batchtools_interactive() ... DONE")

source("incl/end.R")
