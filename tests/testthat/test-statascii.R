library(dplyr)
library(here)
library(readr)
library(stringr)
library(tabr)
library(utils)
context("test-statascii.R")

tables <- read_rds("sample-tables.rds")

test_that("oneway flavor works", {
  # a. demonstrate 'oneway' flavor for one-way tables of frequencies
  a <- mtcars %>% count(gear) %>% rename(Freq. = n)
  a <- a %>% add_row(gear = "Total", Freq. = sum(a[, 2]))
  expect_equal(tables[[1]], utils::capture.output(statascii(a, flavor = "oneway")))
})

test_that("oneway flavor with no padding works", {
  # b. demonstrate 'oneway' flavor with no padding
  b <- mtcars %>% count(gear) %>% rename(Freq. = n)
  b <- b %>% add_row(gear = "Total", Freq. = sum(b[, 2]))
  expect_equal(tables[[2]], utils::capture.output(statascii(b, flavor = "oneway", padding = "none")))
})

test_that("twowway flavor works for 3-way table", {
  # c. demonstrate 'twoway' flavor for n-way tables of frequencies
  c <- mtcars %>% count(gear, carb, am) %>% rename(Freq. = n)
  c <- c %>% ungroup() %>% add_row(gear = "Total", carb = "", am = "", Freq. = sum(c[, 4]))
  expect_equal(tables[[3]], utils::capture.output(statascii(c, flavor = "twoway")))
})

test_that("twoway flavor works with dashed group separator", {
  # d. demonstrate 'twoway' flavor with dashed group separator
  d <- mtcars %>% count(gear, carb, am) %>% rename(Freq. = n)
  d <- d %>% ungroup() %>% add_row(gear = "Total", carb = "", am = "", Freq. = sum(d[, 4]))
  expect_equal(tables[[4]], utils::capture.output(statascii(d, flavor = "twoway", separators = TRUE)))
})

test_that("summary flavor works", {
  # e. demonstrate 'summary' flavor for summary statistics
  e <- mtcars %>% group_by(gear) %>% summarize(
    Obs = n(),
    Mean = mean(gear),
    "Std. Dev." = sd(gear),
    Min = min(gear),
    Max = max(gear)
  )
  expect_equal(tables[[5]], utils::capture.output(statascii(e, flavor = "summary")))
})

test_that("wrap_tbl() works", {
  # f. demonstrate wrapping feature for wide tables
  f <- mtcars %>%
    mutate(cyl2 = cyl, vs2 = vs, am2 = am, carb2 = carb) %>%
    filter(gear != 5) %>%
    count(gear, carb, am, vs, cyl, carb2, am2, vs2, cyl2) %>%
    rename(Freq. = n) %>%
    ungroup()
  f <- f %>% add_row(gear = "Total", Freq. = sum(f[, 10]))
  f[is.na(f)] <- ""
  options("width" = 80)
  expect_equal(tables[[6]], utils::capture.output(statascii(f, flavor = "oneway", separators = TRUE)))
})
