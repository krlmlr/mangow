context("Column names")

data <- data.frame(
  numeric=c(0,1,4),
  factor=factor(letters[1:3]),
  ordered=factor(LETTERS[1:3], ordered = TRUE)
)

test_that("Column names", {
  data_res <- mangow(data)

  expect_equal(colnames(data_res),
               c("numeric", paste0("factor.", letters[1:3]), "ordered"))
})