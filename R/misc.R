halt <- function (...) stop(..., call.=FALSE)

# Check for "integers" but don't require true integer storage
is.whole <- function (x) is.numeric(x) && !is.na(x) && floor(x) == x
