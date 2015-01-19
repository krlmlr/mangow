context("Call")

test_that("Calling with Iris data set", {
  expect_true(is.matrix(mangow(iris)))
})
