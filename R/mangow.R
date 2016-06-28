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
#' iris_sub <- iris[c(1:2,50:51,100:101), ]
#' row.names(iris_sub) <- NULL
#' iris_sub
#' cluster::daisy(iris_sub, "gower")
#' mangow_iris_sub <- mangow(iris_sub)
#' cluster::daisy(mangow_iris_sub, "manhattan")
#' @export
mangow <- function(data) {
  columns <- mapply(
    data,
    names(data),
    FUN = mangow_one,
    SIMPLIFY = FALSE)

  m <- Reduce(cbind, columns) / length(data)
  if (any(rownames(data) != seq_len(nrow(m)))) {
    rownames(m) <- rownames(data)
  }
  m
}

mangow_one <- function(x, name) UseMethod("mangow_one", x)

#' @export
mangow_one.default <- function(x, name) {
  stop("Can't manhattanize ", class(x), " (column ", name, ").")
}

mangow_empty <- function(x) {
  matrix(nrow = length(x), ncol = 0)
}

#' @export
mangow_one.numeric <- function(x, name) {
  rng <- range(x)
  if (any(is.infinite(rng))) {
    stop("Gower distance only allows finite values")
  }

  if (diff(rng) != 0) {
    matrix((x - rng[[1L]]) / diff(rng), ncol = 1L, dimnames = list(NULL, name))
  } else {
    mangow_empty(x)
  }
}

#' @importFrom stats model.matrix
#' @export
mangow_one.factor <- function(x, name) {
  if (length(levels(x)) > 1) {
    data <- data.frame(x=x)
    `rownames<-`(model.matrix(~.-1, data) %*% compression_matrix(x, name) / 2, NULL)
  } else {
    mangow_empty(x)
  }
}

#' @export
mangow_one.ordered <- function(x, name) {
  if (length(levels(x)) > 1) {
    matrix((as.integer(x) - 1L) / (nlevels(x) - 1L), ncol = 1L, dimnames = list(NULL, name))
  } else {
    mangow_empty(x)
  }
}
