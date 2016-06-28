cluster_daisy_manhattan <- function(x, ...) {
  suppressWarnings(cluster::daisy(x, ..., metric = "manhattan"))
}
