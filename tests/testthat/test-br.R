library(tabr)
library(testthat)
library(utils)
context("test-br.R")

test_that("br() throws an error when not given an input", {
  expect_error(br())
  expect_error(br(NULL, title = "test"))
})
