library(cli)
library(dplyr)
library(here)
library(readr)
library(stringr)
library(tidytab)
library(utils)
context("test-statascii.R")

tables <- read_rds("sample-tables.rds")

test_that("data frame must have at least two columns", {
  expect_error(statascii(as.data.frame(letters[1:3])))
})

test_that("data frame must have at least three columns for 'twoway' flavor", {
  expect_error(statascii(as.data.frame(letters[1:3]), flavor = "twoway"))
})

test_that("oneway flavor works", {
  skip_on_os("windows")
  a <-
    mtcars %>%
    count(gear) %>%
    rename(Freq. = n) %>%
    mutate(gear = as.character(gear))
  a <-
    a %>%
    add_row(gear = "Total", Freq. = sum(a[, 2]))
  expect_equal(
    tables[[1]],
    ansi_strip(
      capture.output(tidytab:::statascii(a, flavor = "oneway"))
    )
  )
})

test_that("oneway flavor with no padding works", {
  skip_on_os("windows")
  b <-
    mtcars %>%
    count(gear) %>%
    rename(Freq. = n) %>%
    mutate(gear = as.character(gear))
  b <-
    b %>%
    add_row(gear = "Total", Freq. = sum(b[, 2]))
  expect_equal(
    tables[[2]],
    ansi_strip(
      capture.output(statascii(b, flavor = "oneway", padding = "none"))
    )
  )
})

test_that("twowway flavor works for 3-way table", {
  skip_on_os("windows")
  c <-
    mtcars %>%
    count(gear, carb, am) %>%
    rename(Freq. = n) %>%
    mutate(
      gear = as.character(gear),
      carb = as.character(carb),
      am = as.character(am)
    )
  c <-
    c %>%
    add_row(
      gear = "Total",
      carb = "",
      am = "",
      Freq. = sum(c[, 4])
    )
  expect_equal(
    tables[[3]],
    ansi_strip(
      capture.output(statascii(c, flavor = "twoway"))
    )
  )
})

test_that("twoway flavor works with dashed group separators", {
  skip_on_os("windows")
  d <-
    mtcars %>%
    count(gear, carb, am) %>%
    rename(Freq. = n) %>%
    mutate(
      gear = as.character(gear),
      carb = as.character(carb),
      am = as.character(am)
    )
  d <-
    d %>%
    add_row(
      gear = "Total",
      carb = "",
      am = "",
      Freq. = sum(d[, 4])
    )
  expect_equal(
    tables[[4]],
    ansi_strip(
      capture.output(statascii(d, flavor = "twoway", separators = TRUE))
    )
  )
})

test_that("summary flavor with summary padding works", {
  skip_on_os("windows")
  e <-
    mtcars %>%
    group_by(gear) %>%
    summarize(
      Obs = n(),
      Mean = mean(gear),
      "Std. Dev." = sd(gear),
      Min = min(gear),
      Max = max(gear)
    )
  expect_equal(
    tables[[5]],
    ansi_strip(
      capture.output(statascii(e, flavor = "summary", padding = "summary"))
    )
  )
})

test_that("wrap_tbl() works", {
  skip_on_os("windows")
  f <- mtcars %>%
    mutate(
      cyl2 = cyl,
      vs2 = vs,
      am2 = am,
      carb2 = carb
    ) %>%
    filter(gear != 5) %>%
    count(
      gear,
      carb,
      am,
      vs,
      cyl,
      carb2,
      am2,
      vs2,
      cyl2
    ) %>%
    rename(Freq. = n) %>%
    mutate(gear = as.character(gear)) %>%
    ungroup()
  f <- f %>% add_row(gear = "Total", Freq. = sum(f[, 10]))
  f[is.na(f)] <- ""
  options("width" = 80)
  expect_equal(
    tables[[6]],
    ansi_strip(
      capture.output(statascii(f, flavor = "oneway", separators = TRUE))
    )
  )
})
