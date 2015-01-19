context("Call")

test_that("Calling with Iris data set", {
  expect_true(is.matrix(mangow(iris)))
})

test_that("Character vector not supported", {
  expect_error(mangow(data.frame(x=letters[1:3], stringsAsFactors = FALSE)), "manhattanize")
})
