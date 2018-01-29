
<!-- README.md is generated from README.Rmd. Please edit that file -->
tabr
====

Create tables of frequencies

[![CRAN status](http://www.r-pkg.org/badges/version/tabr)](https://cran.r-project.org/package=tabr) [![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

Installation
------------

You can install statascii from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("gvelasq2/tabr")
```

Usage
-----

``` r
# setup
library(dplyr)
library(tabr)

# one-way table of frequencies
mtcars %>% tab(cyl)
#>       cyl │    Freq.  Percent     Cum. 
#> ──────────┼────────────────────────────
#>         4 │       11    34.38    34.38 
#>         6 │        7    21.88    56.25 
#>         8 │       14    43.75   100.00 
#> ──────────┼────────────────────────────
#>     Total │       32   100.00

# two-way table of frequencies (a 2x2 contingency table)
mtcars %>% tab(cyl, gear)
#>       cyl │     gear │    Freq.  Percent     Cum. 
#> ──────────┼──────────┼────────────────────────────
#>         4 │        3 │        1     3.12     3.12 
#>         4 │        4 │        8    25.00    28.12 
#>         4 │        5 │        2     6.25    34.38 
#> ----------┼----------┼----------------------------
#>         6 │        3 │        2     6.25    40.62 
#>         6 │        4 │        4    12.50    53.12 
#>         6 │        5 │        1     3.12    56.25 
#> ----------┼----------┼----------------------------
#>         8 │        3 │       12    37.50    93.75 
#>         8 │        5 │        2     6.25   100.00

# flat contingency tables of three or more variables
mtcars %>% tab(cyl, gear, am)
#>       cyl │     gear │       am │    Freq.  Percent     Cum. 
#> ──────────┼──────────┼──────────┼────────────────────────────
#>         4 │        3 │        0 │        1     3.12     3.12 
#>         4 │        4 │        0 │        2     6.25     9.38 
#>         4 │        4 │        1 │        6    18.75    28.12 
#>         4 │        5 │        1 │        2     6.25    34.38 
#> ----------┼----------┼----------┼----------------------------
#>         6 │        3 │        0 │        2     6.25    40.62 
#>         6 │        4 │        0 │        2     6.25    46.88 
#>         6 │        4 │        1 │        2     6.25    53.12 
#>         6 │        5 │        1 │        1     3.12    56.25 
#> ----------┼----------┼----------┼----------------------------
#>         8 │        3 │        0 │       12    37.50    93.75 
#>         8 │        5 │        1 │        2     6.25   100.00
mtcars %>% tab(cyl, gear, am, vs)
#>       cyl │     gear │       am │       vs │    Freq.  Percent     Cum. 
#> ──────────┼──────────┼──────────┼──────────┼────────────────────────────
#>         4 │        3 │        0 │        1 │        1     3.12     3.12 
#>         4 │        4 │        0 │        1 │        2     6.25     9.38 
#>         4 │        4 │        1 │        1 │        6    18.75    28.12 
#>         4 │        5 │        1 │        0 │        1     3.12    31.25 
#>         4 │        5 │        1 │        1 │        1     3.12    34.38 
#> ----------┼----------┼----------┼----------┼----------------------------
#>         6 │        3 │        0 │        1 │        2     6.25    40.62 
#>         6 │        4 │        0 │        1 │        2     6.25    46.88 
#>         6 │        4 │        1 │        0 │        2     6.25    53.12 
#>         6 │        5 │        1 │        0 │        1     3.12    56.25 
#> ----------┼----------┼----------┼----------┼----------------------------
#>         8 │        3 │        0 │        0 │       12    37.50    93.75 
#>         8 │        5 │        1 │        0 │        2     6.25   100.00

# ftab() creates only flat contingency tables (here, with two variables)
# mtcars %>% ftab(cyl, gear)

# tab1() produces one-way tables for each variable
# mtcars %>% tab1(cyl, gear)

# tab2() creates two-way tables for all variable combinations
# mtcars %>% tab2(cyl, gear, am)

# ta() is an even shorter alias for tab(), inspired by Stata
# mtcars %>% ta(gear)
```

------------------------------------------------------------------------

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
