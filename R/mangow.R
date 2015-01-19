#' Convert a Gower distance problem to a Manhattan distance problem
#'
#' @param data The data
#' @return A matrix where the Manhattan distance between all pairs of rows
#'   equals the Gower distance in the data between the corresponding pairs of rows
#'
#' @export
mangow <- function(data) {
  columns <- lapply(
    data,
    mangow_one)

  Reduce(cbind, columns) / length(data)
}

mangow_one <- function(x) UseMethod("mangow_one", x)

#' @export
mangow_one.default <- function(x) stop("Can't manhattanize ", class(x))

#' @export
mangow_one.numeric <- function(x) {
  rng <- range(x)
  if (any(is.infinite(rng)))
    stop("Gower distance only allows finite values")

  as.matrix(x / diff(rng) - rng[[1L]], ncol = 1)
}

mangow_one.factor <- function(x) {
  nlev <- nlevels(x)
  model.matrix(~.-1, data.frame(x=x)) / nlev
}
