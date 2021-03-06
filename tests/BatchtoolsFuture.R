source("incl/start.R")

message("*** BatchtoolsFuture() ...")

message("*** BatchtoolsFuture() - cleanup ...")

f <- batchtools_local({ 1L })
print(f)
res <- await(f, cleanup = TRUE)
print(res)
stopifnot(res == 1L)

message("*** BatchtoolsFuture() - cleanup ... DONE")


message("*** BatchtoolsFuture() - deleting exceptions ...")

## Deleting a non-resolved future
f <- BatchtoolsFuture({ x <- 1 })
print(f)
res <- tryCatch({
  delete(f)
}, warning = function(w) w)
print(res)
stopifnot(inherits(res, "warning"))

## Printing a deleted future
f <- batchtools_local(42L)
print(f)
v <- value(f)
print(v)
stopifnot(v == 42L)
res <- delete(f)
print(f)
res <- delete(f)
print(f)

message("*** BatchtoolsFuture() - deleting exceptions ... DONE")


message("*** BatchtoolsFuture() - registry exceptions ...")

## Non-existing batchtools registry
f <- BatchtoolsFuture({ x <- 1 })
print(f)

## Hack to emulate where batchtools registry is deleted or fails
f$state <- "running"
path <- f$config$reg$file.dir
unlink(path, recursive = TRUE)

res <- value(f, onMissing = "default")
print(res)
stopifnot(is.null(res))

res <- tryCatch({
  value(f, onMissing = "error")
}, error = function(ex) ex)
print(res)
stopifnot(inherits(res, "error"))

res <- tryCatch({
  await(f)
}, error = function(ex) ex)
print(res)
stopifnot(inherits(res, "error"))


message("*** BatchtoolsFuture() - registry exceptions ... DONE")

message("*** BatchtoolsFuture() - exceptions ...")

f <- BatchtoolsFuture({ 42L })
print(f)
res <- tryCatch({
  loggedError(f)
}, error = function(ex) ex)
print(res)
stopifnot(inherits(res, "error"))

f <- BatchtoolsFuture({ 42L })
print(f)
res <- tryCatch({
  loggedOutput(f)
}, error = function(ex) ex)
print(res)
stopifnot(inherits(res, "error"))

res <- try(f <- BatchtoolsFuture(42L, workers = integer(0)), silent = TRUE)
print(res)
stopifnot(inherits(res, "try-error"))

res <- try(f <- BatchtoolsFuture(42L, workers = 0L), silent = TRUE)
print(res)
stopifnot(inherits(res, "try-error"))

res <- try(f <- BatchtoolsFuture(42L, workers = TRUE), silent = TRUE)
print(res)
stopifnot(inherits(res, "try-error"))

message("*** BatchtoolsFuture() - exceptions ... DONE")


message("*** BatchtoolsFuture() - timeout ...")

if (fullTest && availableCores(constraints = "multicore") > 1) {
  plan(batchtools_multicore)

  options(future.wait.timeout = 0.15, future.wait.interval = 0.1)

  f <- future({
    Sys.sleep(5)
    x <- 1
  })
  print(f)

  res <- tryCatch({
    value(f)
  }, error = function(ex) ex)
  stopifnot(inherits(res, "error"))
}


message("*** BatchtoolsFuture() - timeout ... DONE")



message("*** BatchtoolsFuture() ... DONE")

source("incl/end.R")
