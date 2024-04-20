# create sample tables for unit testing
# tables last created on: 2021-04-02 (tidytab version 0.0.0.9000)

# 0. setup ----
library(cli)
library(dplyr)
library(here)
library(readr)
library(stringr)
library(tidytab)
library(utils)

# 1. demonstrate 'oneway' flavor for one-way tables of frequencies ----
a <-
  mtcars |>
  count(gear) |>
  rename(Freq. = n) |>
  mutate(gear = as.character(gear))
a <-
  a |>
  add_row(gear = "Total", Freq. = sum(a[, 2]))
table_a <-
  capture.output(tidytab:::statascii(a, flavor = "oneway"))

# 2. demonstrate 'oneway' flavor with no padding ----
b <-
  mtcars |>
  count(gear) |>
  rename(Freq. = n) |>
  mutate(gear = as.character(gear))
b <-
  b |>
  add_row(gear = "Total", Freq. = sum(b[, 2]))
table_b <-
  capture.output(tidytab:::statascii(b, flavor = "oneway", padding = "none"))

# 3. demonstrate 'twoway' flavor for n-way tables of frequencies ----
c <-
  mtcars |>
  count(gear, carb, am) |>
  rename(Freq. = n) |>
  mutate(
    gear = as.character(gear),
    carb = as.character(carb),
    am = as.character(am)
  )
c <-
  c |>
  add_row(
    gear = "Total",
    carb = "",
    am = "",
    Freq. = sum(c[, 4])
  )
table_c <-
  capture.output(tidytab:::statascii(c, flavor = "twoway"))

# 4. demonstrate 'twoway' flavor with dashed group separator ----
d <-
  mtcars |>
  count(gear, carb, am) |>
  rename(Freq. = n) |>
  mutate(
    gear = as.character(gear),
    carb = as.character(carb),
    am = as.character(am)
  )
d <-
  d |>
  add_row(
    gear = "Total",
    carb = "",
    am = "",
    Freq. = sum(d[, 4])
  )
table_d <-
  capture.output(tidytab:::statascii(d, flavor = "twoway", separators = TRUE))

# 5. demonstrate 'summary' flavor for summary statistics ----
e <-
  mtcars |>
  group_by(gear) |>
  summarize(
    Obs = n(),
    Mean = mean(gear),
    "Std. Dev." = sd(gear),
    Min = min(gear),
    Max = max(gear)
  )
table_e <-
  capture.output(tidytab:::statascii(e, flavor = "summary", padding = "summary"))

# 6. demonstrate wrapping feature for wide tables ----
f <-
  mtcars |>
  mutate(
    cyl2 = cyl,
    vs2 = vs,
    am2 = am,
    carb2 = carb
  ) |>
  filter(gear != 5) |>
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
  ) |>
  rename(Freq. = n) |>
  mutate(gear = as.character(gear)) |>
  ungroup()
f <-
  f |>
  add_row(gear = "Total", Freq. = sum(f[, 10]))
f[is.na(f)] <- ""
options("width" = 80)
table_f <-
  capture.output(tidytab:::statascii(f, flavor = "oneway", separators = TRUE))

# 7. create list of tables and output to sample-data folder ----
tables <- list(table_a, table_b, table_c, table_d, table_e, table_f)
tables <- lapply(tables, ansi_strip)
write_rds(tables, here("tests", "testthat", "sample-tables.rds"))
