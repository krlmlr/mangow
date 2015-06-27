context("Equivalence")

columns <- list(
  numeric=c(0,1,2,4),
  factor=factor(letters[1:3]),
  ordered=factor(LETTERS[1:3], ordered = TRUE)
)

funcs <- list(
  cluster = function(data) cluster::daisy(data, metric = "gower")
  , StatMatch = StatMatch::gower.dist
)

mapply(funcs, names(funcs), SIMPLIFY = FALSE, FUN = function(func, funcname) {
lapply(
  lapply(sets::set_power(names(columns)), unlist)[-1],
  function(sub_columns) {
    test_that(
      sprintf("%s: Equivalence with column(s) of type %s",
              funcname, paste0(sub_columns, collapse = ", ")),
      {
        data <- do.call(expand.grid, columns[sub_columns])
        expect_equal(
          unname(as.matrix(func(data))),
          unname(as.matrix(cluster::daisy(mangow(data), metric = "manhattan"))))
      }
    )
  }
)
})
