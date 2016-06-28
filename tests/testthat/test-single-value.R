context("Column names")

data <- data.frame(
  numeric=0,
  integer=0L,
  factor=factor(letters[1]),
  ordered=factor(LETTERS[1], ordered = TRUE)
)

test_that("Single values", {
  data_res <- mangow(data)

  expect_equal(ncol(data_res), 0)
})
