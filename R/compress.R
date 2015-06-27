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

compression_matrix_data <- function(x) {
  lev <- levels(x)
  n_lev <- length(lev)
  n_full <- (n_lev - 1L) %/% 2L
  n_rem <- n_lev - 2L * n_full
  pm1 <- c(1, -1)
  full <- c(pm1, rep(0, length(lev)))

  c(rep(full, n_full), pm1[seq_len(n_rem)])
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
