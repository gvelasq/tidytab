# this R script creates sample tables for unit testing
# tables last created on: 20Mar18 (tabr version 0.0.0.9000)

# setup
library(dplyr)
library(here)
library(readr)
library(stringr)
library(tabr)
library(utils)

# a. demonstrate 'oneway' flavor for one-way tables of frequencies
a <- mtcars %>% count(gear) %>% rename(Freq. = n)
a <- a %>% add_row(gear = "Total", Freq. = sum(a[, 2]))
table_a <- capture.output(statascii(a, flavor = "oneway"))

# b. demonstrate 'oneway' flavor with no padding
b <- mtcars %>% count(gear) %>% rename(Freq. = n)
b <- b %>% add_row(gear = "Total", Freq. = sum(b[, 2]))
table_b <- capture.output(statascii(b, flavor = "oneway", padding = "none"))

# c. demonstrate 'twoway' flavor for n-way tables of frequencies
c <- mtcars %>% count(gear, carb, am) %>% rename(Freq. = n)
c <- c %>% ungroup() %>% add_row(gear = "Total", carb = "", am = "", Freq. = sum(c[, 4]))
table_c <- capture.output(statascii(c, flavor = "twoway"))

# d. demonstrate 'twoway' flavor with dashed group separator
d <- mtcars %>% count(gear, carb, am) %>% rename(Freq. = n)
d <- d %>% ungroup() %>% add_row(gear = "Total", carb = "", am = "", Freq. = sum(d[, 4]))
table_d <- capture.output(statascii(d, flavor = "twoway", separators = TRUE))

# e. demonstrate 'summary' flavor for summary statistics
e <- mtcars %>% group_by(gear) %>% summarize(
  Obs = n(),
  Mean = mean(gear),
  "Std. Dev." = sd(gear),
  Min = min(gear),
  Max = max(gear)
)
table_e <- capture.output(statascii(e, flavor = "summary", padding = "summary"))

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
table_f <- capture.output(statascii(f, flavor = "oneway", separators = TRUE))

# create list of tables and output to sample-data folder
tables <- list(table_a, table_b, table_c, table_d, table_e, table_f)
write_rds(tables, here("tests", "testthat", "sample-tables.rds"))
