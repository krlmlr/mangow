#' Convert a Gower distance problem to a Manhattan distance problem
#'
#' This function converts a data frame to a matrix with the same number of rows.
#' For any two rows of the resulting matrix, the Manhattan distance
#' equals the Gower distance in the input data between the corresponding rows.
#'
#' @param data The input data frame
#'   with continuous, categorical (factor) and ordered variables
#' @return A numeric matrix
#'
#' @examples
#' mangow(iris[1:10, ])
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

  as.matrix(x / diff(rng) - rng[[1L]], ncol = 1L)
}

#' @export
mangow_one.factor <- function(x) {
  model.matrix(~.-1, data.frame(x=x)) / 2
}

#' @export
mangow_one.ordered <- function(x) {
  as.matrix((as.integer(x) - 1L) / (nlevels(x) - 1L), ncol = 1L)
}
