library(tabr)
library(tibble)
library(rlang)
context("test-tab.R")

test_that("tab(), ftab(), ctab(), ta(), tab1(), and tab2() throw errors without sufficient data input", {
  expect_error(tab())
  expect_error(ftab())
  expect_error(ctab())
  expect_error(ctab(mtcars, vs))
  expect_error(ta())
  expect_error(tab1())
  expect_error(tab2())
  expect_error(tab2(mtcars, vs))
})

test_that("tab(), ftab(), ctab(), and ta() invisibly return tibbles", {
  a <- mtcars
  a$vs[1] <- NA
  a$am[2] <- NA

  expect_true(is_tibble(tab(mtcars$vs)))
  expect_true(is_tibble(tab(mtcars, vs)))
  expect_true(is_tibble(tab(mtcars, vs, am)))

  expect_true(is_tibble(tab(a$vs, m = FALSE)))
  expect_true(is_tibble(tab(a, vs, m = FALSE)))
  expect_true(is_tibble(tab(a, vs, am, m = FALSE)))

  expect_true(is_tibble(ftab(mtcars$vs)))
  expect_true(is_tibble(ftab(mtcars, vs)))
  expect_true(is_tibble(ftab(mtcars, vs, am)))

  expect_true(is_tibble(ftab(a$vs, m = FALSE)))
  expect_true(is_tibble(ftab(a, vs, m = FALSE)))
  expect_true(is_tibble(ftab(a, vs, am, m = FALSE)))

  expect_true(is_tibble(ctab(mtcars, vs, am)))

  expect_true(is_tibble(ctab(a, vs, am, m = FALSE)))

  expect_true(is_tibble(ta(mtcars$vs)))
  expect_true(is_tibble(ta(mtcars, vs)))
  expect_true(is_tibble(ta(mtcars, vs, am)))

  expect_true(is_tibble(ta(a$vs, m = FALSE)))
  expect_true(is_tibble(ta(a, vs, m = FALSE)))
  expect_true(is_tibble(ta(a, vs, am, m = FALSE)))
})

test_that("tab1() and tab2() work", {
  a <- mtcars
  a$vs[1] <- NA
  a$am[2] <- NA
  a$gear[3] <- NA

  expect_true(is_tibble(tab1(mtcars$vs)))
  expect_true(is_null(tab1(mtcars, vs)))
  expect_true(is_null(tab1(mtcars, vs, am)))
  expect_true(is_null(tab2(mtcars, vs, am)))
  expect_true(is_null(tab2(mtcars, vs, am, gear)))

  expect_true(is_tibble(tab1(a$vs, m = FALSE)))
  expect_true(is_null(tab1(a, vs, m = FALSE)))
  expect_true(is_null(tab1(a, vs, am, m = FALSE)))
  expect_true(is_null(tab2(a, vs, am, m = FALSE)))
  expect_true(is_null(tab2(a, vs, am, gear, m = FALSE)))
})
