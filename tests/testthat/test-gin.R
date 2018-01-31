library(tabr)
library(tibble)
context("test-gin.R")

test_that("%gin% works", {
  expect_true("t" %gin% "tonic")
  expect_true(is_tibble(tab(0 %gin% mtcars$vs)))
})
