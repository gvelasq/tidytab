
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidytab

> Create tidyverse-friendly tables of frequencies

<!-- badges: start -->

[![R-CMD-check](https://github.com/gvelasq/tidytab/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/gvelasq/tidytab/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/gvelasq/tidytab/branch/main/graph/badge.svg)](https://codecov.io/gh/gvelasq/tidytab?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/tidytab)](https://cran.r-project.org/package=tidytab)
[![R-universe
status](https://gvelasq.r-universe.dev/badges/tidytab)](https://gvelasq.r-universe.dev/tidytab)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Installation

You can install tidytab from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("gvelasq/tidytab")
```

## Usage

``` r
library(tidytab)

# one-way table of frequencies
mtcars |> tab(cyl)
#>         cyl │      Freq.     Percent        Cum. 
#> ────────────┼───────────────────────────────────
#>           4 │         11        34.4        34.4 
#>           6 │          7        21.9        56.2 
#>           8 │         14        43.8       100.0 
#> ────────────┼───────────────────────────────────
#>       Total │         32       100.0           

# two-way table of frequencies (a special 2x2 contingency table)
mtcars |> tab(cyl, gear)
#>            │      gear                       │           
#>        cyl │         3          4          5 │     Total 
#> ───────────┼─────────────────────────────────┼──────────
#>          4 │         1          8          2 │        11 
#>          6 │         2          4          1 │         7 
#>          8 │        12          0          2 │        14 
#> ───────────┼─────────────────────────────────┼──────────
#>      Total │        15         12          5 │        32

# flat contingency tables of three (or more) variables
mtcars |> tab(cyl, gear, am)
#>         cyl │       gear          am       Freq.     Percent        Cum. 
#> ────────────┼───────────────────────────────────────────────────────────
#>           4 │          3           0           1         3.1         3.1 
#>           4 │          4           0           2         6.2         9.4 
#>           4 │          4           1           6        18.8        28.1 
#>           4 │          5           1           2         6.2        34.4 
#> ------------┼-----------------------------------------------------------
#>           6 │          3           0           2         6.2        40.6 
#>           6 │          4           0           2         6.2        46.9 
#>           6 │          4           1           2         6.2        53.1 
#>           6 │          5           1           1         3.1        56.2 
#> ------------┼-----------------------------------------------------------
#>           8 │          3           0          12        37.5        93.8 
#>           8 │          5           1           2         6.2       100.0

# tables wider than the R console are automatically wrapped
mtcars |> tab(cyl, gear, am, vs)
#>         cyl │       gear          am          vs       Freq.     Percent
#> ────────────┼───────────────────────────────────────────────────────────
#>           4 │          3           0           1           1         3.1
#>           4 │          4           0           1           2         6.2
#>           4 │          4           1           1           6        18.8
#>           4 │          5           1           0           1         3.1
#>           4 │          5           1           1           1         3.1
#> ------------┼-----------------------------------------------------------
#>           6 │          3           0           1           2         6.2
#>           6 │          4           0           1           2         6.2
#>           6 │          4           1           0           2         6.2
#>           6 │          5           1           0           1         3.1
#> ------------┼-----------------------------------------------------------
#>           8 │          3           0           0          12        37.5
#>           8 │          5           1           0           2         6.2
#> 
#>         cyl │        Cum.
#> ────────────┼────────────
#>           4 │         3.1
#>           4 │         9.4
#>           4 │        28.1
#>           4 │        31.2
#>           4 │        34.4
#> ------------┼------------
#>           6 │        40.6
#>           6 │        46.9
#>           6 │        53.1
#>           6 │        56.2
#> ------------┼------------
#>           8 │        93.8
#>           8 │       100.0

# missing values are displayed in red
tab(letters[24:27])
#>   letters[24:27] │      Freq.     Percent        Cum. 
#> ─────────────────┼───────────────────────────────────
#>                x │          1        25.0        25.0 
#>                y │          1        25.0        50.0 
#>                z │          1        25.0        75.0 
#>               NA │          1        25.0       100.0 
#> ─────────────────┼───────────────────────────────────
#>            Total │          4       100.0           

# ftab() displays only flat contingency tables (here, with two variables)
mtcars |> ftab(cyl, gear)
#>         cyl │       gear       Freq.     Percent        Cum. 
#> ────────────┼───────────────────────────────────────────────
#>           4 │          3           1         3.1         3.1 
#>           4 │          4           8        25.0        28.1 
#>           4 │          5           2         6.2        34.4 
#> ------------┼-----------------------------------------------
#>           6 │          3           2         6.2        40.6 
#>           6 │          4           4        12.5        53.1 
#>           6 │          5           1         3.1        56.2 
#> ------------┼-----------------------------------------------
#>           8 │          3          12        37.5        93.8 
#>           8 │          5           2         6.2       100.0

# tab1() displays one-way tables for each variable
mtcars |> tab1(cyl, gear)
#>         cyl │      Freq.     Percent        Cum. 
#> ────────────┼───────────────────────────────────
#>           4 │         11        34.4        34.4 
#>           6 │          7        21.9        56.2 
#>           8 │         14        43.8       100.0 
#> ────────────┼───────────────────────────────────
#>       Total │         32       100.0            
#> 
#>        gear │      Freq.     Percent        Cum. 
#> ────────────┼───────────────────────────────────
#>           3 │         15        46.9        46.9 
#>           4 │         12        37.5        84.4 
#>           5 │          5        15.6       100.0 
#> ────────────┼───────────────────────────────────
#>       Total │         32       100.0           

# tab2() displays two-way tables for all variable combinations
mtcars |> tab2(cyl, gear, am)
#>            │      gear                       │           
#>        cyl │         3          4          5 │     Total 
#> ───────────┼─────────────────────────────────┼──────────
#>          4 │         1          8          2 │        11 
#>          6 │         2          4          1 │         7 
#>          8 │        12          0          2 │        14 
#> ───────────┼─────────────────────────────────┼──────────
#>      Total │        15         12          5 │        32 
#> 
#>            │        am            │           
#>        cyl │         0          1 │     Total 
#> ───────────┼──────────────────────┼──────────
#>          4 │         3          8 │        11 
#>          6 │         4          3 │         7 
#>          8 │        12          2 │        14 
#> ───────────┼──────────────────────┼──────────
#>      Total │        19         13 │        32 
#> 
#>            │        am            │           
#>       gear │         0          1 │     Total 
#> ───────────┼──────────────────────┼──────────
#>          3 │        15          0 │        15 
#>          4 │         4          8 │        12 
#>          5 │         0          5 │         5 
#> ───────────┼──────────────────────┼──────────
#>      Total │        19         13 │        32

# ta() is a shortened alias for tab(), inspired by Stata
mtcars |> ta(gear)
#>        gear │      Freq.     Percent        Cum. 
#> ────────────┼───────────────────────────────────
#>           3 │         15        46.9        46.9 
#>           4 │         12        37.5        84.4 
#>           5 │          5        15.6       100.0 
#> ────────────┼───────────────────────────────────
#>       Total │         32       100.0           
```

## Code of Conduct

Please note that the tidytab project is released with a [Contributor
Code of
Conduct](https://gvelasq.github.io/tidytab/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
