library(tidytab)
library(testthat)
library(utils)
context("test-br.R")

test_that("br() throws an error when not given an input", {
  expect_error(br())
  expect_error(br(title = "test"))
})

test_that("br() invisibly returns its input", {
  expect_true(identical(br(mtcars), mtcars))
})
