#' Convert a Gower distance problem to a Manhattan distance problem
#'
#' @param data The data
#'
#' @export
mangow <- function(data) {
  columns <- lapply(
    data,
    mangow_one)

  Reduce(cbind, columns)
}

mangow_one <- function(x) UseMethod("mangow_one", x)

mangow_one.default <- function(x) stop("Can't manhattanize ", class(x))
