context("Call")

test_that("Calling with Iris data set", {
  expect_true(is.matrix(mangow(iris)))

  iris_sub <- iris[seq.int(from = 1, to = nrow(iris), length.out = 18),]
  expect_equal(
    unname(as.matrix(cluster::daisy(iris_sub, metric = "gower"))),
    unname(as.matrix(cluster::daisy(mangow(iris_sub), metric = "manhattan"))))
})

test_that("Character vector not supported", {
  expect_error(mangow(data.frame(qwert=letters[1:3], stringsAsFactors = FALSE)),
               "manhattanize.*qwert")
})

test_that("Numeric and ordinal span whole [0, 1] interval", {
  num <- mangow(data.frame(x=1:10))
  ord <- mangow(data.frame(x=factor(1:10, ordered = TRUE)))
  expect_equal(num[1], 0)
  expect_equal(num[10], 1)
  expect_equal(ord[1], 0)
  expect_equal(ord[10], 1)
})
