context("Column names")

data <- data.frame(
  numeric=c(0,1,4),
  factor2=factor(letters[c(1,2,2)]),
  factor3=factor(letters[1:3]),
  factor4=factor(letters[1:3], levels = letters[1:4]),
  ordered=factor(LETTERS[1:3], ordered = TRUE),
  row.names=LETTERS[24:26]
)

test_that("Column names", {
  data_res <- mangow(data)

  expect_equal(colnames(data_res),
               c("numeric",
                 paste0("factor2.", c("a.b")),
                 paste0("factor3.", c("a.b", "c")),
                 paste0("factor4.", c("a.b", "c.d")),
                 "ordered"))

  expect_equal(rownames(data_res), LETTERS[24:26])
})
