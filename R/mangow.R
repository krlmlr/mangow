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

  Reduce(cbind, columns) / length(data)
}

mangow_one <- function(x, name) UseMethod("mangow_one", x)

#' @export
mangow_one.default <- function(x, name) {
  stop("Can't manhattanize ", class(x))
}

#' @export
mangow_one.numeric <- function(x, name) {
  rng <- range(x)
  if (any(is.infinite(rng))) {
    stop("Gower distance only allows finite values")
  }

  matrix((x - rng[[1L]]) / diff(rng), ncol = 1L, dimnames = list(NULL, name))
}

compression_matrix_data <- function(x) {
  lev <- levels(x)
  n_lev <- length(lev)
  n_full <- (n_lev - 1L) %/% 2L
  n_rem <- n_lev - 2L * n_full
  pm1 <- c(1, -1)
  full <- c(pm1, rep(0, length(lev)))

  c(rep(full, n_full), pm1[seq_len(n_full)])
}

compression_matrix_colnames <- function(x, name) {
  lev <- levels(x)
  n_lev <- length(lev)

  even_idx <- seq.int(2L, n_lev, by = 2L)
  odd_idx <- seq.int(1L, n_lev, by = 2L)
  length(odd_idx) <- length(even_idx)

  col_names <- paste(lev[odd_idx], lev[even_idx], sep = ".")
  if (length(col_names) * 2L < n_lev) {
    col_names <- c(col_names, lev[n_lev])
  }
  paste(name, col_names, sep = ".")
}

# Creates a matrix that compresses a model matrix to the +1/-1 form
# required here
compression_matrix <- function(x, name) {
  col_names <- compression_matrix_colnames(x, name)
  matrix(
    compression_matrix_data(x),
    ncol = length(col_names),
    dimnames = list(NULL, col_names)
  )
}

#' @export
mangow_one.factor <- function(x, name) {
  data <- data.frame(x=x)
  model.matrix(~.-1, data) %*% compression_matrix(x, name) / 2
}

#' @export
mangow_one.ordered <- function(x, name) {
  matrix((as.integer(x) - 1L) / (nlevels(x) - 1L), ncol = 1L, dimnames = list(NULL, name))
}
