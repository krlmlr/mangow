context("Call")

test_that("Calling with Iris data set", {
  expect_true(is.matrix(mangow(iris)))

  iris_sub <- iris[seq.int(from = 1, to = nrow(iris), length.out = 18),]
  expect_equal(
    unname(as.matrix(cluster::daisy(iris_sub, metric = "gower"))),
    unname(as.matrix(cluster::daisy(mangow(iris_sub), metric = "manhattan"))))
})

test_that("Character vector not supported", {
  expect_error(mangow(data.frame(x=letters[1:3], stringsAsFactors = FALSE)), "manhattanize")
})
